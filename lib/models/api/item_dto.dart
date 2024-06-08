import 'package:json_annotation/json_annotation.dart';
part 'item_dto.g.dart';
@JsonSerializable()
class ItemDTO {
  final String? id;
  final String? name;
  final String? description;
  final String? url;
  const ItemDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
  });
  factory ItemDTO.fromJson(Map<String, dynamic> json) =>
      _$ItemDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ItemDTOToJson(this);
}