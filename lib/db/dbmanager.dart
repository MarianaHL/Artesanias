import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbStudentManager {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "ss.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE student(id INTEGER PRIMARY KEY autoincrement, "
              "name TEXT, "
              "course TEXT, "
              "costo TEXT, "
              "largo TEXT, "
              "ancho TEXT)",

        );
      } );
    }
  }

  Future<int> insertStudent(Student student) async {
    await openDb();
    return await _database.insert('student', student.toMap());
  }

  Future<List<Student>> getStudentList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('student');
    return List.generate(maps.length, (i) {
      return Student(
          id: maps[i]['id'],
          name: maps[i]['name'],
          course: maps[i]['course'],
          costo: maps[i]['costo'],
          largo: maps[i]['largo'],
          ancho: maps[i]['ancho'],
      );
    });
  }

  Future<int> updateStudent(Student student) async {
    await openDb();
    return await _database.update('student', student.toMap(),
        where: "id = ?", whereArgs: [student.id]);
  }

  Future<void> deleteStudent(int id) async {
    await openDb();
    await _database.delete(
        'student',
        where: "id = ?", whereArgs: [id]
    );
  }
}

class Student {
  int id;
  String name;
  String course;
  String costo;
  String largo;
  String ancho;
  Student({
    @required this.name,
    @required this.course,
    @required this.costo,
    @required this.largo,
    @required this.ancho,
    this.id});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'course': course,
      'costo': costo,
      'largo': largo,
      'ancho': ancho,
    };
  }
}