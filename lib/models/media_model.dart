class Media {
  final String? type;
  final int? duration;
  final int? size;
  final String? url;


  Media({
    this.type,
    this.duration,
    this.size,
    this.url,

  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      type: json['type'],
      duration: json['duration'] ?? 0,
      size: json['size'] ?? 0,
      url: json['url'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration': duration,
      'size': size,
      'url': url,

    };
  }

  factory Media.empty() => Media(
    type: null,
    duration: 0,
    size: 0,
    url: null,

  );
}