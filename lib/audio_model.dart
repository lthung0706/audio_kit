class Audio {
  String? path;
  String? name;
  String? album;
  String? artist;
   String? size;
  String? duration;

  Audio({this.path, this.name, this.album, this.artist, this.size,this.duration});

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      path: json['aPath'],
      name: json['aName'],
      album: json['aAlbum'],
      artist: json['aArtist'],
      size: json['aSize'],
      duration: json['aDuration'],
    );
  }
}
