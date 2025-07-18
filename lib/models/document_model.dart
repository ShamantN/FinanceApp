import 'package:hive/hive.dart';

part 'document_model.g.dart';

@HiveType(typeId: 4)
class DocumentModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String path;

  DocumentModel({required this.title, required this.path});
}
