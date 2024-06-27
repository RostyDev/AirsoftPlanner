class User {
  final int id;
  final String gebruikersnaam;
  final String beschrijving;
  final String wachtwoord;

  User({
    required this.id,
    required this.gebruikersnaam,
    required this.beschrijving,
    required this.wachtwoord,
  });

  // Factory method to create a User instance from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      gebruikersnaam: map['gebruikersnaam'] as String,
      beschrijving: map['beschrijving'] as String,
      wachtwoord: map['wachtwoord'] as String,
    );
  }

  // Method to convert a User instance back to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gebruikersnaam': gebruikersnaam,
      'beschrijving': beschrijving,
      'wachtwoord': wachtwoord,
    };
  }
}
