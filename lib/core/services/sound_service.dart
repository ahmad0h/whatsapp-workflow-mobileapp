import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;

  factory SoundService() {
    return _instance;
  }

  SoundService._internal();

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _player.setReleaseMode(ReleaseMode.release);
      _isInitialized = true;
    }
  }

  Future<void> playOrderReceived() async {
    try {
      await _player.play(AssetSource('sounds/order_received.mp3'));
    } catch (e) {
      debugPrint('Error playing order received sound: $e');
    }
  }

  Future<void> playClientArrived() async {
    try {
      await _player.play(AssetSource('sounds/client_arrived.mp3'));
    } catch (e) {
      debugPrint('Error playing client arrived sound: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
