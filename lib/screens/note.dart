import 'package:hive/hive.dart';
part 'note.g.dart';
// note.dart

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;
  @HiveField(1)
  String content;


  Note(
    this.title,
    this.content,
  );
}
