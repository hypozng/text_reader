// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) {
  return Chapter(
    id: json['id'] as String,
    number: json['number'] as int,
    title: json['title'] as String,
    uri: json['uri'] as String,
    bookId: json['book_id'] as String,
  );
}

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'title': instance.title,
      'uri': instance.uri,
      'book_id': instance.bookId,
    };
