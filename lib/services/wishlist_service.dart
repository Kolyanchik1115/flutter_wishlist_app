import 'dart:convert';
import 'package:flutter_wishlist_app/services/authorization_service.dart';
import 'package:http/http.dart' as http;
import '../models/api/add_item_request_dto.dart';
import '../models/api/edit_item_request_dto.dart';
import '../models/api/item_dto.dart';
import '../models/item.dart';
import '../models/wishlist.dart';

class WishlistService {
  static const String itemsApiUrl = 'https://chemical-fish-sternum.glitch.me/api/wishlist/items';
  final AuthorizationService authorizationService;

  WishlistService(this.authorizationService);

  Future<Wishlist> getWishList() async {
    final String accessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Imc4WlNHMlRuOHJ3VGd0NTBIU1lGQSJ9.eyJpc3MiOiJodHRwczovL2Rldi0zOGh5bHRhYmQzZHh0MXFqLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRkBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly93aXNobGlzdC5leGFtcGxlLmNvbSIsImlhdCI6MTcxNzg3Mzk4NCwiZXhwIjoxNzE3OTYwMzg0LCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRiJ9.MCP9clqy8CTY3_tty_O3EeODTuQIC1bWH7wD6tlF81udVhkvoYZvsrHn1IPdVa0Fw9kMd3B9n_XriMGg3xT7_oZ1vjym7rL1qVPmMen2nz-qDJy3IxHHukcQ2RjFPiBcfF0g13X_GNMUOL8dfPHKy-EuZlfu1Gzp1YMgFUHwKhTlh4IxA2qN2IYjG66zCsD1EKkdg6I1ED7xbZD8ZV4NHmclMJsmqLbQacdzlVrDq_BpP9yq2VEFgpv6sAe6MIgnTPLuJ4gIQg8p6JDVlG-h4BfhLMSgu-WGEA3mt0_LTBDqDlgvWuJaShWGx967Q8jIZ_5bhq0ombgemTm3088HOg';
    final http.Response response = await http.get(
      Uri.parse(itemsApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> decodedJsonList = jsonDecode(response.body) as List<dynamic>;
      final List<ItemDTO> items =
          decodedJsonList.map((json) => ItemDTO.fromJson(json as Map<String, dynamic>)).toList();
      return Wishlist(items
          .map((ItemDTO itemDTO) => Item(
                id: itemDTO.id,
                name: itemDTO.name ?? 'anonymous',
                description: itemDTO.description ?? 'no description',
                url: itemDTO.url ?? 'https://www.google.com',
              ))
          .toList());
    }
    throw Exception('Could not get the wishlist');
  }

  Future<String> addItem(Item item) async {
    final AddItemRequestDTO addItemRequest =
        AddItemRequestDTO(name: item.name, description: item.description, url: item.url);
    final String accessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Imc4WlNHMlRuOHJ3VGd0NTBIU1lGQSJ9.eyJpc3MiOiJodHRwczovL2Rldi0zOGh5bHRhYmQzZHh0MXFqLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRkBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly93aXNobGlzdC5leGFtcGxlLmNvbSIsImlhdCI6MTcxNzg3Mzk4NCwiZXhwIjoxNzE3OTYwMzg0LCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRiJ9.MCP9clqy8CTY3_tty_O3EeODTuQIC1bWH7wD6tlF81udVhkvoYZvsrHn1IPdVa0Fw9kMd3B9n_XriMGg3xT7_oZ1vjym7rL1qVPmMen2nz-qDJy3IxHHukcQ2RjFPiBcfF0g13X_GNMUOL8dfPHKy-EuZlfu1Gzp1YMgFUHwKhTlh4IxA2qN2IYjG66zCsD1EKkdg6I1ED7xbZD8ZV4NHmclMJsmqLbQacdzlVrDq_BpP9yq2VEFgpv6sAe6MIgnTPLuJ4gIQg8p6JDVlG-h4BfhLMSgu-WGEA3mt0_LTBDqDlgvWuJaShWGx967Q8jIZ_5bhq0ombgemTm3088HOg';
    final http.Response response = await http.post(Uri.parse(itemsApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(addItemRequest.toJson()));
    if (response.statusCode == 201) {
      return response.body;
    }
    throw Exception('Could not add item');
  }

  Future<String> editItem(Item item) async {
    final EditItemRequestDTO editItemRequest =
        EditItemRequestDTO(name: item.name, description: item.description, url: item.url);
    final String accessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Imc4WlNHMlRuOHJ3VGd0NTBIU1lGQSJ9.eyJpc3MiOiJodHRwczovL2Rldi0zOGh5bHRhYmQzZHh0MXFqLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRkBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly93aXNobGlzdC5leGFtcGxlLmNvbSIsImlhdCI6MTcxNzg3Mzk4NCwiZXhwIjoxNzE3OTYwMzg0LCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRiJ9.MCP9clqy8CTY3_tty_O3EeODTuQIC1bWH7wD6tlF81udVhkvoYZvsrHn1IPdVa0Fw9kMd3B9n_XriMGg3xT7_oZ1vjym7rL1qVPmMen2nz-qDJy3IxHHukcQ2RjFPiBcfF0g13X_GNMUOL8dfPHKy-EuZlfu1Gzp1YMgFUHwKhTlh4IxA2qN2IYjG66zCsD1EKkdg6I1ED7xbZD8ZV4NHmclMJsmqLbQacdzlVrDq_BpP9yq2VEFgpv6sAe6MIgnTPLuJ4gIQg8p6JDVlG-h4BfhLMSgu-WGEA3mt0_LTBDqDlgvWuJaShWGx967Q8jIZ_5bhq0ombgemTm3088HOg';
    final http.Response response = await http.put(Uri.parse('$itemsApiUrl/${item.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(editItemRequest.toJson()));
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Could not add item');
  }

  Future<void> deleteItem(Item item) async {
    final String accessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Imc4WlNHMlRuOHJ3VGd0NTBIU1lGQSJ9.eyJpc3MiOiJodHRwczovL2Rldi0zOGh5bHRhYmQzZHh0MXFqLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRkBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly93aXNobGlzdC5leGFtcGxlLmNvbSIsImlhdCI6MTcxNzg3Mzk4NCwiZXhwIjoxNzE3OTYwMzg0LCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRiJ9.MCP9clqy8CTY3_tty_O3EeODTuQIC1bWH7wD6tlF81udVhkvoYZvsrHn1IPdVa0Fw9kMd3B9n_XriMGg3xT7_oZ1vjym7rL1qVPmMen2nz-qDJy3IxHHukcQ2RjFPiBcfF0g13X_GNMUOL8dfPHKy-EuZlfu1Gzp1YMgFUHwKhTlh4IxA2qN2IYjG66zCsD1EKkdg6I1ED7xbZD8ZV4NHmclMJsmqLbQacdzlVrDq_BpP9yq2VEFgpv6sAe6MIgnTPLuJ4gIQg8p6JDVlG-h4BfhLMSgu-WGEA3mt0_LTBDqDlgvWuJaShWGx967Q8jIZ_5bhq0ombgemTm3088HOg';
    final http.Response response = await http.delete(
      Uri.parse('$itemsApiUrl/${item.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Could not delete item');
    }
  }
}
