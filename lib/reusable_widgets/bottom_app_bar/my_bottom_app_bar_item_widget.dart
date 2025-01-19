import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class MyBottomAppBarItem extends StatelessWidget {
  final IconData icon;
  final IconData? disabledIcon;
  final String label;
  final bool isEnabled;
  final void Function()? onTap;
  const MyBottomAppBarItem(
      {super.key,
      required this.icon,
      required this.label,
      this.disabledIcon,
      this.isEnabled = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onTap: isEnabled ? onTap : null,
        child: Column(
          children: [
            if (isEnabled || disabledIcon == null)
              Icon(icon, color: ContainerStyles.bottomNavBarTextColor(context)),
            if (!isEnabled && disabledIcon != null)
              Icon(disabledIcon,
                  color:
                      ContainerStyles.bottomNavBarDisabledTextColor(context)),
            Text(
              label,
              style: TextStyle(
                  color: isEnabled
                      ? ContainerStyles.bottomNavBarTextColor(context)
                      : ContainerStyles.bottomNavBarDisabledTextColor(context)),
            ),
          ],
        ),
      ),
    );
  }
}
