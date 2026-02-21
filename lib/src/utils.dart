import 'dart:async';

class Utils {
  Utils._();

  static int parsePort(String response) {
    return parsePortEPSV(response);
  }

  /// Parse the Passive Mode Port from the Servers [sResponse]
  /// port format (|||xxxxx|)
  static int parsePortEPSV(String sResponse) {
    int iParOpen = sResponse.indexOf('(');
    int iParClose = sResponse.indexOf(')');

    if (iParClose > -1 && iParOpen > -1) {
      sResponse = sResponse.substring(iParOpen + 4, iParClose - 1);
    }
    return int.parse(sResponse);
  }

  ///retry a function [retryCount] times, until exceed [retryCount] or execute the function successfully
  ///Return true if the future executed successfully , false other wises
  static Future<bool> retryAction(
    FutureOr<bool> Function() action,
    retryCount,
  ) async {
    int lAttempts = 1;
    bool result = true;
    await Future.doWhile(() async {
      try {
        result = await action();
        //if there is no exception we exit the loop (return false to exit)
        return false;
      } catch (e) {
        if (lAttempts++ >= retryCount) {
          rethrow;
        }
      }
      //return true to loop again
      return true;
    });
    return result;
  }
}
