import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';

class MeditationPlayer extends StatefulWidget {
  final String title;
  final String duration;
  final String audioAsset;

  const MeditationPlayer({
    super.key,
    required this.title,
    required this.duration,
    required this.audioAsset,
  });

  @override
  State<MeditationPlayer> createState() => _MeditationPlayerState();
}

class _MeditationPlayerState extends State<MeditationPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = true;
  String? _errorMessage;
  double _volume = 2.0; // Default volume boost to 200%

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _audioPlayer.setAsset(widget.audioAsset);
      await _audioPlayer.setVolume(_volume); // Apply volume boost
      print("✅ Audio loaded: ${widget.audioAsset}");
    } catch (e) {
      _handleError("Failed to load audio: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleError(String message) {
    print("❌ $message");
    setState(() => _errorMessage = message);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
      return;
    }

    try {
      await _audioPlayer.play();
      setState(() => _isPlaying = true);
    } catch (e) {
      _handleError("Playback failed: ${e.toString()}");
    }
  }

  void _increaseVolume() {
    setState(() {
      _volume = (_volume + 0.5).clamp(0.0, 3.0); // Max 300% volume
      _audioPlayer.setVolume(_volume);
    });
  }

  void _decreaseVolume() {
    setState(() {
      _volume = (_volume - 0.5).clamp(0.0, 3.0); // Min 0% volume
      _audioPlayer.setVolume(_volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.duration,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Player controls
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_errorMessage != null)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    iconSize: 48,
                    onPressed: _initPlayer,
                    tooltip: 'Retry loading',
                    color: Colors.blue,
                  )
                else ...[
                    IconButton(
                      icon: const Icon(Icons.volume_down),
                      onPressed: _decreaseVolume,
                      tooltip: 'Decrease volume',
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        size: 48,
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: _togglePlay,
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: _increaseVolume,
                      tooltip: 'Increase volume',
                    ),
                  ],
              ],
            ),

            // Volume indicator
            if (!_isLoading && _errorMessage == null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.volume_up, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Volume: ${(_volume * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],

            // Progress bar
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: _audioPlayer.durationStream,
                  builder: (context, durationSnapshot) {
                    final duration = durationSnapshot.data ?? Duration.zero;

                    if (duration.inSeconds == 0 || _errorMessage != null) {
                      return const SizedBox();
                    }

                    return Column(
                      children: [
                        Slider(
                          value: position.inSeconds.toDouble(),
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${duration.inMinutes}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}