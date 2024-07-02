class Inschrijving {
  final int? id;
  final int event_id;
  final int gebruiker_id;
  int status;

  Inschrijving({
    this.id,
    required this.event_id,
    required this.gebruiker_id,
    required this.status,
  });

  factory Inschrijving.fromMap(Map<String, dynamic> json) {
    return Inschrijving(
      id: json['id'],
      event_id: json['event'],
      gebruiker_id: json['gebruiker'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event': event_id,
      'gebruiker': gebruiker_id,
      'status': status,
    };
  }
}
