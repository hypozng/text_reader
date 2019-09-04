// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) {
  return Chapter(
    title: json['title'] as String,
    number: json['number'] as int,
    uri: json['uri'] as String,
  );
}

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'number': instance.number,
      'title': instance.title,
      'uri': instance.uri,
    };
