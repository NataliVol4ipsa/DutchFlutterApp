import 'package:dutch_app/reusable_widgets/bottom_app_bar/my_bottom_app_bar_item_widget.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class MoreActionsBottomAppBar extends StatefulWidget {
  final List<Widget> actions;
  final double verticalOffset;
  final bool isEnabled;
  const MoreActionsBottomAppBar(
      {super.key,
      required this.actions,
      this.verticalOffset = 0,
      this.isEnabled = true});

  @override
  State<MoreActionsBottomAppBar> createState() =>
      _MoreActionsBottomAppBarState();
}

class _MoreActionsBottomAppBarState extends State<MoreActionsBottomAppBar> {
  MenuController? menuController;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: Offset(0, widget.verticalOffset),
      style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(
              ContainerStyles.bottomNavBarColor(context))),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        menuController = controller;
        return MyBottomAppBarItem(
            icon: Icons.grid_view_sharp,
            disabledIcon: Icons.grid_view_outlined,
            isEnabled: widget.isEnabled,
            label: 'More',
            onTap: (() => {
                  setState(() {
                    if (menuController == null) {
                      return;
                    }
                    if (menuController!.isOpen) {
                      menuController!.close();
                    } else {
                      menuController!.open();
                    }
                  })
                }));
      },
      menuChildren: List<Widget>.generate(
        widget.actions.length,
        (int index) => widget.actions[index],
      ),
    );
  }
}
