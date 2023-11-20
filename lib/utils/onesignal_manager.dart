import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:http/http.dart' as http;

class OneSignalManager {
  const OneSignalManager._();

  static const String _notificationUrl =
      "https://onesignal.com/api/v1/notifications";

  static const String _appId = "1b6083c9-6a62-43e8-b8a3-4b985972f842";

  static OneSignal get instance => _oneSignal;

  static OneSignal get _oneSignal => OneSignal.shared;

  static Future<void> initialize({
    final VoidCallback? onStart,
    final VoidCallback? onSuccess,
    final Function(String errorTextKey)? onError,
    final VoidCallback? onComplete,
  }) async {
    try {
      onStart?.call();
      await _oneSignal.setAppId(_appId).timeout(const Duration(seconds: 8));
      await setExternalUserId(userId:  FirebaseAuth.instance.currentUser!.uid);
      onSuccess?.call();
    } on TimeoutException {
      onError?.call("connection_timeout");
    } catch (_) {
      onError?.call("error_try_again");
    } finally {
      onComplete?.call();
    }
  }

  static Future<void> setExternalUserId({
    required final String userId,
    final VoidCallback? onStart,
    final VoidCallback? onSuccess,
    final Function(String errorTextKey)? onError,
    final VoidCallback? onComplete,
  }) async {
    try {
      onStart?.call();
      await _oneSignal
          .setExternalUserId(userId)
          .timeout(const Duration(seconds: 32));
      onSuccess?.call();
    } on TimeoutException {
      onError?.call("connection_timeout");
    } catch (_) {
      onError?.call("error_try_again");
    } finally {
      onComplete?.call();
    }
  }

  static Future<void> removeExternalUserId({
    final VoidCallback? onStart,
    final VoidCallback? onSuccess,
    final Function(String errorTextKey)? onError,
    final VoidCallback? onComplete,
  }) async {
    try {
      onStart?.call();
      await _oneSignal
          .removeExternalUserId()
          .timeout(const Duration(seconds: 32));
      onSuccess?.call();
    } on TimeoutException {
      onError?.call("connection_timeout");
    } catch (_) {
      onError?.call("error_try_again");
    } finally {
      onComplete?.call();
    }
  }

  static void handleNotifications(
      {required final Function(OSNotificationReceivedEvent event) onForeground,
      required final Function(OSNotificationOpenedResult result)
          onBackgroundOpened}) {
    _oneSignal.setNotificationWillShowInForegroundHandler(onForeground);
    _oneSignal.setNotificationOpenedHandler(onBackgroundOpened);
  }

  static Future<bool> sendNotificationToUsers({
    required final String title,
    required final String content,
    required final List<String> targets,
    final VoidCallback? onStart,
    final VoidCallback? onSuccess,
    final Function(String errorTextKey)? onError,
    final VoidCallback? onComplete,
  }) async {
    try {
      final Map<String, dynamic> notificationBody = <String, dynamic>{
        "app_id": _appId,
        "headings": <String, dynamic>{
          "en": title,
        },
        "contents": <String, dynamic>{
          "en": content,
        },
        "include_external_user_ids": targets,
        "channel_for_external_user_ids": "push",
        "small_icon": "ic_stat_onesignal_default",
        "priority": 10,
        "android_channel_id": "9870281f-9ae0-42ca-b7a2-15c69af041af",
      };
      final http.Response response = await http
          .post(
            Uri.parse(_notificationUrl),
            headers: {
              "Authorization":
                  "Basic ZmU4NWZlNDQtOGYyOC00NDQ3LWJhZWQtNTFjZWJhNTg4OTJm",
              "Content-Type": "application/json; charset=utf-8",
            },
            body: jsonEncode(notificationBody),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == HttpStatus.ok) {
        onSuccess?.call();
        return true;
      } else {
        onError?.call("error_try_again");
      }
    } on TimeoutException {
      onError?.call("connection_timeout");
    } catch (_) {
      onError?.call("error_try_again");
    } finally {
      onComplete?.call();
    }
    return false;
  }

  static Future<bool> clearNotification({
    final VoidCallback? onStart,
    final VoidCallback? onSuccess,
    final Function(String errorTextKey)? onError,
    final VoidCallback? onComplete,
  }) async {
    try {
      onStart?.call();
      await _oneSignal
          .clearOneSignalNotifications()
          .timeout(const Duration(seconds: 8));
      onSuccess?.call();
      return true;
    } on TimeoutException {
      onError?.call("connection_timeout");
    } catch (_) {
      onError?.call("error_try_again");
    } finally {
      onComplete?.call();
    }
    return false;
  }
}
