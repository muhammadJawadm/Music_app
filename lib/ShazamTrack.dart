class SongsModel {
  Tracks? tracks;
  Tracks? artists;

  SongsModel({this.tracks, this.artists});

  SongsModel.fromJson(Map<String, dynamic> json) {
    tracks = json['tracks'] != null ? Tracks.fromJson(json['tracks']) : null;
    artists = json['artists'] != null ? Tracks.fromJson(json['artists']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tracks != null) {
      data['tracks'] = tracks!.toJson();
    }
    if (artists != null) {
      data['artists'] = artists!.toJson();
    }
    return data;
  }
}

class Tracks {
  List<TrackHit>? trackHits;
  List<ArtistHit>? artistHits;

  Tracks({this.trackHits, this.artistHits});

  Tracks.fromJson(Map<String, dynamic> json) {
    if (json['hits'] != null) {
      var hits = json['hits'] as List;
      if (hits.isNotEmpty) {
        // Check if it's a track or artist hit based on the content
        if (hits.first.containsKey('track')) {
          trackHits = hits.map((v) => TrackHit.fromJson(v)).toList();
        } else if (hits.first.containsKey('artist')) {
          artistHits = hits.map((v) => ArtistHit.fromJson(v)).toList();
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trackHits != null) {
      data['hits'] = trackHits!.map((v) => v.toJson()).toList();
    }
    if (artistHits != null) {
      data['hits'] = artistHits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrackHit {
  Track? track;

  TrackHit({this.track});

  TrackHit.fromJson(Map<String, dynamic> json) {
    track = json['track'] != null ? Track.fromJson(json['track']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (track != null) {
      data['track'] = track!.toJson();
    }
    return data;
  }
}

class ArtistHit {
  Artist? artist;

  ArtistHit({this.artist});

  ArtistHit.fromJson(Map<String, dynamic> json) {
    artist = json['artist'] != null ? Artist.fromJson(json['artist']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artist != null) {
      data['artist'] = artist!.toJson();
    }
    return data;
  }
}

class Track {
  String? layout;
  String? type;
  String? key;
  String? title;
  String? subtitle;
  Share? share;
  TrackImages? images;
  Hub? hub;
  List<Artists>? artists;
  String? url;

  Track({
    this.layout,
    this.type,
    this.key,
    this.title,
    this.subtitle,
    this.share,
    this.images,
    this.hub,
    this.artists,
    this.url,
  });

  Track.fromJson(Map<String, dynamic> json) {
    layout = json['layout'];
    type = json['type'];
    key = json['key'];
    title = json['title'];
    subtitle = json['subtitle'];
    share = json['share'] != null ? Share.fromJson(json['share']) : null;
    images =
        json['images'] != null ? TrackImages.fromJson(json['images']) : null;
    hub = json['hub'] != null ? Hub.fromJson(json['hub']) : null;
    if (json['artists'] != null) {
      artists = <Artists>[];
      json['artists'].forEach((v) {
        artists!.add(Artists.fromJson(v));
      });
    }
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['layout'] = layout;
    data['type'] = type;
    data['key'] = key;
    data['title'] = title;
    data['subtitle'] = subtitle;
    if (share != null) {
      data['share'] = share!.toJson();
    }
    if (images != null) {
      data['images'] = images!.toJson();
    }
    if (hub != null) {
      data['hub'] = hub!.toJson();
    }
    if (artists != null) {
      data['artists'] = artists!.map((v) => v.toJson()).toList();
    }
    data['url'] = url;
    return data;
  }
}

class TrackImages {
  String? background;
  String? coverart;
  String? coverarthq;
  String? joecolor;

  TrackImages({
    this.background,
    this.coverart,
    this.coverarthq,
    this.joecolor,
  });

  TrackImages.fromJson(Map<String, dynamic> json) {
    background = json['background'];
    coverart = json['coverart'];
    coverarthq = json['coverarthq'];
    joecolor = json['joecolor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['background'] = background;
    data['coverart'] = coverart;
    data['coverarthq'] = coverarthq;
    data['joecolor'] = joecolor;
    return data;
  }
}

class ProviderImages {
  String? overflow;
  String? defaultImage; // Changed from 'default' to 'defaultImage'

  ProviderImages({
    this.overflow,
    this.defaultImage,
  });

  ProviderImages.fromJson(Map<String, dynamic> json) {
    overflow = json['overflow'];
    defaultImage = json['default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['overflow'] = overflow;
    data['default'] = defaultImage;
    return data;
  }
}

class Share {
  String? subject;
  String? text;
  String? href;
  String? image;
  String? twitter;
  String? html;
  String? avatar;
  String? snapchat;

  Share({
    this.subject,
    this.text,
    this.href,
    this.image,
    this.twitter,
    this.html,
    this.avatar,
    this.snapchat,
  });

  Share.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    text = json['text'];
    href = json['href'];
    image = json['image'];
    twitter = json['twitter'];
    html = json['html'];
    avatar = json['avatar'];
    snapchat = json['snapchat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    data['text'] = text;
    data['href'] = href;
    data['image'] = image;
    data['twitter'] = twitter;
    data['html'] = html;
    data['avatar'] = avatar;
    data['snapchat'] = snapchat;
    return data;
  }
}

class Hub {
  String? type;
  String? image;
  List<Actions>? actions;
  List<Options>? options;
  List<Providers>? providers;
  bool? explicit;
  String? displayname;

  Hub({
    this.type,
    this.image,
    this.actions,
    this.options,
    this.providers,
    this.explicit,
    this.displayname,
  });

  Hub.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    image = json['image'];
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(Actions.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    if (json['providers'] != null) {
      providers = <Providers>[];
      json['providers'].forEach((v) {
        providers!.add(Providers.fromJson(v));
      });
    }
    explicit = json['explicit'];
    displayname = json['displayname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['image'] = image;
    if (actions != null) {
      data['actions'] = actions!.map((v) => v.toJson()).toList();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (providers != null) {
      data['providers'] = providers!.map((v) => v.toJson()).toList();
    }
    data['explicit'] = explicit;
    data['displayname'] = displayname;
    return data;
  }
}

class Actions {
  String? name;
  String? type;
  String? id;
  String? uri;

  Actions({
    this.name,
    this.type,
    this.id,
    this.uri,
  });

  Actions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    id = json['id'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['id'] = id;
    data['uri'] = uri;
    return data;
  }
}

class Options {
  String? caption;
  List<Actions>? actions;
  Beacondata? beacondata;
  String? image;
  String? type;
  String? listcaption;
  String? overflowimage;
  bool? colouroverflowimage;
  String? providername;

  Options({
    this.caption,
    this.actions,
    this.beacondata,
    this.image,
    this.type,
    this.listcaption,
    this.overflowimage,
    this.colouroverflowimage,
    this.providername,
  });

  Options.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(Actions.fromJson(v));
      });
    }
    beacondata = json['beacondata'] != null
        ? Beacondata.fromJson(json['beacondata'])
        : null;
    image = json['image'];
    type = json['type'];
    listcaption = json['listcaption'];
    overflowimage = json['overflowimage'];
    colouroverflowimage = json['colouroverflowimage'];
    providername = json['providername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    if (actions != null) {
      data['actions'] = actions!.map((v) => v.toJson()).toList();
    }
    if (beacondata != null) {
      data['beacondata'] = beacondata!.toJson();
    }
    data['image'] = image;
    data['type'] = type;
    data['listcaption'] = listcaption;
    data['overflowimage'] = overflowimage;
    data['colouroverflowimage'] = colouroverflowimage;
    data['providername'] = providername;
    return data;
  }
}

class Beacondata {
  String? type;
  String? providername;

  Beacondata({
    this.type,
    this.providername,
  });

  Beacondata.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    providername = json['providername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['providername'] = providername;
    return data;
  }
}

class Providers {
  String? caption;
  ProviderImages? images;
  List<Actions>? actions;
  String? type;

  Providers({
    this.caption,
    this.images,
    this.actions,
    this.type,
  });

  Providers.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    images =
        json['images'] != null ? ProviderImages.fromJson(json['images']) : null;
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(Actions.fromJson(v));
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    if (actions != null) {
      data['actions'] = actions!.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    return data;
  }
}

class Artists {
  String? id;
  String? adamid;

  Artists({
    this.id,
    this.adamid,
  });

  Artists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adamid = json['adamid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['adamid'] = adamid;
    return data;
  }
}

class Artist {
  String? avatar;
  String? name;
  bool? verified;
  String? weburl;
  String? adamid;
  Artist({
    this.avatar,
    this.name,
    this.verified,
    this.weburl,
    this.adamid,
  });

  Artist.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    name = json['name'];
    verified = json['verified'];
    weburl = json['weburl'];
    adamid = json['adamid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['name'] = name;
    data['verified'] = verified;
    data['weburl'] = weburl;
    data['adamid'] = adamid;
    return data;
  }
}

class FavouritesSong {
  final String key;
  final String songName;
  final String imageUrl;
  final String title;
  final String artist;

  FavouritesSong(
      {required this.key,
      required this.songName,
      required this.imageUrl,
      required this.title,
      required this.artist});
}
