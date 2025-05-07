

class Sender {
  final String id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String role;

  Sender({
    required this.id,
     this.firstName,
     this.lastName,
    required this.email,
    required this.role
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role
    };
  }
}


