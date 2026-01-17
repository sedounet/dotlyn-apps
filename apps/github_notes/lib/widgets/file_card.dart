import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:github_notes/providers/database_provider.dart';
import 'package:github_notes/data/database/app_database.dart' as db;
import '../l10n/app_localizations.dart';
import 'package:github_notes/widgets/card_menu.dart';

class FileCard extends ConsumerWidget {
  final db.ProjectFile file;
  final VoidCallback onTap;
  final ValueChanged<db.ProjectFile>? onDuplicate;

  const FileCard({
    super.key,
    required this.file,
    required this.onTap,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileContentAsync = ref.watch(fileContentProvider(file.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  // Status badge only in the header; date is displayed aligned to the right of the file path below
                  fileContentAsync.when(
                    data: (content) {
                      if (content == null) return const _SyncStatusBadge(syncStatus: 'unknown');
                      return _SyncStatusBadge(syncStatus: content.syncStatus);
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  if (onDuplicate != null) ...[
                    const SizedBox(width: 8),
                    CardMenu(
                      actions: [
                        CardMenuAction(
                          labelBuilder: (ctx) => AppLocalizations.of(ctx)!.duplicate,
                          onSelected: () => onDuplicate?.call(file),
                          icon: Icons.copy,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${file.owner}/${file.repo}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DotlynColors.secondary.withAlpha(179),
                    ),
              ),
              // Show file path and align the last-sync date to the right of the path
              fileContentAsync.when(
                data: (content) {
                  final formattedDate =
                      content == null ? '' : _formatRelativeDate(context, content.lastSyncAt);
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          file.path,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: DotlynColors.secondary.withAlpha(128),
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (formattedDate.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: DotlynColors.secondary.withAlpha(180),
                                fontSize:
                                    (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) * 1.1,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ],
                  );
                },
                loading: () => Text(
                  file.path,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DotlynColors.secondary.withAlpha(128),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                error: (_, __) => Text(
                  file.path,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DotlynColors.secondary.withAlpha(128),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              // Date moved up next to status badge for better alignment and readability
            ],
          ),
        ),
      ),
    );
  }

  static String _formatRelativeDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    return switch (diff) {
      Duration(inSeconds: < 60) => AppLocalizations.of(context)!.justNow,
      Duration(inMinutes: < 60) => '${diff.inMinutes}m ago',
      Duration(inHours: < 24) => '${diff.inHours}h ago',
      Duration(inDays: < 7) => '${diff.inDays}d ago',
      Duration(inDays: < 30) => '${(diff.inDays / 7).floor()}w ago',
      _ => '${date.day}/${date.month}/${date.year}',
    };
  }
}

class _SyncStatusBadge extends StatelessWidget {
  final String syncStatus;

  const _SyncStatusBadge({required this.syncStatus});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (syncStatus) {
      case 'synced':
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Synced';
        break;
      case 'pending':
        // Use Dotlyn primary color for pending/local state for brand consistency
        color = DotlynColors.primary;
        icon = Icons.folder;
        label = 'Local';
        break;
      case 'modified':
        color = DotlynColors.primary;
        icon = Icons.edit;
        label = 'Modified';
        break;
      case 'conflict':
        color = Colors.red;
        icon = Icons.warning;
        label = 'Conflict';
        break;
      case 'error':
        color = Colors.red;
        icon = Icons.error;
        label = 'Error';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // Slightly stronger background and border for better contrast per styleguide
        color: color.withAlpha((0.16 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((0.4 * 255).round())),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
