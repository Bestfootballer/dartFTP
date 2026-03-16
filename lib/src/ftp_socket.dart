import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:ftpconnect/src/commands/commands.dart';

import '/src/ftp_reply.dart';
import '../ftpconnect.dart';

class FTPSocket {
  final String host;
  final int port;
  final Logger logger;
  final int timeout;
  SecurityType _securityType = SecurityType.ftp;
  final String user, pass;
  final String? account;

  /// This duration is used to set a delay for waiting responses from FTP server.
  final Duration sendingResponseDelay;
  late RawSocket _socket;
  TransferMode transferMode = TransferMode.passive;
  TransferType _transferType = TransferType.auto;
  ListCommand _listCommand = ListCommand.mlsd;
  bool supportIPV6 = false;
  StreamSubscription<RawSocketEvent>? _responseSubscription;
  Completer<List<FTPReply>> _responseCompleter = Completer<List<FTPReply>>();
  bool _isConnected = false;

  FTPSocket({
    required this.host,
    required this.port,
    required this.user,
    required this.pass,
    this.account,
    required SecurityType securityType,
    required this.logger,
    required this.timeout,
    this.sendingResponseDelay = const Duration(milliseconds: 100),
  }) : _securityType = securityType;

  set securityType(SecurityType pSecurityType) {
    _securityType = pSecurityType;
  }

  set listCommand(ListCommand command) {
    _listCommand = command;
  }

  ListCommand get listCommand => _listCommand;
  SecurityType get securityType => _securityType;

  Future<void> _cancelSubscriptions() async {
    await _responseSubscription?.cancel();
  }

  Future<void> _initSubscriptions() async {
    await _cancelSubscriptions();

    _responseSubscription = _socket.listen(
      (data) async {
        if (data == RawSocketEvent.closed) {
          _isConnected = false;

          _cancelSubscriptions();
          return;
        } else if (data == RawSocketEvent.read) {
          final splitted = <FTPReply>[];
          while (true) {
            if (_socket.available() > 0) {
              final line = utf8.decode(_socket.read()!);
              splitted.addAll(
                line
                    .trim()
                    .split('\n')
                    .map((e) {
                      logger.log('< $e');
                      return FTPReply.fromResponse(e);
                    })
                    .where((e) => e.code != FTPCode.serviceReady),
              );
              await Future.delayed(sendingResponseDelay);
            } else {
              break;
            }
            if (splitted.firstWhereOrNull(
                  (e) => e.code == FTPCode.serviceNotAvailable,
                ) !=
                null) {
              _isConnected = false;
              break;
            } else if (splitted.isNotEmpty) {
              _responseCompleter.complete(splitted);
              _responseCompleter = Completer<List<FTPReply>>();
            }
          }
        }
      },
      cancelOnError: true,
      onDone: () {
        _isConnected = false;
        _responseCompleter.completeError(
          FTPConnectionTimeoutException('Connection closed by server', ''),
        );
        _cancelSubscriptions();
      },
      onError: (_) {
        _isConnected = false;
        _responseCompleter.completeError(
          FTPConnectionTimeoutException('Connection closed by server', ''),
        );
        _cancelSubscriptions();
      },
    );
  }

  /// Set current transfer type of socket
  ///
  /// Supported types are: [TransferType.auto], [TransferType.ascii], [TransferType.binary],
  ///
  TransferType get transferType => _transferType;

  /// Read the FTP Server response from the Stream
  ///
  /// Blocks until data is received!
  Future<FTPReply> readResponse(List<FTPCode> codes) async {
    final response = await _responseCompleter.future;
    return response.firstWhere(
      (r) => codes.any((code) => code == r.code),
      orElse: () => response.firstWhere(
        (r) => r.isSuccessCode(),
        orElse: () {
          final reply = response.firstWhere(
            (e) => !e.isSuccessCode(),
            orElse: () => FTPReply(FTPCode.serviceNotAvailable, ''),
          );
          log('< ${reply.code} ${reply.message} ${reply.code.exception}');

          throw reply.code.exception;
        },
      ),
    );
  }

  /// Send a command [cmd] to the FTP Server
  /// if [waitResponse] the function waits for the reply, other wise return ''
  Future<FTPReply> sendCommand(String cmd) async {
    if (!_isConnected) {
      await connect();
    }
    final code = FTPCode.fromCommand(
      Commands.get(cmd.split(RegExp(r'\s+'))[0]),
    );
    sendCommandWithoutWaitingResponse(cmd);

    return await readResponse([code!]);
  }

  /// Send a command [cmd] to the FTP Server
  /// if [waitResponse] the function waits for the reply, other wise return ''
  void sendCommandWithoutWaitingResponse(String cmd) async {
    logger.log('> $cmd');
    log('> $cmd');
    _socket.write(utf8.encode('$cmd\r\n'));
  }

