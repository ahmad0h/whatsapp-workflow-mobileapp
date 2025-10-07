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
    Function(bool) setInitialized, {
    int repeatCount = 1,
  }) async {
    try {
      if (!isInitialized) {
        await audioPlayer.setReleaseMode(ReleaseMode.release);
        setInitialized(true);
      }

      // Create a new audio player instance for each notification
      final player = AudioPlayer();
      
      try {
        // Configure player
        await player.setReleaseMode(ReleaseMode.release);
        await player.setVolume(1.0);
        
        // Load the sound file first
        final source = AssetSource('sounds/$soundFile');
        await player.setSource(source);
        
        // Play the sound for the specified number of times
        for (int i = 0; i < repeatCount; i++) {
          try {
            // Play the sound
            await player.resume();
            
            // Wait for the sound to complete with a maximum duration
            await player.onPlayerComplete.first.timeout(
              const Duration(seconds: 3),
              onTimeout: () {
                log('Sound play timed out, moving to next iteration');
                return Future.value();
              },
            );
            
            // Add a small delay between plays, except after the last one
            if (i < repeatCount - 1) {
              await Future.delayed(const Duration(milliseconds: 300));
            }
            
            log('Played sound ${i + 1}/$repeatCount');
          } catch (e) {
            log('Error in play iteration $i: $e');
            // Continue to next iteration even if one fails
            await Future.delayed(const Duration(milliseconds: 300));
          }
        }
      } finally {
        // Always stop and dispose the player when done
        try {
          await player.stop();
          await player.dispose();
        } catch (e) {
          log('Error cleaning up player: $e');
        }
      }
    } catch (e) {
      log('Error in _playSound: $e');
    } finally {
      log('Finished playing sound: $soundFile ($repeatCount times)');
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
          repeatCount: 4,
        );
      } else if (title.contains('Branch Pickup') ||
          title.contains('branch pickup')) {
        await _playSound(
          audioPlayer,
          isInitialized,
          'bell.mp3',
          setInitialized,
          repeatCount: 4,
        );
      }

      // Call the callback to handle message
      onMessageReceived(message);
    });
  }
}
