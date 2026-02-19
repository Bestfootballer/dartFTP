import 'package:collection/collection.dart';

enum FTPCode {
  // 1xx - Preliminary Replies
  RestartMarker(110),
  ServiceReadyDelay(120),
  DataConnectionAlreadyOpen(125),
  OpeningDataConnection(150),
  // 2xx - Positive Completion Replies
  CommandOkay(200),
  CommandNotImplementedSuperfluous(202),
  SystemStatus(211),
  DirectoryStatus(212),
  FileStatus(213),
  HelpMessage(214),
  SystemType(215),
  ServiceReady(220),
  ClosingConnection(221),
  DataConnectionOpen(225),
  ClosingDataConnection(226),
  PassiveMode(227),
  LongPassiveMode(228),
  ExtendedPassiveMode(229),
  UserLoggedIn(230),
  FileActionComplete(250),
  PathnameCreated(257),
  // 3xx - Intermediate Positive Replies
  NeedPassword(331),
  NeedAccount(332),
  PendingFurtherInformation(350),
  // 4xx - Transient Negative Replies
  ServiceNotAvailable(421),
  DataConnectionError(425),
  TransferAborted(426),
  InvalidCredentials(430),
  HostUnavailable(434),
  FileActionNotTaken(450),
  LocalError(451),
  InsufficientStorage(452),
  // 5xx - Permanent Negative Replies
  SyntaxError(500),
  ParameterError(501),
  CommandNotImplemented(502),
  BadSequence(503),
  NotImplementedForParameter(504),
  NotLoggedIn(530),
  NeedAccountForStorage(532),
  FileUnavailable(550),
  PageTypeUnknown(551),
  ExceededStorage(552),
  FileNameNotAllowed(553);

  final int code;

  const FTPCode(this.code);

  static FTPCode? fromCode(int code) {
    return FTPCode.values.firstWhereOrNull((ftpCode) => ftpCode.code == code);
  }

  bool get isError => code >= 400;

  Exception get exception {
    return switch (this) {
      FTPCode.RestartMarker => FTPRestartMarkerException(
        "Restart marker reply.",
      ),
      FTPCode.ServiceReadyDelay => FTPServiceReadyDelayException(
        "Service ready in nnn minutes.",
      ),
      FTPCode.DataConnectionAlreadyOpen =>
        FTPDataConnectionAlreadyOpenException(
          "Data connection already open; transfer starting.",
        ),
      FTPCode.OpeningDataConnection => FTPOpeningDataConnectionException(
        "File status okay; about to open data connection.",
      ),
      FTPCode.CommandOkay => FTPCommandOkayException("Command okay."),
      FTPCode.CommandNotImplementedSuperfluous =>
        FTPCommandNotImplementedSuperfluousException(
          "Command not implemented, superfluous at this site.",
        ),
      FTPCode.SystemStatus => FTPSystemStatusException(
        "System status, or system help reply.",
      ),
      FTPCode.DirectoryStatus => FTPDirectoryStatusException(
        "Directory status.",
      ),
      FTPCode.FileStatus => FTPFileStatusException("File status."),
      FTPCode.HelpMessage => FTPHelpMessageException("Help message."),
      FTPCode.SystemType => FTPSystemTypeException("NAME system type."),
      FTPCode.ServiceReady => FTPServiceReadyException(
        "Service ready for new user.",
      ),
      FTPCode.ClosingConnection => FTPClosingConnectionException(
        "Service closing control connection.",
      ),
      FTPCode.DataConnectionOpen => FTPDataConnectionOpenException(
        "Data connection open; no transfer in progress.",
      ),
      FTPCode.ClosingDataConnection => FTPClosingDataConnectionException(
        "Closing data connection.",
      ),
      FTPCode.PassiveMode => FTPPassiveModeException(
        "Entering Passive Mode (h1,h2,h3,h4,p1,p2).",
      ),
      FTPCode.LongPassiveMode => FTPLongPassiveModeException(
        "Entering Long Passive Mode (long address, port).",
      ),
      FTPCode.ExtendedPassiveMode => FTPExtendedPassiveModeException(
        "Entering Extended Passive Mode (|||port|).",
      ),
      FTPCode.UserLoggedIn => FTPUserLoggedInException(
        "User logged in, proceed.",
      ),
      FTPCode.FileActionComplete => FTPFileActionCompleteException(
        "Requested file action okay, completed.",
      ),
      FTPCode.PathnameCreated => FTPPathnameCreatedException(
        "\"PATHNAME\" created.",
      ),
      FTPCode.NeedPassword => FTPNeedPasswordException(
        "User name okay, need password.",
      ),
      FTPCode.NeedAccount => FTPNeedAccountException("Need account for login."),
      FTPCode.PendingFurtherInformation =>
        FTPPendingFurtherInformationException(
          "Requested file action pending further information.",
        ),
      FTPCode.ServiceNotAvailable => FTPServiceNotAvailableException(
        "Service not available, closing control connection.",
      ),
      FTPCode.DataConnectionError => FTPDataConnectionErrorException(
        "Can't open data connection.",
      ),
      FTPCode.TransferAborted => FTPTransferAbortedException(
        "Connection closed; transfer aborted.",
      ),
      FTPCode.InvalidCredentials => FTPInvalidCredentialsException(
        "Invalid username or password.",
      ),
      FTPCode.HostUnavailable => FTPHostUnavailableException(
        "Requested host unavailable.",
      ),
      FTPCode.FileActionNotTaken => FTPFileActionNotTakenException(
        "Requested file action not taken.",
      ),
      FTPCode.LocalError => FTPLocalErrorException(
        "Requested action aborted; local error in processing.",
      ),
      FTPCode.InsufficientStorage => FTPInsufficientStorageException(
        "Requested action not taken. Insufficient storage space in system.",
      ),
      FTPCode.SyntaxError => FTPSyntaxErrorException(
        "Syntax error, command unrecognized.",
      ),
      FTPCode.ParameterError => FTPParameterErrorException(
        "Syntax error in parameters or arguments.",
      ),
      FTPCode.CommandNotImplemented => FTPCommandNotImplementedException(
        "Command not implemented.",
      ),
      FTPCode.BadSequence => FTPBadSequenceException(
        "Bad sequence of commands.",
      ),
      FTPCode.NotImplementedForParameter =>
        FTPNotImplementedForParameterException(
          "Command not implemented for that parameter.",
        ),
      FTPCode.NotLoggedIn => FTPNotLoggedInException("Not logged in."),
      FTPCode.NeedAccountForStorage => FTPNeedAccountForStorageException(
        "Need account for storing files.",
      ),
      FTPCode.FileUnavailable => FTPFileUnavailableException(
        "Requested action not taken. File unavailable (e.g., file not found, no access).",
      ),
      FTPCode.PageTypeUnknown => FTPPageTypeUnknownException(
        "Requested action aborted; page type unknown.",
      ),
      FTPCode.ExceededStorage => FTPExceededStorageException(
        "Requested file action aborted. Exceeded storage allocation (for current directory or dataset).",
      ),
      FTPCode.FileNameNotAllowed => FTPFileNameNotAllowedException(
        "Requested action not taken. File name not allowed.",
      ),
    };
  }
}

