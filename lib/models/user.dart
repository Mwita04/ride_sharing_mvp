class User {
  final String id;
  final String name;
  final String email;
  final bool isDriver;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.isDriver = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isDriver: json['isDriver'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isDriver': isDriver,
    };
  }
}
