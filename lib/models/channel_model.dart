class ChannelModel {
  final String id;
  final String name;
  final String color;

  ChannelModel({
    required this.id,
    required this.name,
    required this.color,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['_id'],
      name: json['name'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'color': color,
    };
  }
}