import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';



class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();

    return _database;
  }
  //Create DB
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join( documentsDirectory.path, 'ScansDB.db' );

    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: ( Database db, int version ) async {
          await db.execute(
              'CREATE TABLE tabScans('
                  'id INTEGER PRIMARY KEY,'
                  'type TEXT,'
                  'value TEXT'
                  ')'
          );
        }
    );
  }

  // Insert
  newScanRaw( ScanModel newScan ) async {
    final db  = await database;
    final res = await db.rawInsert(
      "INSERT Into tabScans (id, type, value) "
      "VALUES ( ${ newScan.id },  '${ newScan.type }',  '${ newScan.value }' )"
    );
    return res;
  }

  // Insert
  newScan( ScanModel newScan ) async { 
    final db  = await database;
    final res = await db.insert('tabScans', newScan.toJson());

    return res;
  }

  // Selects
  Future<ScanModel> getScanId(int id) async {
    final db  = await database;
    final res = await db.query('tabScans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db  = await database;
    final res = await db.query('tabScans');

    List<ScanModel> list = res.isNotEmpty
                              ? res.map((c) => ScanModel.fromJson(c)).toList()
                              : [];
    return list;
  }

  Future<List<ScanModel>> getScansType(String type) async {
    final db  = await database;
    //final res = await db.query('tabScans', where: 'type = ?', whereArgs: [type]);
    final res = await db.rawQuery("SELECT * FROM tabScans WHERE type='$type'");
    List<ScanModel> list = res.isNotEmpty
        ? res.map((c) => ScanModel.fromJson(c)).toList()
        : [];
    return list;
  }

  //Update
  Future<int> updateScan(ScanModel newScan) async {
    final db  = await database;
    final res = await db.update('tabScans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id]);
    return res;
  }

  //Delete
  Future<int> deleteScan(int id) async {
    final db  = await database;
    final res = await db.delete('tabScans',where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db  = await database;
    final res = await db.delete('tabScans');
    return res;
  }

}