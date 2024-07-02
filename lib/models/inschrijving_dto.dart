import 'event_model.dart';
import 'user_model.dart';

class InschrijvingDTO {
  final int? id;
  final Event? event;
  final User? gebruiker;
  int status;

  InschrijvingDTO({
    this.id,
    required this.event,
    required this.gebruiker,
    required this.status,
  });

  factory InschrijvingDTO.fromMap(Map<String, dynamic> json) {
    return InschrijvingDTO(
      id: json['id'],
      event: Event.fromMap(json['event']),
      gebruiker: User.fromMap(json['gebruiker']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event': event!.toMap(),
      'gebruiker': gebruiker!.toMap(),
      'status': status,
    };
  }
}
