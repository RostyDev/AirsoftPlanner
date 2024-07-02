import 'package:airsoftplanner/models/inschrijving_DTO.dart';
import 'package:airsoftplanner/models/inschrijving_model.dart';
import 'package:mysql1/mysql1.dart';
import 'models/user_model.dart';
import 'models/event_model.dart';

class DatabaseService {
  // Singleton pattern for a single instance of the database service
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  // Connection settings
  final ConnectionSettings _settings = ConnectionSettings(
    host: '10.0.2.2',
    port: 3306,
    user: 'root',
    db: 'airsoft_planner',
  );

  MySqlConnection? _connection;

  // Method to initialize the connection
  Future<void> init() async {
    if (_connection == null) {
      _connection = await MySqlConnection.connect(_settings);
    }
  }

  // Method to close the connection
  Future<void> close() async {
    await _connection?.close();
    _connection = null;
  }

  // Ensure connection is open before executing a query
  Future<MySqlConnection> _ensureConnection() async {
    await init();
    return _connection!;
  }

  Future<User?> getUserProfile(int userId) async {
    var conn = await _ensureConnection();
    var results = await conn.query(
      'SELECT * FROM gebruikers WHERE id = ?',
      [userId],
    );
    if (results.isNotEmpty) {
      return User.fromMap(results.first.fields);
    }
    return null;
  }

  // Function to check login credentials and return user information if successful
  Future<User?> checkLogin(String username, String password) async {
    var conn = await _ensureConnection();
    var results = await conn.query(
        'SELECT * FROM gebruikers WHERE gebruikersnaam = ? AND wachtwoord = ?',
        [username, password]);
    if (results.isNotEmpty) {
      return User.fromMap(results.first.fields);
    }
    return null;
  }

  Future<List<Event>> getUpcomingEvents() async {
    var conn = await _ensureConnection();
    final results = await conn.query(
      'SELECT * FROM events WHERE enddate > NOW()',
    );

    List<Event> events = [];
    for (var row in results) {
      events.add(Event.fromMap(row.fields));
    }

    return events;
  }

  Future<List<Event>> getUpcomingEventsByUserId(int idGebruiker) async {
    var conn = await _ensureConnection();
    final results = await conn.query(
      'SELECT * FROM events WHERE idGebruiker = ?',
      [idGebruiker],
    );

    List<Event> events = [];
    for (var row in results) {
      events.add(Event.fromMap(row.fields));
    }

    return events;
  }

  Future<Event?> getEventByID(int eventId) async {
    var conn = await _ensureConnection();
    var results = await conn.query(
      'SELECT * FROM events WHERE id = ?',
      [eventId],
    );

    if (results.isNotEmpty) {
      return Event.fromMap(results.first.fields);
    }
    return null;
  }

  Future<void> addEvent(Event event) async {
    var conn = await _ensureConnection();
    await conn.query(
      'INSERT INTO events (title, startdate, enddate, location, beschrijving, idGebruiker) VALUES (?, ?, ?, ?, ?, ?)',
      [
        event.title,
        event.startdate.toUtc(),
        event.enddate.toUtc(),
        event.location,
        event.beschrijving,
        event.idGebruiker,
      ],
    );
  }

  Future<void> addInschrijving(Inschrijving inschrijving) async {
    var conn = await _ensureConnection();
    await conn.query(
      'INSERT INTO inschrijvingen (event_id, gebruiker_id, status) VALUES (?, ?, ?)',
      [
        inschrijving.event_id,
        inschrijving.gebruiker_id,
        inschrijving.status,
      ],
    );
  }

  Future<InschrijvingDTO?> getInschrijving(int eventId, int idGebruiker) async {
    var conn = await _ensureConnection();
    var results = await conn.query(
      'SELECT * FROM inschrijvingen WHERE event_id = ? AND gebruiker_id = ?',
      [
        eventId,
        idGebruiker,
      ],
    );

    if (results.isNotEmpty) {
      Event? event = await getEventByID(results.first.fields['event_id']);
      User? user = await getUserProfile(results.first.fields['gebruiker_id']);

      InschrijvingDTO tijdelijkInschrijving = InschrijvingDTO(
        event: event,
        gebruiker: user,
        status: results.first.fields['status'],
      );

      return tijdelijkInschrijving;
    }
    return null;
  }

  Future<void> deleteInschrijving(InschrijvingDTO inschrijving) async {
    var conn = await _ensureConnection();
    await conn.query(
      'DELETE FROM `inschrijvingen` WHERE event_id = ? AND gebruiker_id = ?',
      [inschrijving.event!.id, inschrijving.gebruiker!.id],
    );
  }

  Future<void> deleteEvent(int eventId) async {
    var conn = await _ensureConnection();
    await conn.query(
      'DELETE FROM events WHERE id = ?',
      [eventId],
    );
  }

  Future<void> updateInschrijvingStatus(Inschrijving inschrijving) async {
    var conn = await _ensureConnection();
    await conn.query(
      'UPDATE `inschrijvingen` SET `status`= ? WHERE `event_id` = ? AND `gebruiker_id` = ?',
      [
        inschrijving.status,
        inschrijving.event_id,
        inschrijving.gebruiker_id,
      ],
    );
  }

  Future<void> editEvent(Event event) async {
    var conn = await _ensureConnection();
    await conn.query(
      'UPDATE events SET title = ?, startdate = ?, enddate = ?, location = ?, beschrijving = ? WHERE id = ?',
      [
        event.title,
        event.startdate.toUtc(),
        event.enddate.toUtc(),
        event.location,
        event.beschrijving,
        event.id,
      ],
    );
  }

  Future<List<InschrijvingDTO>> getInschrijvingenByUserId(int userId) async {
    var conn = await _ensureConnection();
    final results = await conn.query(
      'SELECT * FROM inschrijvingen WHERE gebruiker_id = ?',
      [userId],
    );

    List<InschrijvingDTO> inschrijvingen = [];
    for (var row in results) {
      Event? event = await getEventByID(row.fields['event_id']);
      User? user = await getUserProfile(row.fields['gebruiker_id']);
      if (event != null && user != null) {
        inschrijvingen.add(
          InschrijvingDTO(
            event: event,
            gebruiker: user,
            status: row.fields['status'],
          ),
        );
      }
    }

    return inschrijvingen;
  }
}
