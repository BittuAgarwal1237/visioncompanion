import 'package:flutter/material.dart';
import 'package:visioncompanion/core/l10n_x.dart';

class ErrorPane extends StatelessWidget {
  const ErrorPane({
    super.key,
    required this.message,
    this.onRetry,
    this.dark = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = dark ? Colors.white : scheme.onSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.errorContainer,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: scheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              liveRegion: true,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.retryButton),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
