import 'package:drift/drift.dart';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// assuming that your file is called filename.dart. This will give an error at
// first, but it's needed for drift to know about the generated code
part 'data.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
@DataClassName('SwitchEntry')
class Switches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 6, max: 32)();
  TextColumn get url => text().named('body')();
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [Switches])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;

  Future<List<SwitchEntry>> get allSwitches => select(switches).get();

  Stream<List<SwitchEntry>> get watchSwitches => select(switches).watch();

  Future<int> addSwitch(SwitchesCompanion entry) {
    return into(switches).insert(entry);
  }

  Future<void> deleteAllSwitches() async {
    await delete(switches).go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._();

  DatabaseProvider._();

  MyDatabase? _database;

  Future<MyDatabase> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<MyDatabase> _initDatabase() async {
    final database = MyDatabase();

    return database;
  }
}
