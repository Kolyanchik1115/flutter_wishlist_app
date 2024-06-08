import 'package:json_annotation/json_annotation.dart';
part 'edit_item_request_dto.g.dart';
@JsonSerializable()
class EditItemRequestDTO {
  final String name;
  final String description;
  final String url;
  const EditItemRequestDTO({
    required this.name,
    required this.description,
    required this.url,
  });
  factory EditItemRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$EditItemRequestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$EditItemRequestDTOToJson(this);
}