import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await _player.setUrl(
        "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/f0/aa/5c/f0aa5ca6-0aa0-849f-595f-d760b76d6d8c/mzaf_14107547189911877874.plus.aac.ep.m4a",
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _stopAudio() async {
    await _player.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Just Audio Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _togglePlayPause,
                    child: Text(isPlaying ? 'Pause' : 'Play'),
                  ),
                  ElevatedButton(
                    onPressed: _stopAudio,
                    child: Text('Stop'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
