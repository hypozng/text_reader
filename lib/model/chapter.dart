import 'package:json_annotation/json_annotation.dart';

part 'chapter.g.dart';

@JsonSerializable()
class Chapter {
  @JsonKey(name: 'id')
  String id;

  /// 章节号
  @JsonKey(name: 'number')
  int number;

  /// 标题
  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'uri')
  String uri;
  
  /// 图书ID
  @JsonKey(name: 'book_id')
  String bookId;

  /// 段落
  @JsonKey(ignore: true)
  List<String> _paragraphs = [];

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterToJson(this);

  Chapter({
    this.id,
    this.number,
    this.title,
    this.uri,
    this.bookId,
    List<String> paragraphs
  }) {
    this.paragraphs = paragraphs;
  }

  @JsonKey(ignore: true)
  List<String> get paragraphs => _paragraphs;

  @JsonKey(ignore: true)
  set paragraphs(List<String> paragraphs) {
    _paragraphs.clear();
    if (paragraphs == null || paragraphs.isEmpty) {
      return;
    }
    var list = paragraphs.map((p) => p?.trim() ?? "").toList();
    list.removeWhere((p) => p?.isNotEmpty != true);
    _paragraphs.addAll(list);
  }


}