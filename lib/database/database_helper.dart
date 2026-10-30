import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Use one shared database connection throughout the application.
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Future<Database>? _database;

  Future<Database> get database => _database ??= _initDatabase();

  Future<Database> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'bloody_mystery.db');

    return openDatabase(
      dbPath,
      version: 2,
      // Required for SQLite to enforce our relationships.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createTables(db);
        await _createIndexes(db);
        await _ensureGameState(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // The version 1 database contains only the evidence table.
          // Create the missing tables without replacing existing evidence.
          await _createTables(db);

          // Add the character relationship to the old evidence table.
          await db.execute('''
            ALTER TABLE evidence
            ADD COLUMN member_id INTEGER
            REFERENCES town_members(id) ON DELETE SET NULL
          ''');

          await _createIndexes(db);
          await _ensureGameState(db);
        }
      },
    );
  }

  // SCHEMA ---------------------------------------------------------------

  Future<void> _createTables(Database db) async {
    // Fixed character information, plus progress flags.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS town_members (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        is_alive INTEGER NOT NULL DEFAULT 1
          CHECK (is_alive IN (0, 1)),
        role_revealed INTEGER NOT NULL DEFAULT 0
          CHECK (role_revealed IN (0, 1))
      )
    ''');

    // Fixed, authored questions and their responses.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dialogue_options (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL
          REFERENCES town_members(id) ON DELETE CASCADE,
        question TEXT NOT NULL,
        response TEXT NOT NULL,
        day_number INTEGER NOT NULL DEFAULT 1
          CHECK (day_number >= 1)
      )
    ''');

    // Fixed clues, with discovery status that changes during gameplay.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS evidence (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        discovered INTEGER NOT NULL DEFAULT 0
          CHECK (discovered IN (0, 1)),
        member_id INTEGER
          REFERENCES town_members(id) ON DELETE SET NULL
      )
    ''');

    // A single saved game; this table always uses id = 1.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS game_state (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        day_number INTEGER NOT NULL DEFAULT 1
          CHECK (day_number >= 1),
        phase TEXT NOT NULL DEFAULT 'day'
          CHECK (phase IN ('setup', 'day', 'night', 'finished')),
        conversations_used INTEGER NOT NULL DEFAULT 0
          CHECK (conversations_used >= 0),
        tokens INTEGER NOT NULL DEFAULT 0
          CHECK (tokens >= 0),
        is_finished INTEGER NOT NULL DEFAULT 0
          CHECK (is_finished IN (0, 1))
      )
    ''');

    // Stores only the dialogue choices that the player has made.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dialogue_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        option_id INTEGER NOT NULL
          REFERENCES dialogue_options(id) ON DELETE CASCADE,
        day_number INTEGER NOT NULL CHECK (day_number >= 1),
        asked_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _createIndexes(Database db) async {
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_dialogue_member_day
      ON dialogue_options(member_id, day_number)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_evidence_member_discovered
      ON evidence(member_id, discovered)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_history_option
      ON dialogue_history(option_id)
    ''');
  }

  Future<void> _ensureGameState(Database db) async {
    await db.insert(
      'game_state',
      {'id': 1},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // TOWN MEMBERS: CREATE / READ / UPDATE / DELETE ------------------------

  Future<int> createTownMember({
    required int id,
    required String name,
    required String role,
    bool isAlive = true,
    bool roleRevealed = false,
  }) async {
    final db = await database;
    return db.insert('town_members', {
      'id': id,
      'name': name,
      'role': role,
      'is_alive': isAlive ? 1 : 0,
      'role_revealed': roleRevealed ? 1 : 0,
    });
  }

  Future<List<Map<String, Object?>>> getTownMembers() async {
    final db = await database;
    return db.query('town_members', orderBy: 'id ASC');
  }

  Future<Map<String, Object?>?> getTownMember(int id) async {
    final db = await database;
    final rows = await db.query(
      'town_members',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<int> updateTownMember({
    required int id,
    String? name,
    String? role,
    bool? isAlive,
    bool? roleRevealed,
  }) async {
    final changes = <String, Object?>{};
    if (name != null) changes['name'] = name;
    if (role != null) changes['role'] = role;
    if (isAlive != null) changes['is_alive'] = isAlive ? 1 : 0;
    if (roleRevealed != null) {
      changes['role_revealed'] = roleRevealed ? 1 : 0;
    }
    if (changes.isEmpty) return 0;

    final db = await database;
    return db.update(
      'town_members',
      changes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTownMember(int id) async {
    final db = await database;
    return db.delete('town_members', where: 'id = ?', whereArgs: [id]);
  }

  // DIALOGUE OPTIONS: CREATE / READ / UPDATE / DELETE --------------------

  Future<int> createDialogueOption({
    required int memberId,
    required String question,
    required String response,
    int dayNumber = 1,
  }) async {
    final db = await database;
    return db.insert('dialogue_options', {
      'member_id': memberId,
      'question': question,
      'response': response,
      'day_number': dayNumber,
    });
  }

  Future<List<Map<String, Object?>>> getDialogueOptions({
    required int memberId,
    int? dayNumber,
  }) async {
    final db = await database;
    return db.query(
      'dialogue_options',
      where: dayNumber == null
          ? 'member_id = ?'
          : 'member_id = ? AND day_number = ?',
      whereArgs: dayNumber == null
          ? [memberId]
          : [memberId, dayNumber],
      orderBy: 'id ASC',
    );
  }

  Future<int> updateDialogueOption({
    required int id,
    String? question,
    String? response,
    int? dayNumber,
  }) async {
    final changes = <String, Object?>{};
    if (question != null) changes['question'] = question;
    if (response != null) changes['response'] = response;
    if (dayNumber != null) changes['day_number'] = dayNumber;
    if (changes.isEmpty) return 0;

    final db = await database;
    return db.update(
      'dialogue_options',
      changes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteDialogueOption(int id) async {
    final db = await database;
    return db.delete('dialogue_options', where: 'id = ?', whereArgs: [id]);
  }

  // EVIDENCE: CREATE / READ / UPDATE / DELETE ----------------------------

  Future<int> createEvidence({
    required String title,
    required String description,
    bool discovered = false,
    int? memberId,
  }) async {
    final db = await database;
    return db.insert('evidence', {
      'title': title,
      'description': description,
      'discovered': discovered ? 1 : 0,
      'member_id': memberId,
    });
  }

  Future<List<Map<String, Object?>>> getEvidence({
    bool discoveredOnly = false,
    int? memberId,
  }) async {
    final db = await database;
    final conditions = <String>[];
    final args = <Object?>[];

    if (discoveredOnly) {
      conditions.add('discovered = ?');
      args.add(1);
    }
    if (memberId != null) {
      conditions.add('member_id = ?');
      args.add(memberId);
    }

    return db.query(
      'evidence',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'id ASC',
    );
  }

  Future<int> updateEvidence({
    required int id,
    String? title,
    String? description,
    bool? discovered,
    int? memberId,
  }) async {
    final changes = <String, Object?>{};
    if (title != null) changes['title'] = title;
    if (description != null) changes['description'] = description;
    if (discovered != null) changes['discovered'] = discovered ? 1 : 0;
    if (memberId != null) changes['member_id'] = memberId;
    if (changes.isEmpty) return 0;

    final db = await database;
    return db.update('evidence', changes, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEvidence(int id) async {
    final db = await database;
    return db.delete('evidence', where: 'id = ?', whereArgs: [id]);
  }

  // GAME STATE: READ / UPDATE --------------------------------------------

  Future<Map<String, Object?>> getGameState() async {
    final db = await database;
    final rows = await db.query('game_state', where: 'id = ?', whereArgs: [1]);
    return rows.first; // The initial row is created when the DB opens.
  }

  Future<int> updateGameState({
    int? dayNumber,
    String? phase,
    int? conversationsUsed,
    int? tokens,
    bool? isFinished,
  }) async {
    final changes = <String, Object?>{};
    if (dayNumber != null) changes['day_number'] = dayNumber;
    if (phase != null) changes['phase'] = phase;
    if (conversationsUsed != null) {
      changes['conversations_used'] = conversationsUsed;
    }
    if (tokens != null) changes['tokens'] = tokens;
    if (isFinished != null) changes['is_finished'] = isFinished ? 1 : 0;
    if (changes.isEmpty) return 0;

    final db = await database;
    return db.update('game_state', changes, where: 'id = ?', whereArgs: [1]);
  }

  // DIALOGUE HISTORY: RECORD / READ --------------------------------------

  Future<int> recordDialogueChoice({
    required int optionId,
    required int dayNumber,
  }) async {
    final db = await database;
    return db.insert('dialogue_history', {
      'option_id': optionId,
      'day_number': dayNumber,
    });
  }

  // Returns only dialogue the player actually selected and heard.
  Future<List<Map<String, Object?>>> getDialogueHistory({
    int? memberId,
  }) async {
    final db = await database;
    return db.rawQuery('''
      SELECT
        h.id,
        h.option_id,
        h.day_number,
        h.asked_at,
        d.member_id,
        m.name AS member_name,
        d.question,
        d.response
      FROM dialogue_history AS h
      JOIN dialogue_options AS d ON d.id = h.option_id
      JOIN town_members AS m ON m.id = d.member_id
      WHERE (? IS NULL OR d.member_id = ?)
      ORDER BY h.id ASC
    ''', [memberId, memberId]);
  }

  // NEW GAME: RESET PROGRESS WITHOUT DELETING STORY CONTENT --------------

  Future<void> resetGame() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('dialogue_history');
      await txn.update('town_members', {
        'is_alive': 1,
        'role_revealed': 0,
      });
      await txn.update('evidence', {'discovered': 0});
      await txn.update(
        'game_state',
        {
          'day_number': 1,
          'phase': 'day',
          'conversations_used': 0,
          'tokens': 0,
          'is_finished': 0,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
    });
  }
}
