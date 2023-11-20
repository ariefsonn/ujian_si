import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Mendapatkan path untuk lokasi penyimpanan database di perangkat
    String path = join(await getDatabasesPath(), 'school_database.db');

    // Membuka atau membuat database jika belum ada
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    // Membuat tabel User
    await db.execute('''
      CREATE TABLE User (
        user_id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT,
        email TEXT,
        role TEXT
      )
    ''');

    // Membuat tabel Student
    await db.execute('''
      CREATE TABLE Student (
        student_id INTEGER PRIMARY KEY,
        nama_student TEXT,
        kelas TEXT
      )
    ''');

    // Membuat tabel Nilai
    await db.execute('''
      CREATE TABLE Nilai (
        nilai_id INTEGER PRIMARY KEY,
        student_id INTEGER,
        nilai_harian REAL,
        nilai_uts REAL,
        nilai_uas REAL,
        FOREIGN KEY(student_id) REFERENCES Student(student_id)
      )
    ''');
    await db.insert('User', {'username': 'admin', 'password': '123', 'email': 'admin', 'role': 'A'});
  }

  Future<bool> login(String email, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> user = await db.query('User',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);

    if (user.isNotEmpty) {
      String role = user[0]['role'];
      String name = user[0]['username'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (role == 'A') {
        await prefs.setString('role', 'admin');
      } else if (role == 'T') {
        await prefs.setString('role', 'teacher');
      }
      await prefs.setString('name', name);
      return true;
    }
    return false;
  }

  Future<void> register(String username, String password, String name) async {
    Database db = await instance.database;
    await db.insert('User', {'username': username, 'password': password, 'email': name, 'role': 'T'});
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    Database db = await instance.database;
    return await db.query('Student', columns: ['student_id', 'nama_student']);
  }

  Future<Map<String, dynamic>> getNilaiById(int studentId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> nilai = await db.query('Nilai',
        where: 'student_id = ?', whereArgs: [studentId]);

    if (nilai.isNotEmpty) {
      return nilai[0];
    } else {
      return {}; // Jika tidak ada nilai yang ditemukan untuk ID student tertentu
    }
  }

  Future<void> addStudent(String name, String kelas) async {
    Database db = await instance.database;
    await db.insert('Student', {'nama_student': name, 'kelas': kelas});
  }
  Future<void> addNilai(String id, String harian, String uts, String uas) async {
    Database db = await instance.database;
    await db.insert('Nilai', {'student_id': id, 'nilai_harian': harian, 'nilai_uts': uts, 'nilai_uas': uas});
  }
}
