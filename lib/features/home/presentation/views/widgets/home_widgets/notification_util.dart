import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationUtils {
  static Future<void> _playSound(
    AudioPlayer audioPlayer,
    bool isInitialized,
    String soundFile,
    Function(bool) setInitialized,
  ) async {
    try {
      if (!isInitialized) {
        await audioPlayer.setReleaseMode(ReleaseMode.release);
        setInitialized(true);
      }
      await audioPlayer.play(AssetSource('sounds/$soundFile'));
    } catch (e) {
      log('Error playing sound: $e');
    }
  }

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

      // Play sound based on notification type
      if (title.contains('new order') || dataTitle.contains('new order')) {
        await _playSound(
          audioPlayer,
          isInitialized,
          'received.mp3',
          setInitialized,
        );
      } else if (title.contains('arrived') || dataTitle.contains('arrived')) {
        await _playSound(
          audioPlayer,
          isInitialized,
          'arrived.mp3',
          setInitialized,
        );
      }

      // Call the callback to handle message
      onMessageReceived(message);
    });
  }
}
