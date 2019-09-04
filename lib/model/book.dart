import 'package:json_annotation/json_annotation.dart';
import 'package:text_reader/model.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  /// ID
  @JsonKey(name: 'id')
  String id;

  /// 名称
  @JsonKey(name: 'name')
  String name;

  /// 描述
  @JsonKey(name: 'description')
  String description;

  /// 阅读到的章节号
  @JsonKey(name: 'chapter_number')
  int chapterNumber;

  /// 阅读到的段落号
  @JsonKey(name: 'paragraph_number')
  int paragraphNumber;

  /// 网络地址
  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'chapters')
  List<Chapter> chapters;

  Book({
    this.id,
    this.name,
    this.description,
    this.chapterNumber,
    this.paragraphNumber,
    this.url,
    this.chapters
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);

  @override
  String toString() {
    return "《$name》";
  }
}