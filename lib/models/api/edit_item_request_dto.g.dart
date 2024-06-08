// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_item_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditItemRequestDTO _$EditItemRequestDTOFromJson(Map<String, dynamic> json) =>
    EditItemRequestDTO(
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$EditItemRequestDTOToJson(EditItemRequestDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'url': instance.url,
    };
