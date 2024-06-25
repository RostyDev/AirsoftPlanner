import 'package:mysql1/mysql1.dart';

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
  
  // Function to check login credentials and return user information if successful
  Future<Map<String, dynamic>?> checkLogin(String username, String password) async {
    await init();
    var results = await _connection.query(
      'SELECT * FROM gebruikers WHERE gebruikersnaam = ? AND wachtwoord = ?',
      [username, password]
    );
    await close();
    if (results.isNotEmpty) {
      return results.first.fields; 
    }
    return null; 
  }

  // Overige methodes (fetchData, insertData, updateData, deleteData)
  Future<List<Map<String, dynamic>>> fetchData() async {
    await init();
    var results = await _connection.query('SELECT * FROM your_table');
    List<Map<String, dynamic>> data = [];
    for (var row in results) {
      data.add({
        'column1': row[0],
        'column2': row[1],
        // Voeg meer kolommen toe indien nodig
      });
    }
    await close();
    return data;
  }

  Future<void> insertData(String column1Value, String column2Value) async {
    await init();
    await _connection.query(
      'INSERT INTO your_table (column1, column2) VALUES (?, ?)',
      [column1Value, column2Value],
    );
    await close();
  }

  Future<void> updateData(int id, String column1Value, String column2Value) async {
    await init();
    await _connection.query(
      'UPDATE your_table SET column1 = ?, column2 = ? WHERE id = ?',
      [column1Value, column2Value, id],
    );
    await close();
  }

  Future<void> deleteData(int id) async {
    await init();
    await _connection.query('DELETE FROM your_table WHERE id = ?', [id]);
    await close();
  }
}