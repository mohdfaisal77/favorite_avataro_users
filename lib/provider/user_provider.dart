// With State Management.

import 'package:flutter/material.dart';
import '../models/users_model.dart';
import '../services/api_services.dart';
import '../services/local_storage_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Data> _users = [];
  Set<int> _favoriteUserIds = {}; // Cache favorite user IDs

  List<Data> get users => _users;
  Set<int> get favoriteUserIds => _favoriteUserIds;

  Future<void> fetchUsers() async {
    try {
      final usersModel = await _apiService.fetchUsers();
      _users = usersModel.data ?? [];
      await _initializeFavoriteStatus();
      notifyListeners();
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> _initializeFavoriteStatus() async {
    final favoriteUsers = await _localStorageService.getFavoriteUsers(_users);
    _favoriteUserIds = {for (var user in favoriteUsers) user.id?.toInt() ?? 0};
  }

  Future<void> toggleFavorite(Data user) async {
    final userId = user.id?.toInt() ?? 0;
    final isFavorite = _favoriteUserIds.contains(userId);
    if (isFavorite) {
      await _localStorageService.removeFavorite(user);
      _favoriteUserIds.remove(userId);
    } else {
      await _localStorageService.saveFavorite(user);
      _favoriteUserIds.add(userId);
    }
    notifyListeners();
  }
}
