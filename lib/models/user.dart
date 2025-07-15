class User {
  final String? id;
  final String? name;
  final String? email;
  final String? picture;
  final bool? isBlocked;

  User({this.id, this.name, this.email, this.picture, this.isBlocked});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      picture: json['picture'],
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'picture': picture,
        'isBlocked': isBlocked,
      };
}
