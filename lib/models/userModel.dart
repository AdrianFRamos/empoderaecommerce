class UserModel {
  final int? id; 
  final String? firebaseUid; 
  final String name;
  final String email;
  final String? password;
  final bool isGoogleUser;
  final String? avatarUrl;
  final String? number;
  final String? lastname;

  UserModel({
    this.id,
    this.firebaseUid, 
    required this.name,
    required this.email,
    this.password,
    required this.isGoogleUser,
    this.avatarUrl,
    this.number,
    this.lastname,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firebaseUid': firebaseUid,
      'name': name,
      'email': email,
      'password': password,
      'isGoogleUser': isGoogleUser ? 1 : 0,
      'avatarUrl': avatarUrl,
      'number': number,
      'lastname': lastname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firebaseUid: map['firebaseUid'], 
      name: map['name'],
      email: map['email'],
      password: map['password'],
      isGoogleUser: map['isGoogleUser'] == 1,
      avatarUrl: map['avatarUrl'],
      number: map['number'],
      lastname: map['lastname'],
    );
  }
}
