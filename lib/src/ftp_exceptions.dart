import 'package:collection/collection.dart';

enum FTPCode {
  // 1xx - Preliminary Replies
  restartMarker(110),
  serviceReadyDelay(120),
  dataConnectionAlreadyOpen(125),
  openingDataConnection(150),
  // 2xx - Positive Completion Replies
  commandOkay(200),
  commandNotImplementedSuperfluous(202),
  systemStatus(211),
  directoryStatus(212),
  fileStatus(213),
  helpMessage(214),
  systemType(215),
  serviceReady(220),
  closingConnection(221),
  dataConnectionOpen(225),
  closingDataConnection(226),
  passiveMode(227),
  longPassiveMode(228),
  extendedPassiveMode(229),
  userLoggedIn(230),
  fileActionComplete(250),
  pathnameCreated(257),
  // 3xx - Intermediate Positive Replies
  needPassword(331),
  needAccount(332),
  pendingFurtherInformation(350),
  // 4xx - Transient Negative Replies
  serviceNotAvailable(421),
  dataConnectionError(425),
  transferAborted(426),
  invalidCredentials(430),
  hostUnavailable(434),
  fileActionNotTaken(450),
  localError(451),
  insufficientStorage(452),
  // 5xx - Permanent Negative Replies
  syntaxError(500),
  parameterError(501),
  commandNotImplemented(502),
  badSequence(503),
  notImplementedForParameter(504),
  notLoggedIn(530),
  needAccountForStorage(532),
  fileUnavailable(550),
  pageTypeUnknown(551),
  exceededStorage(552),
  fileNameNotAllowed(553);

  final int code;

  const FTPCode(this.code);

  static FTPCode? fromCode(int code) {
    return FTPCode.values.firstWhereOrNull((ftpCode) => ftpCode.code == code);
  }

  bool get isError => code >= 400;

  Exception get exception {
    return switch (this) {
      FTPCode.restartMarker => FTPRestartMarkerException(
        "Restart marker reply.",
      ),
      FTPCode.serviceReadyDelay => FTPServiceReadyDelayException(
        "Service ready in nnn minutes.",
      ),
      FTPCode.dataConnectionAlreadyOpen =>
        FTPDataConnectionAlreadyOpenException(
          "Data connection already open; transfer starting.",
        ),
      FTPCode.openingDataConnection => FTPOpeningDataConnectionException(
        "File status okay; about to open data connection.",
      ),
      FTPCode.commandOkay => FTPCommandOkayException("Command okay."),
      FTPCode.commandNotImplementedSuperfluous =>
        FTPCommandNotImplementedSuperfluousException(
          "Command not implemented, superfluous at this site.",
        ),
      FTPCode.systemStatus => FTPSystemStatusException(
        "System status, or system help reply.",
      ),
      FTPCode.directoryStatus => FTPDirectoryStatusException(
        "Directory status.",
      ),
      FTPCode.fileStatus => FTPFileStatusException("File status."),
      FTPCode.helpMessage => FTPHelpMessageException("Help message."),
      FTPCode.systemType => FTPSystemTypeException("NAME system type."),
      FTPCode.serviceReady => FTPServiceReadyException(
        "Service ready for new user.",
      ),
      FTPCode.closingConnection => FTPClosingConnectionException(
        "Service closing control connection.",
      ),
      FTPCode.dataConnectionOpen => FTPDataConnectionOpenException(
        "Data connection open; no transfer in progress.",
      ),
      FTPCode.closingDataConnection => FTPClosingDataConnectionException(
        "Closing data connection.",
      ),
      FTPCode.passiveMode => FTPPassiveModeException(
        "Entering Passive Mode (h1,h2,h3,h4,p1,p2).",
      ),
      FTPCode.longPassiveMode => FTPLongPassiveModeException(
        "Entering Long Passive Mode (long address, port).",
      ),
      FTPCode.extendedPassiveMode => FTPExtendedPassiveModeException(
        "Entering Extended Passive Mode (|||port|).",
      ),
      FTPCode.userLoggedIn => FTPUserLoggedInException(
        "User logged in, proceed.",
      ),
      FTPCode.fileActionComplete => FTPFileActionCompleteException(
        "Requested file action okay, completed.",
      ),
      FTPCode.pathnameCreated => FTPPathnameCreatedException(
        "\"PATHNAME\" created.",
      ),
      FTPCode.needPassword => FTPNeedPasswordException(
        "User name okay, need password.",
      ),
      FTPCode.needAccount => FTPNeedAccountException("Need account for login."),
      FTPCode.pendingFurtherInformation =>
        FTPPendingFurtherInformationException(
          "Requested file action pending further information.",
        ),
      FTPCode.serviceNotAvailable => FTPServiceNotAvailableException(
        "Service not available, closing control connection.",
      ),
      FTPCode.dataConnectionError => FTPDataConnectionErrorException(
        "Can't open data connection.",
      ),
      FTPCode.transferAborted => FTPTransferAbortedException(
        "Connection closed; transfer aborted.",
      ),
      FTPCode.invalidCredentials => FTPInvalidCredentialsException(
        "Invalid username or password.",
      ),
      FTPCode.hostUnavailable => FTPHostUnavailableException(
        "Requested host unavailable.",
      ),
      FTPCode.fileActionNotTaken => FTPFileActionNotTakenException(
        "Requested file action not taken.",
      ),
      FTPCode.localError => FTPLocalErrorException(
        "Requested action aborted; local error in processing.",
      ),
      FTPCode.insufficientStorage => FTPInsufficientStorageException(
        "Requested action not taken. Insufficient storage space in system.",
      ),
      FTPCode.syntaxError => FTPSyntaxErrorException(
        "Syntax error, command unrecognized.",
      ),
      FTPCode.parameterError => FTPParameterErrorException(
        "Syntax error in parameters or arguments.",
      ),
      FTPCode.commandNotImplemented => FTPCommandNotImplementedException(
        "Command not implemented.",
      ),
      FTPCode.badSequence => FTPBadSequenceException(
        "Bad sequence of commands.",
      ),
      FTPCode.notImplementedForParameter =>
        FTPNotImplementedForParameterException(
          "Command not implemented for that parameter.",
        ),
      FTPCode.notLoggedIn => FTPNotLoggedInException("Not logged in."),
      FTPCode.needAccountForStorage => FTPNeedAccountForStorageException(
        "Need account for storing files.",
      ),
      FTPCode.fileUnavailable => FTPFileUnavailableException(
        "Requested action not taken. File unavailable (e.g., file not found, no access).",
      ),
      FTPCode.pageTypeUnknown => FTPPageTypeUnknownException(
        "Requested action aborted; page type unknown.",
      ),
      FTPCode.exceededStorage => FTPExceededStorageException(
        "Requested file action aborted. Exceeded storage allocation (for current directory or dataset).",
      ),
      FTPCode.fileNameNotAllowed => FTPFileNameNotAllowedException(
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