/// Base exception class for general FTP connection and protocol errors
class FTPConnectException implements Exception {
  final String message;
  final String? response;

  FTPConnectException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPConnectException: $message (Response: $response)';
  }
}

class FTPParsingErrorException implements Exception {
  final String message;
  final String? response;

  FTPParsingErrorException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPParsingErrorException: $message (Response: $response)';
  }
}

class FTPConnectionTimeoutException implements Exception {
  final String message;
  final String? response;

  FTPConnectionTimeoutException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPConnectionTimeoutException: $message (Response: $response)';
  }
}

class FTPIllegalReplyException implements Exception {
  final String message;
  final String? response;

  FTPIllegalReplyException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPIllegalReplyException: $message (Response: $response)';
  }
}

class FTPESConnectException implements Exception {
  final String message;
  final String? response;

  FTPESConnectException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPESConnectException: $message (Response: $response)';
  }
}

class FTPAccountRequiredException implements Exception {
  final String message;
  final String? response;

  FTPAccountRequiredException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPAccountRequiredException: $message (Response: $response)';
  }
}

class FTPWrongCredentialsException implements Exception {
  final String message;
  final String? response;

  FTPWrongCredentialsException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPWrongCredentialsException: $message (Response: $response)';
  }
}

class FTPUnablePassiveModeException implements Exception {
  final String message;
  final String? response;

  FTPUnablePassiveModeException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPUnablePassiveModeException: $message (Response: $response)';
  }
}

class FTPCannotChangeDirectoryException implements Exception {
  final String message;
  final String? response;

  FTPCannotChangeDirectoryException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPCannotChangeDirectoryException: $message (Response: $response)';
  }
}

class FTPCannotDeleteFolderException implements Exception {
  final String message;
  final String? response;

  FTPCannotDeleteFolderException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPCannotDeleteFolderException: $message (Response: $response)';
  }
}

class FTPCannotDeleteFileException implements Exception {
  final String message;
  final String? response;

  FTPCannotDeleteFileException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPCannotDeleteFileException: $message (Response: $response)';
  }
}

class FTPCannotDownloadException implements Exception {
  final String message;
  final String? response;

