class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? googleId;
  String? facebookId;
  String? picture;
  String? playerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isBlocked; // ✅ THÊM DÒNG NÀY

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.googleId,
    this.facebookId,
    this.picture,
    this.playerId,
    this.createdAt,
    this.updatedAt,
    this.isBlocked, // ✅ THÊM DÒNG NÀY
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      googleId: json['googleId'],
      facebookId: json['facebookId'],
      picture: json['picture'],
      playerId: json['playerId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isBlocked: json['isBlocked'] ?? false, // ✅ THÊM DÒNG NÀY
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'googleId': googleId,
      'facebookId': facebookId,
      'picture': picture,
      'playerId': playerId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isBlocked': isBlocked ?? false, // ✅ THÊM DÒNG NÀY
    };
  }
}
