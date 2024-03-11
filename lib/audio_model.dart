class Audio {
  String? path;
  String? name;
  String? album;
  String? artist;

  Audio({this.path, this.name, this.album, this.artist});

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      path: json['aPath'],
      name: json['aName'],
      album: json['aAlbum'],
      artist: json['aArtist'],
    );
  }
}
