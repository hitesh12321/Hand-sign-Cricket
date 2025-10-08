// In lib/providers/audio_provider.dart
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider with ChangeNotifier {
  // State variables
  bool _isSoundEnabled = true;
  double _musicVolume = 0.5;
  double _sfxVolume = 0.8;

  // Player for long-running background music
  final AudioPlayer _musicPlayer = AudioPlayer();

  // Getters
  bool get isSoundEnabled => _isSoundEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  AudioProvider() {
    // Set the release mode to loop for the background music player
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  // --- Music Methods ---
  void playMusic() {
    if (_isSoundEnabled) {
      _musicPlayer.setVolume(_musicVolume);
      _musicPlayer.play(AssetSource('sounds/background_music.mp3'));
    }
  }

  void stopMusic() {
    _musicPlayer.stop();
  }

  // ==========================================================
  // ## THIS IS THE CORRECTED METHOD ##
  // ==========================================================
  void playSoundEffect(String soundName) {
    if (_isSoundEnabled) {
      // Create a new, temporary player for the sound effect.
      // This allows multiple sounds to play at once without conflict.
      final sfxPlayer = AudioPlayer();
      sfxPlayer.setVolume(_sfxVolume);
      sfxPlayer.play(AssetSource('sounds/$soundName'));

      // The player will dispose itself automatically after playing.
    }
  }

  // --- Settings Methods ---
  void toggleSound(bool isEnabled) {
    _isSoundEnabled = isEnabled;
    if (_isSoundEnabled) {
      playMusic();
    } else {
      stopMusic();
    }
    notifyListeners();
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume;
    _musicPlayer.setVolume(_musicVolume);
    notifyListeners();
  }

  void setSfxVolume(double volume) {
    _sfxVolume = volume;
    notifyListeners();
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    super.dispose();
  }
}
