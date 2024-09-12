import 'package:flutter/material.dart';
import '../models/users_model.dart';
import '../utils/app_color.dart';

class FavoriteListItem extends StatelessWidget {
  final Data user;
  final bool isFavorite;
  final Function(Data) onToggleFavorite;

  const FavoriteListItem({
    super.key,
    required this.user,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatar ?? ''),
        radius: screenWidth * 0.06, // Responsive radius
      ),
      title: Text(
        '${user.firstName} ${user.lastName}',
        style: Theme.of(context).textTheme.subtitle1?.copyWith(
          fontSize: screenWidth * 0.04, // Responsive text size
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.favorite,
          color: isFavorite ? AppColor.redColor : AppColor.greyColor,
          size: screenWidth * 0.07, // Responsive icon size
        ),
        onPressed: () => onToggleFavorite(user),
      ),
    );
  }
}
