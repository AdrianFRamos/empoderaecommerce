class Address {
  final int? id;
  final int? userId;
  final String street;
  final String number;
  final String city;
  final String state;
  final String zipCode;
  final String bairro;       
  final String telefone;      
  final String complement;

  Address({
    this.id,
    required this.userId,
    required this.street,
    required this.number,
    required this.city,
    required this.state,
    required this.zipCode,
    this.bairro = '',
    this.telefone = '',
    this.complement = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'street': street,
      'number': number,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'bairro': bairro,
      'telefone': telefone,
      'complement': complement,
    };
  }

  static Address fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      userId: map['userId'],
      street: map['street'],
      number: map['number'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
      bairro: map['bairro'] ?? '',
      telefone: map['telefone'] ?? '',
      complement: map['complement'] ?? '',
    );
  }
}
