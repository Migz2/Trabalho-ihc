import 'package:audioplayers/audioplayers.dart';
import '../../features/settings/domain/entities/settings_entity.dart';

class AmbientSoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(AmbientSound sound, double volume) async {
    if (sound == AmbientSound.none) {
      await stop();
      return;
    }
    final path = _soundPath(sound);
    await _player.setVolume(volume);
    await _player.setReleaseMode(ReleaseMode.loop);
    try {
      await _player.play(AssetSource(path));
    } catch (e) {
      // asset might not exist; ignore silently
      print('AmbientSoundService: failed to play $path: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  String _soundPath(AmbientSound sound) {
    switch (sound) {
      case AmbientSound.rain:
        return 'assets/audio/rain.mp3';
      case AmbientSound.forest:
        return 'assets/audio/forest.mp3';
      case AmbientSound.whitenoise:
        return 'assets/audio/whitenoise.mp3';
      case AmbientSound.cafe:
        return 'assets/audio/cafe.mp3';
      case AmbientSound.ocean:
        return 'assets/audio/ocean.mp3';
      case AmbientSound.none:
        return '';
    }
  }
}
