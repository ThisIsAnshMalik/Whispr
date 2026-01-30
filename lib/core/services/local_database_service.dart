import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whispr_app/core/models/comment_model.dart';
import 'package:whispr_app/core/models/post_model.dart';
import 'package:whispr_app/core/models/user_model.dart';

/// Singleton service for local SQLite database operations.
class LocalDatabaseService {
  LocalDatabaseService._();
  static final LocalDatabaseService instance = LocalDatabaseService._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'whispr.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        display_name TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE UNIQUE INDEX idx_users_email ON users(email)');

    // Create posts table
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        caption TEXT NOT NULL,
        media_path TEXT,
        media_type TEXT,
        visibility TEXT NOT NULL,
        allow_comments INTEGER NOT NULL DEFAULT 1,
        likes INTEGER NOT NULL DEFAULT 0,
        is_liked INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_posts_created ON posts(created_at)');

    // Create comments table
    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id TEXT NOT NULL,
        parent_id INTEGER,
        text TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (parent_id) REFERENCES comments (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('CREATE INDEX idx_comments_post ON comments(post_id)');
    await db.execute('CREATE INDEX idx_comments_parent ON comments(parent_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add posts table in version 2
      await db.execute('''
        CREATE TABLE IF NOT EXISTS posts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          caption TEXT NOT NULL,
          media_path TEXT,
          media_type TEXT,
          visibility TEXT NOT NULL,
          allow_comments INTEGER NOT NULL DEFAULT 1,
          likes INTEGER NOT NULL DEFAULT 0,
          is_liked INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL
        )
      ''');
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_posts_created ON posts(created_at)',
      );

      // Also ensure comments table exists (may have been missed in v1)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS comments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          post_id TEXT NOT NULL,
          parent_id INTEGER,
          text TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          FOREIGN KEY (parent_id) REFERENCES comments (id) ON DELETE CASCADE
        )
      ''');
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_comments_post ON comments(post_id)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_comments_parent ON comments(parent_id)',
      );
    }

    if (oldVersion < 3) {
      // Add users table in version 3
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT NOT NULL UNIQUE,
          password_hash TEXT NOT NULL,
          display_name TEXT,
          created_at INTEGER NOT NULL
        )
      ''');
      await db.execute(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email ON users(email)',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Posts CRUD
  // ---------------------------------------------------------------------------

  /// Inserts a new post and returns it with its assigned id.
  Future<PostModel> insertPost(PostModel post) async {
    final db = await database;
    final id = await db.insert('posts', post.toMap());
    return post.copyWith(id: id);
  }

  /// Fetches all posts ordered by most recent.
  Future<List<PostModel>> getAllPosts() async {
    final db = await database;
    final maps = await db.query('posts', orderBy: 'created_at DESC');
    return maps.map(PostModel.fromMap).toList();
  }

  /// Fetches a single post by id.
  Future<PostModel?> getPost(int id) async {
    final db = await database;
    final maps = await db.query('posts', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return PostModel.fromMap(maps.first);
  }

  /// Updates a post's caption.
  Future<int> updatePostCaption(int id, String newCaption) async {
    final db = await database;
    return await db.update(
      'posts',
      {'caption': newCaption},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Toggles the like status and updates like count.
  Future<PostModel?> toggleLike(int id) async {
    final db = await database;
    final post = await getPost(id);
    if (post == null) return null;

    final newIsLiked = !post.isLiked;
    // Prevent negative likes
    final newLikes = newIsLiked
        ? post.likes + 1
        : (post.likes - 1).clamp(0, 999999999);

    await db.update(
      'posts',
      {'is_liked': newIsLiked ? 1 : 0, 'likes': newLikes},
      where: 'id = ?',
      whereArgs: [id],
    );

    return post.copyWith(isLiked: newIsLiked, likes: newLikes);
  }

  /// Deletes a post by id.
  Future<int> deletePost(int id) async {
    final db = await database;
    // Also delete associated comments
    await db.delete('comments', where: 'post_id = ?', whereArgs: ['post_$id']);
    return await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------
  // Comments CRUD
  // ---------------------------------------------------------------------------

  /// Inserts a new comment and returns it with its assigned id.
  Future<CommentModel> insertComment(CommentModel comment) async {
    final db = await database;
    final id = await db.insert('comments', comment.toMap());
    return comment.copyWith(id: id);
  }

  /// Fetches all top-level comments for a post (parentId is null).
  Future<List<CommentModel>> getCommentsForPost(String postId) async {
    final db = await database;
    final maps = await db.query(
      'comments',
      where: 'post_id = ? AND parent_id IS NULL',
      whereArgs: [postId],
      orderBy: 'created_at DESC',
    );
    return maps.map(CommentModel.fromMap).toList();
  }

  /// Fetches replies for a given parent comment id.
  Future<List<CommentModel>> getReplies(int parentId) async {
    final db = await database;
    final maps = await db.query(
      'comments',
      where: 'parent_id = ?',
      whereArgs: [parentId],
      orderBy: 'created_at ASC',
    );
    return maps.map(CommentModel.fromMap).toList();
  }

  /// Deletes a comment by id (and its replies via CASCADE).
  Future<int> deleteComment(int id) async {
    final db = await database;
    return await db.delete('comments', where: 'id = ?', whereArgs: [id]);
  }

  /// Updates a comment's text.
  Future<int> updateComment(int id, String newText) async {
    final db = await database;
    return await db.update(
      'comments',
      {'text': newText},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Counts total comments (including replies) for a post.
  Future<int> countCommentsForPost(String postId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM comments WHERE post_id = ?',
      [postId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ---------------------------------------------------------------------------
  // Users CRUD
  // ---------------------------------------------------------------------------

  /// Inserts a new user and returns it with its assigned id.
  /// Email is normalized to lowercase for consistent lookups.
  Future<UserModel> insertUser(UserModel user) async {
    final db = await database;
    // Normalize email to lowercase
    final normalizedUser = user.copyWith(email: user.email.toLowerCase());
    final id = await db.insert('users', normalizedUser.toMap());
    return normalizedUser.copyWith(id: id);
  }

  /// Fetches a user by id.
  Future<UserModel?> getUser(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  /// Fetches a user by email.
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  /// Updates a user's password hash.
  Future<int> updateUserPassword(int id, String newPasswordHash) async {
    final db = await database;
    return await db.update(
      'users',
      {'password_hash': newPasswordHash},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Updates a user's display name.
  Future<int> updateUserDisplayName(int id, String displayName) async {
    final db = await database;
    return await db.update(
      'users',
      {'display_name': displayName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Deletes a user by id.
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  /// Checks if any users exist in the database.
  Future<bool> hasUsers() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM users');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }
}
