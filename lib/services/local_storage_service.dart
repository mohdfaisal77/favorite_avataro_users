import 'package:shared_preferences/shared_preferences.dart';
import '../models/users_model.dart';

class LocalStorageService {
  Future<void> saveFavorite(Data user) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_users') ?? [];
    favoriteIds.add(user.id.toString());
    await prefs.setStringList('favorite_users', favoriteIds);
  }

  Future<void> removeFavorite(Data user) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_users') ?? [];
    favoriteIds.remove(user.id.toString());
    await prefs.setStringList('favorite_users', favoriteIds);
  }

  Future<List<Data>> getFavoriteUsers(List<Data> allUsers) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_users') ?? [];
    return allUsers.where((user) => favoriteIds.contains(user.id.toString())).toList();
  }
}