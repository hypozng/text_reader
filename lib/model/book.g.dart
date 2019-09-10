// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    chapterNumber: json['chapter_number'] as int,
    paragraphNumber: json['paragraph_number'] as int,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'chapter_number': instance.chapterNumber,
      'paragraph_number': instance.paragraphNumber,
      'url': instance.url,
    };
