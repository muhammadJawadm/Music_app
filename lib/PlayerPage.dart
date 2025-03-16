import 'dart:convert';
import 'dart:ffi';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:music_app/Favourite_provider.dart';
import 'package:music_app/ShazamTrack.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './Favourite_provider.dart';
import 'Favourite_provider.dart';

class Playerpage extends StatefulWidget {
  final String Songname;
  const Playerpage({super.key, required this.Songname});

  @override
  State<Playerpage> createState() => _PlayerpageState();
}

class _PlayerpageState extends State<Playerpage> {
  final AudioPlayer _player = AudioPlayer();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0;
  double _volume = 1.0;
  bool _isPlaying = false;
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  SongsModel? songModel;

  List<FavouritesSong> FavouriteSongs = [];

  @override
  void initState() {
    super.initState();
    fetchsongs();
    _listenToAudioStreams();
  }

  Future<SongsModel> getsong(String name) async {
    String uri = 'https://shazam.p.rapidapi.com/search';

    Map<String, String> headers = {
      'x-rapidapi-key': 'f5356c9475msha7a307c9048df91p10c805jsnfa5ade88511f',
      'x-rapidapi-host': 'shazam.p.rapidapi.com'
    };
    Map<String, String> params = {
      'term': widget.Songname,
      'locale': 'en-US',
      'offset': '0',
      'limit': '5'
    };

    final response = await http
        .get(Uri.parse(uri).replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return SongsModel.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _listenToAudioStreams() {
    _player.durationStream.listen((Duration) {
      if (Duration != null) {
        setState(() {
          _totalDuration = Duration;
        });
      }
    });
    _player.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
    _player.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void seekAudio(Duration position) {
    _player.seek(position);
  }

  void _changeSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _player.setSpeed(speed);
    });
  }

  void _changeVolume(double volume) {
    setState(() {
      _volume = volume;
    });
    _player.setVolume(_volume);
  }

  void _moveforward() {
    setState(() {
      seekAudio(_currentPosition + Duration(seconds: 10));
      _currentPosition = _currentPosition + Duration(seconds: 10);
    });
  }

  void _movebackword() {
    setState(() {
      seekAudio(_currentPosition - Duration(seconds: 10));
      _currentPosition = _currentPosition - Duration(seconds: 10);
    });
  }

  Future<void> _loadAudio() async {
    if (songModel != null &&
        songModel?.tracks?.trackHits != null &&
        songModel!.tracks!.trackHits!.isNotEmpty &&
        songModel?.tracks?.trackHits![0].track?.hub?.actions != null &&
        songModel!.tracks!.trackHits![0].track!.hub!.actions!.length > 1) {
      try {
        await _player.setUrl(
            '${songModel?.tracks?.trackHits![0].track?.hub?.actions![1].uri}');
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Couldn't load audio. Please try another song.";
        });
        print('Error loading audio: $e');
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "Audio source not available for this track.";
      });
    }
  }

  void _stopAudio() async {
    await _player.stop();
  }

  void _playAudio() async {
    await _player.play();
  }

  void _pauseAudio() async {
    await _player.pause();
  }

  @override
  void dispose() {
    _player.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void fetchsongs() async {
    String name = widget.Songname;
    if (name.isNotEmpty) {
      setState(() {
        songModel = null;
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        SongsModel data = await getsong(name);
        setState(() {
          songModel = data;
        });
        await _loadAudio();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Couldn't load song details. Please try again.";
        });
        print('Error getting songs detail: $e');
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "No song name provided.";
      });
    }
  }

  void showVolumeSlider() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    'Adjust Volume',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A11CB),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.volume_down,
                        size: 24,
                        color: Color(0xFF6A11CB),
                      ),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 1,
                          divisions: 20,
                          activeColor: Color(0xFF6A11CB),
                          inactiveColor: Color(0xFF6A11CB).withOpacity(0.2),
                          value: _volume,
                          label: "${(_volume * 100).toInt()}%",
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                            });
                            _changeVolume(value);
                          },
                        ),
                      ),
                      Icon(
                        Icons.volume_up,
                        size: 24,
                        color: Color(0xFF6A11CB),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A11CB),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    Text(
                      "Now Playing",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add menu functionality if needed
                      },
                      icon: Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _errorMessage != null
                        ? _buildErrorState()
                        : _buildPlayerContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            "Loading song...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 70,
              color: Colors.white.withOpacity(0.8),
            ),
            SizedBox(height: 20),
            Text(
              _errorMessage ?? "An error occurred",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF6A11CB),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Go Back",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerContent() {
    final favouriteSongsProvider = Provider.of<FavouriteSongsProvider>(context);
    bool isFavourite = favouriteSongsProvider.favouriteSongs
        .any((song) => song.key == songModel?.tracks?.trackHits![0].track?.key);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 20),

            // Album Art
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  '${songModel?.tracks?.trackHits?[0].track?.share?.image}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade800,
                      child: Icon(
                        Icons.music_note,
                        size: 80,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 40),

            // Song Info
            Text(
              '${songModel?.tracks?.trackHits?[0].track?.title ?? "Unknown Title"}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${songModel?.tracks?.trackHits?[0].track?.subtitle ?? "Unknown Artist"}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 40),

            // Progress Bar
            Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.white,
                    overlayColor: Colors.white.withOpacity(0.2),
                  ),
                  child: Slider(
                    min: 0,
                    max: _totalDuration.inSeconds.toDouble(),
                    value: _currentPosition.inSeconds.toDouble(),
                    onChanged: (value) {
                      seekAudio(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_currentPosition.inMinutes}:${_currentPosition.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "${_totalDuration.inMinutes}:${_totalDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: Colors.white,
                  ),
                  onPressed: showVolumeSlider,
                ),
                // Backward Button
                IconButton(
                  onPressed: _movebackword,
                  icon: Icon(Icons.replay_10, color: Colors.white, size: 32),
                ),

                // Play/Pause Button
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _isPlaying ? _pauseAudio : _playAudio,
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Color(0xFF6A11CB),
                      size: 40,
                    ),
                  ),
                ),

                // Forward Button
                IconButton(
                  onPressed: _moveforward,
                  icon: Icon(Icons.forward_10, color: Colors.white, size: 32),
                ),
                IconButton(
                  onPressed: () {
                    if (isFavourite) {
                      favouriteSongsProvider.removeFavouriteSong(songModel!
                          .tracks!.trackHits![0].track!.key
                          .toString());
                    } else {
                      favouriteSongsProvider.addFavouriteSong(
                        songModel!.tracks!.trackHits![0].track!.key.toString(),
                        widget.Songname,
                        songModel!.tracks!.trackHits![0].track!.share?.image ??
                            "",
                        songModel!.tracks!.trackHits![0].track!.title ??
                            "Unknown Title",
                        songModel!.tracks!.trackHits![0].track!.subtitle ??
                            "Unknown Artist",
                      );
                    }
                  },
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Additional Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Volume Button
                _buildControlButton(
                  icon: Icons.volume_up,
                  label: "Volume",
                  onPressed: showVolumeSlider,
                ),

                // Speed Button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<double>(
                    value: _playbackSpeed,
                    dropdownColor: Color(0xFF6A11CB),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: SizedBox(),
                    style: TextStyle(color: Colors.white),
                    items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                        .map((speed) => DropdownMenuItem(
                              value: speed,
                              child: Text(
                                "${speed}x",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (speed) {
                      if (speed != null) {
                        _changeSpeed(speed);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
