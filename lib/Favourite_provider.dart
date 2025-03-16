import 'package:flutter/material.dart';
import 'ShazamTrack.dart';

class FavouriteSongsProvider with ChangeNotifier {
  static final List<FavouritesSong> _favouriteSongs = [];
  List<FavouritesSong> get favouriteSongs => _favouriteSongs;

  void addFavouriteSong(String key, String songName, String imageUrl,
      String title, String artist) {
    if (!_favouriteSongs.any((s) => s.key == key)) {
      _favouriteSongs.add(FavouritesSong(
        key: key,
        songName: songName,
        imageUrl: imageUrl,
        title: title,
        artist: artist,
      ));
      notifyListeners();
    }
  }

  void removeFavouriteSong(String songKey) {
    _favouriteSongs.removeWhere((song) => song.key == songKey);
    notifyListeners();
  }
}
