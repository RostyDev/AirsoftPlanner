import 'package:mysql1/mysql1.dart';
import 'models/user_model.dart';
import 'models/event_model.dart';

class DatabaseService {
  // Singleton patroon voor een enkele instantie van de database service
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  // Connection instellingen
  final ConnectionSettings _settings = ConnectionSettings(
    host: '10.0.2.2',
    port: 3306,
    user: 'root',
    db: 'airsoft_planner',
  );

  late MySqlConnection _connection;

  // Methode om de verbinding te initialiseren
  Future<void> init() async {
    _connection = await MySqlConnection.connect(_settings);
  }

  // Methode om de verbinding te sluiten
  Future<void> close() async {
    await _connection.close();
  }

  Future<User?> getUserProfile(int userId) async {
    await init();
    var results = await _connection.query(
      'SELECT * FROM gebruikers WHERE id = ?',
      [userId],
    );
    await close();
    if (results.isNotEmpty) {
      return User.fromMap(results.first.fields);
    }
    return null;
  }

  // Function to check login credentials and return user information if successful
  Future<User?> checkLogin(String username, String password) async {
    await init();
    var results = await _connection.query(
        'SELECT * FROM gebruikers WHERE gebruikersnaam = ? AND wachtwoord = ?',
        [username, password]);
    await close();
    if (results.isNotEmpty) {
      return User.fromMap(results.first.fields);
    }
    return null;
  }

  Future<List<Event>>? getUpcomingEvents() async {
    await init();
    final results = await _connection.query(
      'SELECT * FROM events WHERE enddate > NOW()',
    );

    await close();

    List<Event> events = [];
    for (var row in results) {
      events.add(Event.fromMap(row.fields));
    }

    return events;
  }

  Future<Event?> getEventByID(int eventId) async {
    await init();
    var results = await _connection.query(
      'SELECT * FROM events WHERE id = ?',
      [eventId],
    );

    await close();

    if (results.isNotEmpty) {
      return Event.fromMap(results.first.fields);
    }
    return null;
  }

  Future<void> addEvent(Event event) async {
    await init();
    await _connection.query(
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
    await close();
  }

  Future<void> deleteEvent(int eventId) async {
    await init();
    await _connection.query(
      'DELETE FROM events WHERE id = ?',
      [eventId],
    );
    await close();
  }

  Future<void> editEvent(Event event) async {
    await init();
    await _connection.query(
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
    await close();
  }
}
