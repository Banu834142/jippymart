import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:restaurant/utils/preferences.dart';

class AudioPlayerService {
  static late AudioPlayer _audioPlayer;

  static initAudio() async {
    _audioPlayer = AudioPlayer(playerId: "playerId");
  }

  static Future<void> playSound(bool isPlay) async {
    try {
      if (isPlay) {
        if (_audioPlayer.state != PlayerState.playing) {
          log("PlaySound :: 11 :: $isPlay :: ${Preferences.getString(Preferences.orderRingtone)}");
          await _audioPlayer.setSource(
              UrlSource(Preferences.getString(Preferences.orderRingtone)));
          await _audioPlayer.setReleaseMode(ReleaseMode.loop);
          await _audioPlayer.resume();
        }
      } else {
        if (_audioPlayer.state != PlayerState.stopped) {
          log("PlaySound :: 22 :: $isPlay :: ${Preferences.getString(Preferences.orderRingtone)}");
          await _audioPlayer.stop();
        }
      }
    } catch (e) {
      print("Error in playSound: $e");
    }
  }
}
