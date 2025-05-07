class Media {
  final String? type;
  final int? duration;
  final int? size;
  final String? url;
  final String? thumbnail;
  final int? width;
  final int? height;

  Media({
    this.type,
    this.duration,
    this.size,
    this.url,
    this.thumbnail,
    this.width,
    this.height,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      type: json['type'],
      duration: json['duration'] ?? 0,
      size: json['size'] ?? 0,
      url: json['url'],
      thumbnail: json['thumbnail'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration': duration,
      'size': size,
      'url': url,
      'thumbnail': thumbnail,
      'width': width,
      'height': height,
    };
  }
}