class Audio {
  String? path;
  String? name;
  String? album;
  String? artist;
  String? size;
  String? duration;

  Audio({this.path, this.name, this.album, this.artist, this.size, this.duration});

  factory Audio.fromJson(Map<String, dynamic> json) {
    int fileSize = int.parse(json['aSize'] ?? '0');
    return Audio(
      path: json['aPath'],
      name: json['aName'],
      album: json['aAlbum'],
      artist: json['aArtist'],
      size: formatBytes(fileSize),
      duration: json['aDuration'],
    );
  }

  static String formatBytes(int bytes) {
    const int KB = 1024;
    const int MB = KB * 1024;
    const int GB = MB * 1024;

    if (bytes >= GB) {
      return '${(bytes / GB).toStringAsFixed(1)} GB';
    } else if (bytes >= MB) {
      return '${(bytes / MB).toStringAsFixed(1)} MB';
    } else if (bytes >= KB) {
      return '${(bytes / KB).toStringAsFixed(1)} KB';
    } else {
      return '$bytes bytes';
    }
  }
}
