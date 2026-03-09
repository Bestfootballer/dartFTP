import 'dart:core';

import 'package:ftpconnect/src/ftp_exceptions.dart';

class FTPReply {
  final FTPCode code;
  final String message;

  FTPReply(this.code, this.message);

  bool isSuccessCode() => code.code >= 100 && code.code < 400;

  factory FTPReply.fromResponse(String response) {
    final code = int.tryParse(response.substring(0, 3));
    if (code == null) {
      throw FTPIllegalReplyException('Invalid FTP reply: $response');
    }
    final message = response.substring(4);
    return FTPReply(FTPCode.fromCode(code)!, message);
  }

  @override
  String toString() {
    return '${code.code} $message';
  }
}