  FTPCannotDownloadException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPCannotDownloadException: $message (Response: $response)';
  }
}

class FTPFileNotExistsException implements Exception {
  final String message;
  final String? response;

  FTPFileNotExistsException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPFileNotExistsException: $message (Response: $response)';
  }
}

class FTPConnectionRefusedException implements Exception {
  final String message;
  final String? response;

  FTPConnectionRefusedException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPConnectionRefusedException: $message (Response: $response)';
  }
}

class FTPTransferException implements Exception {
  final String message;
  final String? response;

  FTPTransferException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPTransferException: $message (Response: $response)';
  }
}

class FTPUnableToGetCWDException implements Exception {
  final String message;
  final String? response;

  FTPUnableToGetCWDException(this.message, [this.response]);

  @override
  String toString() {
    return 'FTPUnableToGetCWDException: $message (Response: $response)';
  }
}

/// ============================================================================
/// FTP 1xx Error Code Exceptions - Preliminary Replies (RFC 959)
/// ============================================================================

class FTPRestartMarkerException implements Exception {
  final String message;
  final String? response;

  FTPRestartMarkerException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPRestartMarkerException: $message (Response: $response)';
}

class FTPServiceReadyDelayException implements Exception {
  final String message;
  final String? response;

  FTPServiceReadyDelayException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPServiceReadyDelayException: $message (Response: $response)';
}

class FTPDataConnectionAlreadyOpenException implements Exception {
  final String message;
  final String? response;

  FTPDataConnectionAlreadyOpenException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPDataConnectionAlreadyOpenException: $message (Response: $response)';
}

class FTPOpeningDataConnectionException implements Exception {
  final String message;
  final String? response;

  FTPOpeningDataConnectionException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPOpeningDataConnectionException: $message (Response: $response)';
}

/// ============================================================================
/// FTP 2xx Error Code Exceptions - Positive Completion Replies (RFC 959)
/// ============================================================================

class FTPCommandOkayException implements Exception {
  final String message;
  final String? response;

  FTPCommandOkayException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPCommandOkayException: $message (Response: $response)';
}

class FTPCommandNotImplementedSuperfluousException implements Exception {
  final String message;
  final String? response;

  FTPCommandNotImplementedSuperfluousException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPCommandNotImplementedSuperfluousException: $message (Response: $response)';
}

class FTPSystemStatusException implements Exception {
  final String message;
  final String? response;

  FTPSystemStatusException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPSystemStatusException: $message (Response: $response)';
}

class FTPDirectoryStatusException implements Exception {
  final String message;
  final String? response;

  FTPDirectoryStatusException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPDirectoryStatusException: $message (Response: $response)';
}

class FTPFileStatusException implements Exception {
  final String message;
  final String? response;

  FTPFileStatusException(this.message, [this.response]);

  @override
  String toString() => 'FTPFileStatusException: $message (Response: $response)';
}

class FTPHelpMessageException implements Exception {
  final String message;
  final String? response;

  FTPHelpMessageException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPHelpMessageException: $message (Response: $response)';
}

class FTPSystemTypeException implements Exception {
  final String message;
  final String? response;

  FTPSystemTypeException(this.message, [this.response]);

  @override
  String toString() => 'FTPSystemTypeException: $message (Response: $response)';
}

class FTPServiceReadyException implements Exception {
  final String message;
  final String? response;

  FTPServiceReadyException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPServiceReadyException: $message (Response: $response)';
}

class FTPClosingConnectionException implements Exception {
  final String message;
  final String? response;

  FTPClosingConnectionException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPClosingConnectionException: $message (Response: $response)';
}

class FTPDataConnectionOpenException implements Exception {
  final String message;
  final String? response;

  FTPDataConnectionOpenException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPDataConnectionOpenException: $message (Response: $response)';
}

class FTPClosingDataConnectionException implements Exception {
  final String message;
  final String? response;

  FTPClosingDataConnectionException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPClosingDataConnectionException: $message (Response: $response)';
}

class FTPPassiveModeException implements Exception {
  final String message;
  final String? response;

  FTPPassiveModeException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPPassiveModeException: $message (Response: $response)';
}

class FTPLongPassiveModeException implements Exception {
  final String message;
  final String? response;

  FTPLongPassiveModeException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPLongPassiveModeException: $message (Response: $response)';
}

class FTPExtendedPassiveModeException implements Exception {
  final String message;
  final String? response;

  FTPExtendedPassiveModeException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPExtendedPassiveModeException: $message (Response: $response)';
}

class FTPUserLoggedInException implements Exception {
  final String message;
  final String? response;

  FTPUserLoggedInException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPUserLoggedInException: $message (Response: $response)';
}

class FTPFileActionCompleteException implements Exception {
  final String message;
  final String? response;

