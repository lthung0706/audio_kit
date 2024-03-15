class Audio {
  String? path;
  String? name;
  String? album;
  String? artist;
  String? size;
  String? duration;

  Audio(
      {this.path,
      this.name,
      this.album,
      this.artist,
      this.size,
      this.duration});

  factory Audio.fromJson(Map<String, dynamic> json) {
    int fileSize = int.parse(json['aSize'] ?? '0');
    int fileDuration = int.parse(json['aDuration'] ?? '0');
    return Audio(
      path: json['aPath'],
      name: json['aName'],
      album: json['aAlbum'],
      artist: json['aArtist'],
      size: formatBytes(fileSize),
      duration: formatDuration(fileDuration),
    );
  }

  static String formatDuration(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds % 60)
        .toInt(); // Lấy số giây còn lại sau khi tính phút
    return '$minutes m $seconds s';
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
