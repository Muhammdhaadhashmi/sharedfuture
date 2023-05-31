import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_future/ApplicationModules/CartModule/Models/cart_model.dart';
import 'package:shared_future/ApplicationModules/ProfileModule/Models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseHepler {
  static Database? _database;
  static String DBNAME = "db_sharedfuture";

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database!;
    // If database don't exists, create one
    _database = await initLocalDatabase();
    return _database!;
  }

  Future<bool> databaseExists() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DBNAME);
    return databaseFactory.databaseExists(path);
  }

  // Create the database and the Employee table
  initLocalDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DBNAME);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE tbl_users('
          'id integer,'
          'customer_name Text,'
          'customer_phone Text,'
          'customer_email Text,'
          'customer_password Text,'
          'customer_address Text,'
          'customer_status Text,'
          'customer_type Text,'
          'customer_image Text,'
          'is_verified Text,'
          'customer_location_lat Text,'
          'customer_location_lng Text'
          ')');

      await db.execute('CREATE TABLE tbl_login('
          'id integer,'
          'customer_name Text,'
          'customer_phone Text,'
          'customer_email Text,'
          'customer_password Text,'
          'customer_address Text,'
          'customer_status Text,'
          'customer_type Text,'
          'customer_image Text,'
          'is_verified Text,'
          'customer_location_lat Text,'
          'customer_location_lng Text'
          ')');

      await db.execute('CREATE TABLE tbl_cart('
          'id integer primary key autoincrement,'
          'productId numeric,'
          'businessId numeric,'
          'businessManId numeric,'
          'businessName Text,'
          'businessContact Text,'
          'businessAddress Text,'
          'property Text,'
          'unit Text,'
          'des Text,'
          'productName Text,'
          'discountPrice numeric,'
          'salePrice numeric,'
          'saleQuantity numeric,'
          'quantity numeric,'
          'Price numeric,'
          'shipping_charges numeric,'
          'image Text'
          ')');
    });

  }

  Future<int> insertCustomer(
      {required List<UserModel> userList, required String tableName}) async {
    final db = await database;
    int res = 0;
    for (UserModel value in userList) {
      res = await db.insert(
        tableName,
        value.toJson(),
      );
    }
    return res;
  }

  Future<int> updateProfile(
      {required UserModel userModel, required String tableName}) async {
    final db = await database;
    int res = await db.update(
      tableName,
      userModel.toJson(),
      where: 'id=?',
      whereArgs: [userModel.customerId],
    );

    return res;
  }

  Future<int> addCart({required CartModel cartModel}) async {
    final db = await database;
    int res = await db.insert(
      "tbl_cart",
      cartModel.toJson(),
    );
    print(res);
    return res;
  }

  Future<int> updateCartQuantity(
      {required int id, required int quantity}) async {
    final db = await database;
    int res = await db.update(
      "tbl_cart",
      {"quantity": quantity},
      where: 'id=?',
      whereArgs: [id],
    );
    // print(res);

    return res;
  }

  Future<int> updateProductPrice({required int id, required int Price}) async {
    final db = await database;
    int res = await db.update(
      "tbl_cart",
      {"Price": Price},
      where: 'id=?',
      whereArgs: [id],
    );
    // print(res);

    return res;
  }

  deleteCart({required int id}) async {
    final db = await database;
    await db.rawDelete("DELETE FROM tbl_cart where id =?", [id]);
  }

  Future<List<CartModel>> fetchCart() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM tbl_cart");
    return CartModel.localToListView(res);
  }

  deleteAddress({required int id}) async {
    final db = await database;
    final res =
        await db.rawDelete("DELETE FROM tbl_address where address_id =?", [id]);
    print("delete");
    print(res);
  }

  Future<List<Map<String, Object?>>> checkUserForLogin(
      {required String email, required String password}) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT * FROM tbl_users WHERE customer_email = ? AND customer_password=? ',
        [email, password]);

    // List<UserModel> loginList = UserModel.jsonToListView(res);
    // await insertCustomer(userList: loginList, tableName: "tbl_login");
    return res;
  }

  Future<List<Map<String, Object?>>> insertUserForLogin(
      {required String email}) async {
    final db = await database;
    final res = await db
        .rawQuery('SELECT * FROM tbl_users WHERE customer_email = ?', [email]);

    List<UserModel> loginList = UserModel.jsonToListView(res);
    print(loginList);
    await insertCustomer(userList: loginList, tableName: "tbl_login");
    return res;
  }

  Future<int> updateUserVerify({required String email}) async {
    final db = await database;
    int res = await db.update(
      "tbl_login",
      {"is_verified": "1"},
      where: 'customer_email=?',
      whereArgs: [email],
    );

    await db.update(
      "tbl_users",
      {"is_verified": "1"},
      where: 'customer_email=?',
      whereArgs: [email],
    );
    // print(res);

    return res;
  }

  Future<Object?> checkUserVarified({
    required String email,
  }) async {
    final db = await database;
    final res = await db.rawQuery(
        'SELECT is_verified FROM tbl_users WHERE customer_email = ?',
        [email]);

    // List<UserModel> loginList = UserModel.jsonToListView(res);
    // await insertCustomer(userList: loginList, tableName: "tbl_login");
    print("is_verified");
    print(res[0]["is_verified"]);
    return res[0]["is_verified"];
  }

  Future<List<UserModel>> fetchCurrentUser() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM tbl_login');

    print(res);

    return UserModel.jsonToListView(res);
  }

  deleteTable({required String tableName}) async {
    final db = await database;
    await db.rawDelete("DELETE FROM ${tableName}");
  }

  Future<int> checkDataExistenceByLength({required String table}) async {
    final db = await database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ${table}'))!;
    return count;
  }
}
