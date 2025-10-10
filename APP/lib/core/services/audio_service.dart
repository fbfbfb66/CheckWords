import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';

/// 音频播放服务
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final Dio _dio = Dio();
  bool _isPlaying = false;
  String? _currentlyPlaying;

  /// 播放单词发音
  /// [word] 要播放的单词
  /// [type] 发音类型：'uk' 英音，'us' 美音
  Future<void> playWordPronunciation(String word, String type) async {
    try {
      // 如果正在播放同一个单词，先停止
      if (_isPlaying && _currentlyPlaying == '$word-$type') {
        await stopPlayback();
        return;
      }

      // 构建有道API URL
      // type=1 为英音，type=2 为美音
      final apiType = type == 'uk' ? '1' : '2';
      final url = 'https://dict.youdao.com/dictvoice?audio=$word&type=$apiType';

      // 停止当前播放
      await _audioPlayer.stop();

      _isPlaying = true;
      _currentlyPlaying = '$word-$type';

      // 播放音频
      await _audioPlayer.play(UrlSource(url));

    } catch (e) {
      _isPlaying = false;
      _currentlyPlaying = null;
      throw Exception('播放失败: $e');
    }
  }

  /// 停止播放
  Future<void> stopPlayback() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _currentlyPlaying = null;
    } catch (e) {
      // 忽略停止播放时的错误
    }
  }

  /// 检查是否正在播放
  bool get isPlaying => _isPlaying;

  /// 获取当前播放的单词和类型
  String? get currentlyPlaying => _currentlyPlaying;

  /// 释放资源
  void dispose() {
    _audioPlayer.dispose();
  }
}