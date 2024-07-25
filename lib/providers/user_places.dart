import 'dart:io';

import 'package:favorites_place/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  //Lấy ra đường dẫn CSDL trên thiết bị
  final dbPath = await sql.getDatabasesPath();

  //Mở cơ sở dữ liệu trong path nhất định
  //Nếu chưa có CSDL thì gói SQLite sẽ tự tạo CSDL
  final db = await sql.openDatabase(path.join(dbPath, 'place.db'),
      onCreate: (db, version) {
    //Tạo bảng bằng truy vấn
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
  }, version: 1);
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier()
      : super(const []); // muốn thêm thì phải tạo 1 trạng thái mới

  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map(
      (row) => Place(
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(
          latitude: row['lat'] as double,
          longitude: row['lng'] as double,
          address: row['address'] as String,
        ),
      ),
    ).toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    //lưu trữ thư mục ứng dụng trong 1 biến
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    //Lấy ra tên appDir trả về String để truyền vào image.copy();
    final fileName = path.basename(image.path);

    // lưu trữ hình ảnh
    final copiedImage = await image.copy('${appDir.path}/${fileName}');

    final newPlace =
        Place(title: title, image: copiedImage, location: location);
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'long': newPlace.location.longitude,
      'address': newPlace.location.address
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        // Trả về la 1 List<Place>
        (ref) => UserPlacesNotifier());
