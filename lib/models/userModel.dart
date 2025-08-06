class UserModel {
  final String uid;
  final String fullName;
  final String email;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
    );
  }
}