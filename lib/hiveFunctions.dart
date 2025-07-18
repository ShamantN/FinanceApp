import 'package:hive_flutter/hive_flutter.dart';

class HiveFunctions {
  static Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  static Future<int> addItem<T>(Box<T> boxName, T item) async {
    return boxName.add(item);
  }

  static List<T> readData<T>(Box<T> boxName) {
    return boxName.values.toList();
  }

  static Future<void> updateData<T>(Box<T> boxName, int index, T item) async {
    return boxName.put(index, item);
  }

  static Future<void> delData<T>(Box<T> boxName, int index) {
    return boxName.deleteAt(index);
  }
}
