
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/users_model.dart';

class ApiService {
  final String _url = 'https://reqres.in/api/users?page=2';

  Future<UsersModel> fetchUsers() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UsersModel.fromJson(data);
    } else {
      throw Exception('Failed to load users');
    }
  }
}