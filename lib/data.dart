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
  IntColumn get position => integer().withDefault(const Constant(0))();
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [Switches])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
    }, onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // we added the dueDate property in the change from version 1 to
        // version 2
        await m.addColumn(switches, switches.position);
      }
    });
  }

  Future<List<SwitchEntry>> get allSwitches => select(switches).get();

  Stream<List<SwitchEntry>> get watchSwitches =>
      (select(switches)..orderBy([(t) => OrderingTerm(expression: t.position)]))
          .watch();

  Future<int> addSwitch(SwitchesCompanion entry) {
    return into(switches).insert(entry);
  }

  Future<void> deleteAllSwitches() async {
    await delete(switches).go();
  }

  Future<int> deleteSwitch(int id) async {
    return (delete(switches)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<SwitchEntry> getSwitch(int id) {
    return (select(switches)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future updateSwitch(SwitchEntry updatedSwitch) {
    return update(switches).replace(updatedSwitch);
  }

  Future setPosition(int id, int position) async {
    return update(switches)
      ..where((tbl) => tbl.id.equals(id))
      ..write(SwitchesCompanion(position: Value(position)));
  }

  Future changePosition(int oldPos, int newPos) async {
    return update(switches)
      ..where((tbl) => tbl.position.equals(oldPos))
      ..write(SwitchesCompanion(position: Value(newPos)));
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
