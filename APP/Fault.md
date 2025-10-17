Launching lib\main.dart on V2403A in debug mode...
Running Gradle task 'assembleDebug'...
警告: [options] 源值 8 已过时，将在未来发行版中删除
警告: [options] 目标值 8 已过时，将在未来发行版中删除
警告: [options] 要隐藏有关已过时选项的警告, 请使用 -Xlint:-options。
3 个警告
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...
D/FlutterJNI(28670): Beginning load of flutter...
D/FlutterJNI(28670): flutter (null) was loaded normally!
I/flutter (28670): [IMPORTANT:flutter/shell/platform/android/android_context_vk_impeller.cc(62)] Using the Impeller rendering backend (Vulkan).
Debug service listening on ws://127.0.0.1:2376/08Zsjp0FKzg=/ws
Syncing files to device V2403A...
I/flutter (28670): 🔐 [MAIN] 检查存储权限...
V/ActivityThread(28670): updateVmProcessStateForGc sceneId =1000 state=83886080
I/ple.check_words(28670): dgc_arg: has_act=1, state=1
V/ActivityThread(28670): updateVmProcessStateForGc sceneId =1 state=196608
I/ple.check_words(28670): Close vivo delay for GC JIT .
I/flutter (28670): ❌ 存储权限被拒绝
I/flutter (28670): ❌ [MAIN] 存储权限被拒绝，数据导入可能失败
I/flutter (28670): 📋 [MAIN] 权限状态: {platform: TargetPlatform.android, storage: PermissionStatus.denied, manageExternalStorage: PermissionStatus.denied, photos: not_checked}
I/flutter (28670): 🚀 [MAIN] Starting data import from assets...
I/flutter (28670): 🚀 [MAIN] Database initialized: AppDatabase
I/flutter (28670): [DataImport] 开始导入词汇数据...
I/flutter (28670): 🍔🍔🍔 [DataImport] 检查导入状态: 已导入=false, 版本=0, 当前版本=15
I/flutter (28670): 🍔🍔🍔 [DataImport] 检测到版本升级，强制重新导入数据
I/flutter (28670): [DataImport] 从数据库文件导入真实CET4词汇数据...
I/flutter (28670): [DataImport] 清空现有测试数据...
I/flutter (28670): Drift: Sent CREATE TABLE IF NOT EXISTS "words_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "word_id" TEXT NOT NULL, "book_id" TEXT NOT NULL, "word_rank" INTEGER NOT NULL, "head_word" TEXT NOT NULL, "usphone" TEXT NULL, "ukphone" TEXT NULL, "usspeech" TEXT NULL, "ukspeech" TEXT NULL, "tra
I/flutter (28670): ns" TEXT NOT NULL DEFAULT '[]', "sentences" TEXT NOT NULL DEFAULT '[]', "phrases" TEXT NOT NULL DEFAULT '[]', "synonyms" TEXT NOT NULL DEFAULT '[]', "rel_words" TEXT NOT NULL DEFAULT '[]', "exams" TEXT NOT NULL DEFAULT '[]', "search_content" TEXT NOT NULL DEFAULT '', "created_at" INTEGER NOT NULL DE
I/flutter (28670): FAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), "updated_at" INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), UNIQUE ("word_id")); with args []
I/flutter (28670): Drift: Sent CREATE TABLE IF NOT EXISTS "users_table" ("id" TEXT NOT NULL, "name" TEXT NOT NULL DEFAULT '学习者', "avatar_path" TEXT NULL, PRIMARY KEY ("id")); with args []
I/flutter (28670): Drift: Sent CREATE TABLE IF NOT EXISTS "favorites_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "word_id" INTEGER NOT NULL REFERENCES words_table (id) ON DELETE CASCADE, "is_favorited" INTEGER NOT NULL DEFAULT 0 CHECK ("is_favorited" IN (0, 1)), "learning_status" INTEGER NOT NULL DEFAULT 
I/flutter (28670): 0, "review_count" INTEGER NOT NULL DEFAULT 0, "correct_count" INTEGER NOT NULL DEFAULT 0, "incorrect_count" INTEGER NOT NULL DEFAULT 0, "memory_strength" REAL NOT NULL DEFAULT 0.0, "next_review_at" INTEGER NULL, "review_interval" INTEGER NOT NULL DEFAULT 1, "ease_factor" REAL NOT NULL DEFAULT 2.5, "
I/flutter (28670): notes" TEXT NOT NULL DEFAULT '', "created_at" INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), "updated_at" INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), "last_reviewed_at" INTEGER NULL, UNIQUE ("word_id")); with args []
I/flutter (28670): Drift: Sent CREATE TABLE IF NOT EXISTS "search_history_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" TEXT NOT NULL REFERENCES users_table (id) ON DELETE CASCADE, "query" TEXT NOT NULL, "result_count" INTEGER NOT NULL DEFAULT 0, "timestamp" INTEGER NOT NULL DEFAULT (CAST(strftime
I/flutter (28670): ('%s', CURRENT_TIMESTAMP) AS INTEGER)), UNIQUE ("user_id", "query")); with args []
I/flutter (28670): Drift: Sent           CREATE VIRTUAL TABLE words_fts USING fts5(
I/flutter (28670):             head_word,
I/flutter (28670):             word_id,
I/flutter (28670):             search_content
I/flutter (28670):           );
I/flutter (28670):          with args []
I/flutter (28670): Drift: Sent           CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
I/flutter (28670):             INSERT INTO words_fts(rowid, head_word, word_id, search_content)
I/flutter (28670):             VALUES (new.id, new.head_word, new.word_id, new.search_content);
I/flutter (28670):           END;
I/flutter (28670):          with args []
I/flutter (28670): Drift: Sent           CREATE TRIGGER words_fts_delete AFTER DELETE ON words_table BEGIN
I/flutter (28670):             DELETE FROM words_fts WHERE rowid = old.id;
I/flutter (28670):           END;
I/flutter (28670):          with args []
I/flutter (28670): Drift: Sent           CREATE TRIGGER words_fts_update AFTER UPDATE ON words_table BEGIN
I/flutter (28670):             DELETE FROM words_fts WHERE rowid = old.id;
I/flutter (28670):             INSERT INTO words_fts(rowid, head_word, word_id, search_content)
I/flutter (28670):             VALUES (new.id, new.head_word, new.word_id, new.search_content);
I/flutter (28670):           END;
I/flutter (28670):          with args []
I/flutter (28670): Drift: Sent CREATE INDEX idx_words_word_rank ON words_table(word_rank ASC); with args []
I/flutter (28670): Drift: Sent CREATE INDEX idx_words_book_id ON words_table(book_id ASC); with args []
I/flutter (28670): Drift: Sent CREATE INDEX idx_words_head_word ON words_table(head_word ASC); with args []
I/flutter (28670): Drift: Sent CREATE INDEX idx_user_words_user_id ON user_words_table(user_id); with args []
I/flutter (28670): [DataImport] 导入过程中发生错误: SqliteException(1): while executing, no such table: main.user_words_table, SQL logic error (code 1)
I/flutter (28670):   Causing statement: CREATE INDEX idx_user_words_user_id ON user_words_table(user_id);, parameters: 
I/flutter (28670): [DataImport] 词汇数据导入失败
I/flutter (28670): ❌ [MAIN] Data import failed
I/flutter (28670): ❌ [MAIN] Initial data preparation failed: SqliteException(1): while executing, no such table: main.user_words_table, SQL logic error (code 1)
I/flutter (28670):   Causing statement: CREATE INDEX idx_user_words_user_id ON user_words_table(user_id);, parameters: 
I/flutter (28670): Initial data preparation failed
I/flutter (28670): Error: SqliteException(1): while executing, no such table: main.user_words_table, SQL logic error (code 1)
I/flutter (28670):   Causing statement: CREATE INDEX idx_user_words_user_id ON user_words_table(user_id);, parameters: 
I/flutter (28670): package:sqlite3/src/implementation/exception.dart 95:3                             throwException
I/flutter (28670): package:sqlite3/src/implementation/database.dart 306:9                             DatabaseImplementation.execute
I/flutter (28670): package:drift/src/sqlite3/database.dart 145:16                                     Sqlite3Delegate.runWithArgsSync
I/flutter (28670): package:drift/native.dart 378:30                                                   _NativeDelegate.runCustom.<fn>
I/flutter (28670): dart:async/future.dart 315:27                                                      new Future.sync
I/flutter (28670): package:drift/native.dart 378:19                                                   _NativeDelegate.runCustom
I/flutter (28670): package:drift/src/runtime/executor/helpers/engines.dart 115:19                     _BaseExecutor.runCustom.<fn>
I/flutter (28670): package:drift/src/runtime/executor/helpers/engines.dart 61:20                      _BaseExecutor._synchronized
I/flutter (28670): package:drift/src/runtime/executor/helpers/engines.dart 111:12                     _BaseExecutor.runCustom
I/flutter (28670): package:drift/src/remote/server_impl.dart 154:24                                   ServerImplementation._runQuery
I/flutter (28670): package:drift/src/remote/server_impl.dart 119:25                                   ServerImplementation._handleRequest.<fn>
I/flutter (28670): package:drift/src/remote/communication.dart 165:20                                 DriftCommunication.setRequestHandler.<fn>
I/flutter (28670): ===== asynchronous gap ===========================
I/flutter (28670): package:drift/src/remote/communication.dart 113:66                                 DriftCommunication.request
I/flutter (28670): package:drift/src/remote/client_impl.dart 101:28                                   _BaseExecutor._runRequest
I/flutter (28670): package:drift/src/remote/client_impl.dart 116:12                                   _BaseExecutor.runCustom
I/flutter (28670): package:drift/src/runtime/api/connection_user.dart 421:23                          DatabaseConnectionUser.customStatement.<fn>
I/flutter (28670): package:drift/src/runtime/api/connection_user.dart 171:16                          DatabaseConnectionUser.doWhenOpened.<fn>
I/flutter (28670): dart:async/zone.dart 1538:47                                                       _rootRunUnary
I/flutter (28670): dart:async/zone.dart 1429:19                                                       _CustomZone.runUnary
I/flutter (28670): package:check_words/core/database/app_database.dart 92:9                           AppDatabase.migration.<fn>
I/flutter (28670): package:drift/src/runtime/api/db_base.dart 130:9                                   GeneratedDatabase.beforeOpen.<fn>
I/flutter (28670): package:drift/src/remote/client_impl.dart 59:17                                    DriftClient._handleRequest.<fn>
I/flutter (28670): package:drift/src/remote/communication.dart 165:20                                 DriftCommunication.setRequestHandler.<fn>
I/flutter (28670): ===== asynchronous gap ===========================
I/flutter (28670): package:drift/src/remote/communication.dart 113:66                                 DriftCommunication.request
I/flutter (28670): package:drift/src/remote/server_impl.dart 309:24                                   _ServerDbUser.beforeOpen
I/flutter (28670): package:drift/src/runtime/executor/helpers/engines.dart 482:16                     DelegatedDatabase._runMigrations
I/flutter (28670): package:drift/src/runtime/executor/helpers/engines.dart 446:9                      DelegatedDatabase.ensureOpen.<fn>
I/flutter (28670): dart:async/future_impl.dart 96:3                                                   _AsyncCompleter.complete
I/flutter (28670): ===== asynchronous gap ===========================
I/flutter (28670): package:drift/src/remote/communication.dart 113:66                                 DriftCommunication.request
I/flutter (28670): package:drift/src/remote/client_impl.dart 173:10                                   _RemoteQueryExecutor.ensureOpen
I/flutter (28670): package:drift/src/utils/lazy_database.dart 64:49                                   LazyDatabase.ensureOpen.<fn>
I/flutter (28670): dart:async/zone.dart 1538:47                                                       _rootRunUnary
I/flutter (28670): dart:async/zone.dart 1429:19                                                       _CustomZone.runUnary
I/flutter (28670): package:drift/src/runtime/api/connection_user.dart 169:55                          DatabaseConnectionUser.doWhenOpened.<fn>
I/flutter (28670): package:drift/src/runtime/query_builder/statements/select/custom_select.dart 54:3  CustomSelectStatement._mapDbResponse
I/flutter (28670): package:check_words/core/services/data_import_service.dart 105:7                   DataImportService._importFromDatabase
I/flutter (28670): package:check_words/core/services/data_import_service.dart 82:24                   DataImportService.importWordsData
I/flutter (28670): package:check_words/main.dart 41:31                                                main.<fn>
[GoRouter] Full paths for routes:
  => /
  => /profile
  => /settings
  => /word/:id
  => /collected-words
  => /learning
  => /user-profile
known full paths for route names:
  home => /
  profile => /profile
  settings => /settings
  wordDetail => /word/:id
  collectedWords => /collected-words
  learning => /learning
  userProfile => /user-profile

[GoRouter] setting initial location /
I/Choreographer(28670): Skipped 36 frames!  The application may be doing too much work on its main thread.
[GoRouter] Using MaterialApp configuration
[GoRouter] Using MaterialApp configuration
I/Choreographer(28670): Skipped 30 frames!  The application may be doing too much work on its main thread.
V/ImeFocusController(28670): onWindowFocus: com.android.internal.policy.DecorView{c01f47f V.E...... R....... 0,0-1260,2800}[MainActivity] softInputMode=STATE_UNSPECIFIED|ADJUST_RESIZE
D/ProfileInstaller(28670): Installing profile for com.example.check_words
I/flutter (28670): ! 检查数据库状态失败: SqliteException(1): while executing, no such table: main.user_words_table, SQL logic error (code 1)
I/flutter (28670):   Causing statement: CREATE INDEX idx_user_words_user_id ON user_words_table(user_id);, parameters: 
I/flutter (28670): Word data import finished but produced zero rows.
