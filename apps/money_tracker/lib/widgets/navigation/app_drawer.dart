import 'package:flutter/material.dart';

/// Item du drawer avec icône et navigation
class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool showDivider;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title),
          onTap: onTap,
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}

/// Drawer de navigation de l'application
class AppDrawer extends StatelessWidget {
  final List<DrawerMenuItemData> items;
  final String? headerTitle;
  final Widget? header;

  const AppDrawer({
    super.key,
    required this.items,
    this.headerTitle,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (header != null)
            header!
          else
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Text(
                headerTitle ?? 'Menu',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
          ...items.map(
            (item) => DrawerMenuItem(
              icon: item.icon,
              title: item.title,
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
                item.onTap?.call();
              },
              iconColor: item.iconColor,
              showDivider: item.showDivider,
            ),
          ),
        ],
      ),
    );
  }
}

/// Données pour un item du drawer
class DrawerMenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool showDivider;

  const DrawerMenuItemData({
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
    this.showDivider = false,
  });
}
