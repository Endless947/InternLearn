import 'package:flutter/material.dart';

class ProfileDangerZoneCard extends StatelessWidget {
  const ProfileDangerZoneCard({
    super.key,
    required this.onDeleteAccount,
    this.isProcessing = false,
  });

  final VoidCallback onDeleteAccount;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.errorContainer.withValues(alpha: 0.22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.error.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danger zone',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.error,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Request permanent account deletion. You will be signed out immediately.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: isProcessing ? null : onDeleteAccount,
              icon: isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline),
              label: const Text('Delete account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.error,
                side: BorderSide(color: scheme.error.withValues(alpha: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
