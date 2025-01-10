import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class WordListNavBar extends StatelessWidget {
  const WordListNavBar({
    super.key,
    required this.context,
    required this.items,
    required this.onTap,
  });

  final BuildContext context;
  final List<BottomNavigationBarItem> items;
  final Function(int p1) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: ContainerStyles.bottomNavBarColor(context),
        selectedItemColor: ContainerStyles.bottomNavBarTextColor(context),
        selectedLabelStyle:
            TextStyle(color: ContainerStyles.bottomNavBarTextColor(context)),
        unselectedItemColor: ContainerStyles.bottomNavBarTextColor(context),
        unselectedLabelStyle:
            TextStyle(color: ContainerStyles.bottomNavBarTextColor(context)),
        type: BottomNavigationBarType.fixed,
        items: items,
        onTap: onTap);
  }
}
