import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationUtils {
  static Future<StreamSubscription<RemoteMessage>> setupNotificationListener(
    BuildContext context,
    AudioPlayer audioPlayer,
    bool isInitialized,
    Function(RemoteMessage) onMessageReceived,
    Function(bool) setInitialized,
  ) async {
    return FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('Notification received: ${message.notification?.title}');
      debugPrint('Notification data: ${message.data}');

      final title = message.notification?.title?.toLowerCase() ?? '';
      final dataTitle = message.data['title']?.toString().toLowerCase() ?? '';

      // Process the message immediately for order refresh
      onMessageReceived(message);

      // Play sound asynchronously in the background using microtask
      if (title.contains('new order') || dataTitle.contains('new order')) {
        _playSoundInBackground(
          audioPlayer,
          isInitialized,
          'received.mp3',
          setInitialized,
          repeatCount: 4,
        );
      } else if (title.contains('arrived') || dataTitle.contains('arrived')) {
        _playSoundInBackground(
          audioPlayer,
          isInitialized,
          'arrived.mp3',
          setInitialized,
          repeatCount: 4,
        );
      } else if (title.contains('Branch Pickup') ||
          title.contains('branch pickup')) {
        _playSoundInBackground(
          audioPlayer,
          isInitialized,
          'bell.mp3',
          setInitialized,
          repeatCount: 4,
        );
      }
    });
  }

  static void _playSoundInBackground(
    AudioPlayer audioPlayer,
    bool isInitialized,
    String soundFile,
    Function(bool) setInitialized, {
    int repeatCount = 1,
  }) {
    // Use microtask to truly run on next event loop iteration
    Future.microtask(() async {
      try {
        if (!isInitialized) {
          await audioPlayer.setReleaseMode(ReleaseMode.release);
          setInitialized(true);
        }

        final source = AssetSource('sounds/$soundFile');

        for (int i = 0; i < repeatCount; i++) {
          try {
            await audioPlayer.play(source);

            try {
              await audioPlayer.onPlayerComplete.first.timeout(
                const Duration(seconds: 3),
              );
            } catch (timeoutError) {
              log(
                'Timeout or error waiting for sound completion: $timeoutError',
              );
              try {
                await audioPlayer.stop();
              } catch (stopError) {
                log('Error stopping player: $stopError');
              }
            }

            if (i < repeatCount - 1) {
              await Future.delayed(const Duration(milliseconds: 200));
            }

            log('Played sound ${i + 1}/$repeatCount');
          } catch (e) {
            log('Error in play iteration $i: $e');
            await Future.delayed(const Duration(milliseconds: 200));
          }
        }
      } catch (e) {
        log('Error in _playSoundInBackground: $e');
      } finally {
        log('Finished playing sound: $soundFile ($repeatCount times)');
      }
    });
  }
}
