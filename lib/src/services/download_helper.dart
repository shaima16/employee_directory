import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DownloadHelper {
  static Future<bool> downloadFileFromUrl(
      {String? url,
      String? filePath,
      CancelToken? cancelToken,
      required void Function() downloadSuccessActions,
      required void Function() downloadFailedActions,
      bool debugEnabledOnReceiveProgress = true}) async {
    try {
      var response = await Dio()
          .download(
            url!,
            filePath,
            cancelToken: cancelToken,
          )
          .catchError((error, StackTrace stackTrace) {});
      if (response.statusCode == 200) {
        downloadSuccessActions();
        return Future.value(true);
      } else {
        debugPrint("downloadFileFromUrl Response : " + response.toString());
        downloadFailedActions();
        return Future.value(false);
      }
    } catch (error) {
      downloadFailedActions();
      return Future.error(error);
    }
  }
}