  /// Connect to the FTP Server and Login with [user] and [pass]
  Future<bool> connect() async {
    logger.log('Connecting...');

    final timeout = Duration(seconds: this.timeout);

    try {
      // FTPS starts secure

      _socket = await RawSocket.connect(host, port, timeout: timeout);
      await _initSubscriptions();
      logger.log('Connection established, waiting for welcome message...');
      _isConnected = true;
    } catch (e) {
      logger.log('Connection failed: ${e.toString()}');
      await _cancelSubscriptions();
      throw FTPConnectException(
        'Could not connect to $host ($port)',
        e.toString(),
      );
    }

    // FTPES needs to be upgraded prior to getting a welcome
    if (_securityType == SecurityType.ftpes ||
        _securityType == SecurityType.ftps) {
      FTPReply lResp = await sendCommand('AUTH TLS');
      if (lResp.code == FTPCode.notLoggedIn) {
        await _authenticate();
        if (!lResp.isSuccessCode()) {
          throw FTPESConnectException(
            'FTPES cannot be applied: the server refused both AUTH TLS and AUTH SSL commands',
            lResp.message,
          );
        }
      }
      _socket = await RawSecureSocket.secure(
        _socket,
        onBadCertificate: (certificate) => true,
      );
    }

    if ([SecurityType.ftpes, SecurityType.ftps].contains(_securityType)) {
      await sendCommand('PBSZ 0');
      await sendCommand('PROT P');
    }

    await _authenticate();

    logger.log('Connected!');
    return true;
  }

  Future<void> _authenticate() async {
    // Send Username
    FTPReply lResp = await sendCommand('USER $user');

    if (lResp.code == FTPCode.serviceNotAvailable) {
      throw FTPConnectException(
        'Service not available, closing control connection.',
        lResp.message,
      );
    }

    //password required
    if (lResp.code == FTPCode.needPassword) {
      lResp = await sendCommand('PASS $pass');
      if (lResp.code == FTPCode.needAccount) {
        if (account == null) {
          throw FTPAccountRequiredException('Account required');
        }
        lResp = await sendCommand('ACCT $account');
        if (!lResp.isSuccessCode()) {
          throw FTPWrongCredentialsException('Wrong Account', lResp.message);
        }
      } else if (!lResp.isSuccessCode()) {
        throw FTPWrongCredentialsException(
          'Wrong Username/password',
          lResp.message,
        );
      }
      //account required
    } else if (lResp.code == FTPCode.needAccount) {
      if (account == null) {
        throw FTPAccountRequiredException('Account required');
      }
      lResp = await sendCommand('ACCT $account');
      if (!lResp.isSuccessCode()) {
        throw FTPWrongCredentialsException('Wrong Account', lResp.message);
      }
    } else if (!lResp.isSuccessCode()) {
      throw FTPWrongCredentialsException('Wrong username $user', lResp.message);
    }
  }

  Future<FTPReply> openDataTransferChannel() async {
    FTPReply res = FTPReply(FTPCode.commandOkay, '');
    if (transferMode == TransferMode.active) {
      //todo later
    } else {
      res = await sendCommand('EPSV');
      if (!res.isSuccessCode()) {
        throw FTPUnablePassiveModeException(
          'Could not start Passive Mode',
          res.message,
        );
      } else if (res.code != FTPCode.extendedPassiveMode) {
        res = await readResponse([FTPCode.extendedPassiveMode]);
        if (!res.isSuccessCode()) {
          throw FTPUnablePassiveModeException(
            'Could not start Passive Mode',
            res.message,
          );
        }
      }
    }

    return res;
  }

  /// Set the Transfer mode on [socket] to [mode]
  Future<void> setTransferType(TransferType pTransferType) async {
    //if we already in the same transfer type we do nothing
    if (_transferType == pTransferType) return;
    switch (pTransferType) {
      case TransferType.auto:
        // Set to ASCII mode
        await sendCommand('TYPE A');
        break;
      case TransferType.ascii:
        // Set to ASCII mode
        await sendCommand('TYPE A');
        break;
      case TransferType.binary:
        // Set to BINARY mode
        await sendCommand('TYPE I');
        break;
    }
    _transferType = pTransferType;
  }

  // Disconnect from the FTP Server
  Future<bool> disconnect() async {
    logger.log('Disconnecting...');

    try {
      await sendCommand('QUIT');
    } catch (ignored) {
      // Ignore
    } finally {
      _isConnected = false;
      await _socket.close();
      _socket.shutdown(SocketDirection.both);
      await _cancelSubscriptions();
    }

    logger.log('Disconnected!');
    return true;
  }
}
