// import 'package:flutter/material.dart';
// import '../models/users_model.dart';
// import '../services/api_services.dart';
// import '../services/local_storage_service.dart';
// import 'favorite_list_item.dart';
// import '../utils/app_color.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final ApiService _apiService = ApiService();
//   final LocalStorageService _localStorageService = LocalStorageService();
//   late Future<UsersModel> _usersFuture;
//   late Future<List<Data>> _favoriteUsersFuture;
//   List<Data> _users = [];
//   Set<int> _favoriteUserIds = {}; // Cache favorite user IDs
//
//   @override
//   void initState() {
//     super.initState();
//     _usersFuture = _apiService.fetchUsers().then((usersModel) {
//       _users = usersModel.data ?? [];
//       _initializeFavoriteStatus();
//       return usersModel;
//     });
//   }
//
//   Future<void> _initializeFavoriteStatus() async {
//     final favoriteUsers = await _localStorageService.getFavoriteUsers(_users);
//     setState(() {
//       _favoriteUserIds = {for (var user in favoriteUsers) user.id?.toInt() ?? 0};
//     });
//   }
//
//   void _toggleFavorite(Data user) async {
//     final userId = user.id?.toInt() ?? 0;
//     final isFavorite = _favoriteUserIds.contains(userId);
//     if (isFavorite) {
//       await _localStorageService.removeFavorite(user);
//       setState(() {
//         _favoriteUserIds.remove(userId);
//       });
//     } else {
//       await _localStorageService.saveFavorite(user);
//       setState(() {
//         _favoriteUserIds.add(userId);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text('Users'),
//           bottom: TabBar(
//             labelColor: AppColor.blackColor,
//             tabs: [
//               Tab(text: 'All Users'),
//               Tab(text: 'Favorites'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             FutureBuilder<UsersModel>(
//               future: _usersFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.data!.isEmpty ?? true) {
//                   return const Center(child: Text('No users found.'));
//                 }
//                 final users = snapshot.data?.data ?? [];
//                 return ListView.builder(
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenWidth * 0.01, // Responsive vertical padding
//                     horizontal: screenWidth * 0.01, // Responsive horizontal padding
//                   ),
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     return FavoriteListItem(
//                       user: user,
//                       isFavorite: _favoriteUserIds.contains(user.id?.toInt() ?? 0),
//                       onToggleFavorite: _toggleFavorite,
//                     );
//                   },
//                 );
//               },
//             ),
//             FutureBuilder<List<Data>>(
//               future: _localStorageService.getFavoriteUsers(_users),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty ?? true) {
//                   return const Center(child: Text('No favorites yet.'));
//                 }
//                 final favoriteUsers = snapshot.data ?? [];
//                 return ListView.builder(
//                   padding: EdgeInsets.symmetric(
//                     vertical: screenWidth * 0.02, // Responsive vertical padding
//                     horizontal: screenWidth * 0.02, // Responsive horizontal padding
//                   ),
//                   itemCount: favoriteUsers.length,
//                   itemBuilder: (context, index) {
//                     final user = favoriteUsers[index];
//                     return FavoriteListItem(
//                       user: user,
//                       isFavorite: true, // All items in this tab are favorites
//                       onToggleFavorite: _toggleFavorite,
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//With State Management.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/users_model.dart';
import '../provider/user_provider.dart';
import 'favorite_list_item.dart';
import '../utils/app_color.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Users'),
          bottom: TabBar(
            labelColor: AppColor.blackColor,
            tabs: [
              Tab(text: 'All Users'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<UserProvider>(
              builder: (context, provider, child) {
                if (provider.users.isEmpty) {
                  provider.fetchUsers();
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: provider.users.length,
                  itemBuilder: (context, index) {
                    final user = provider.users[index];
                    return FavoriteListItem(
                      user: user,
                      isFavorite: provider.favoriteUserIds.contains(user.id?.toInt() ?? 0),
                      onToggleFavorite: provider.toggleFavorite, // Use the provider directly here
                    );
                  },
                );
              },
            ),
            Consumer<UserProvider>(
              builder: (context, provider, child) {
                final favoriteUsers = provider.users.where(
                      (user) => provider.favoriteUserIds.contains(user.id?.toInt() ?? 0),
                ).toList();

                if (favoriteUsers.isEmpty) {
                  return Center(child: Text('No favorites yet.'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: favoriteUsers.length,
                  itemBuilder: (context, index) {
                    final user = favoriteUsers[index];
                    return FavoriteListItem(
                      user: user,
                      isFavorite: true,
                      onToggleFavorite: provider.toggleFavorite, // Use the provider directly here
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


