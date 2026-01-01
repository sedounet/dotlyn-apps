import 'package:flutter/material.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:github_notes/data/database/app_database.dart' as db;
import 'package:intl/intl.dart';

/// Reusable widget to display a project file card with sync status
class FileCard extends StatelessWidget {
  final db.ProjectFile file;
  final db.FileContent? content;
  final VoidCallback onTap;

  const FileCard({
    super.key,
    required this.file,
    this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final syncStatus = content?.syncStatus ?? 'unknown';
    final lastSync = content?.lastSyncAt;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      file.nickname,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _buildStatusBadge(context, syncStatus),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(153),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${file.owner}/${file.repo}/${file.path}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(153),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (lastSync != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.sync,
                      size: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(153),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Last sync: ${DateFormat('MMM dd, HH:mm').format(lastSync)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(153),
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color badgeColor;
    IconData icon;
    String label;

    switch (status) {
      case 'synced':
        badgeColor = Colors.green;
        icon = Icons.check_circle;
        label = 'Synced';
        break;
      case 'modified':
        badgeColor = DotlynColors.primary;
        icon = Icons.edit;
        label = 'Modified';
        break;
      case 'conflict':
        badgeColor = Colors.red;
        icon = Icons.warning;
        label = 'Conflict';
        break;
      default:
        badgeColor = Colors.grey;
        icon = Icons.help_outline;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withAlpha(77), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
