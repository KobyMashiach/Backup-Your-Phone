import 'package:flutter/material.dart';

class ApplicationAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconButton iconButton;
  const ApplicationAppbar({
    Key? key,
    required this.title,
    required this.iconButton,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [iconButton],
    );
  }
}
