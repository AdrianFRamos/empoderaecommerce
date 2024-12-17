class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String? avatarUrl;
  final String lastname; // Novo campo
  final String number;   // Novo campo

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
    this.lastname = '',
    this.number = '',
  });

  // Converte o objeto User para Map (para inserção no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatarUrl': avatarUrl,
      'lastname': lastname,
      'number': number,
    };
  }

  // Cria um objeto User a partir de um Map (para leitura do banco)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      avatarUrl: map['avatarUrl'],
      lastname: map['lastname'] ?? '',
      number: map['number'] ?? '',
    );
  }
}
