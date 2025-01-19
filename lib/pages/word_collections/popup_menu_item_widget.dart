import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class MyPopupMenuItem extends StatelessWidget {
  const MyPopupMenuItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  final IconData icon;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      style: ButtonStyle(
          backgroundColor: ButtonStyles.createButtonStyleColor(
              ContainerStyles.bottomNavBarColor(context))),
      onPressed: onPressed,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(label),
          )
        ],
      ),
    );
  }
}