  FTPFileActionCompleteException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPFileActionCompleteException: $message (Response: $response)';
}

class FTPPathnameCreatedException implements Exception {
  final String message;
  final String? response;

  FTPPathnameCreatedException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPPathnameCreatedException: $message (Response: $response)';
}

/// ============================================================================
/// FTP 3xx Error Code Exceptions - Intermediate Positive Replies (RFC 959)
/// ============================================================================

class FTPNeedPasswordException implements Exception {
  final String message;
  final String? response;

  FTPNeedPasswordException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPNeedPasswordException: $message (Response: $response)';
}

class FTPNeedAccountException implements Exception {
  final String message;
  final String? response;

  FTPNeedAccountException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPNeedAccountException: $message (Response: $response)';
}

class FTPPendingFurtherInformationException implements Exception {
  final String message;
  final String? response;

  FTPPendingFurtherInformationException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPPendingFurtherInformationException: $message (Response: $response)';
}

/// ============================================================================
/// FTP 4xx Error Code Exceptions - Transient Negative Replies (RFC 959)
/// ============================================================================

class FTPServiceNotAvailableException implements Exception {
  final String message;
  final String? response;

  FTPServiceNotAvailableException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPServiceNotAvailableException: $message (Response: $response)';
}

class FTPDataConnectionErrorException implements Exception {
  final String message;
  final String? response;

  FTPDataConnectionErrorException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPDataConnectionErrorException: $message (Response: $response)';
}

class FTPTransferAbortedException implements Exception {
  final String message;
  final String? response;

  FTPTransferAbortedException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPTransferAbortedException: $message (Response: $response)';
}

class FTPInvalidCredentialsException implements Exception {
  final String message;
  final String? response;

  FTPInvalidCredentialsException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPInvalidCredentialsException: $message (Response: $response)';
}

class FTPHostUnavailableException implements Exception {
  final String message;
  final String? response;

  FTPHostUnavailableException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPHostUnavailableException: $message (Response: $response)';
}

class FTPFileActionNotTakenException implements Exception {
  final String message;
  final String? response;

  FTPFileActionNotTakenException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPFileActionNotTakenException: $message (Response: $response)';
}

class FTPLocalErrorException implements Exception {
  final String message;
  final String? response;

  FTPLocalErrorException(this.message, [this.response]);

  @override
  String toString() => 'FTPLocalErrorException: $message (Response: $response)';
}

class FTPInsufficientStorageException implements Exception {
  final String message;
  final String? response;

  FTPInsufficientStorageException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPInsufficientStorageException: $message (Response: $response)';
}

/// ============================================================================
/// FTP 5xx Error Code Exceptions - Permanent Negative Replies (RFC 959)
/// ============================================================================

class FTPSyntaxErrorException implements Exception {
  final String message;
  final String? response;

  FTPSyntaxErrorException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPSyntaxErrorException: $message (Response: $response)';
}

class FTPParameterErrorException implements Exception {
  final String message;
  final String? response;

  FTPParameterErrorException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPParameterErrorException: $message (Response: $response)';
}

class FTPCommandNotImplementedException implements Exception {
  final String message;
  final String? response;

  FTPCommandNotImplementedException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPCommandNotImplementedException: $message (Response: $response)';
}

class FTPBadSequenceException implements Exception {
  final String message;
  final String? response;

  FTPBadSequenceException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPBadSequenceException: $message (Response: $response)';
}

class FTPNotImplementedForParameterException implements Exception {
  final String message;
  final String? response;

  FTPNotImplementedForParameterException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPNotImplementedForParameterException: $message (Response: $response)';
}

class FTPNotLoggedInException implements Exception {
  final String message;
  final String? response;

  FTPNotLoggedInException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPNotLoggedInException: $message (Response: $response)';
}

class FTPNeedAccountForStorageException implements Exception {
  final String message;
  final String? response;

  FTPNeedAccountForStorageException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPNeedAccountForStorageException: $message (Response: $response)';
}

class FTPFileUnavailableException implements Exception {
  final String message;
  final String? response;

  FTPFileUnavailableException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPFileUnavailableException: $message (Response: $response)';
}

class FTPPageTypeUnknownException implements Exception {
  final String message;
  final String? response;

  FTPPageTypeUnknownException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPPageTypeUnknownException: $message (Response: $response)';
}

class FTPExceededStorageException implements Exception {
  final String message;
  final String? response;

  FTPExceededStorageException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPExceededStorageException: $message (Response: $response)';
}

class FTPFileNameNotAllowedException implements Exception {
  final String message;
  final String? response;

  FTPFileNameNotAllowedException(this.message, [this.response]);

  @override
  String toString() =>
      'FTPFileNameNotAllowedException: $message (Response: $response)';
}
