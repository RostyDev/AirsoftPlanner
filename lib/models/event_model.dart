class Event {
  final int id;
  final String title;
  final DateTime startdate;
  final DateTime enddate;
  final String location;
  final String beschrijving;
  final int idGebruiker;

  Event({
    required this.id,
    required this.title,
    required this.startdate,
    required this.enddate,
    required this.location,
    required this.beschrijving,
    required this.idGebruiker,
  });

  // Factory method to create an Event instance from a Map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as int,
      title: map['title'] as String,
      startdate: map['startdate'],
      enddate: map['enddate'],
      location: map['location'] as String,
      beschrijving: map['beschrijving'] as String,
      idGebruiker: map['idGebruiker'] as  int,
    );
  }

  // Method to convert an Event instance back to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startdate': startdate,
      'enddate': enddate,
      'location': location,
      'beschrijving': beschrijving,
      'idGebruiker': idGebruiker,
    };
  }
}
