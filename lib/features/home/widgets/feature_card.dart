import 'package:flutter/material.dart';
import 'package:visioncompanion/core/l10n_x.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
    required this.onStart,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accent;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      button: true,
      excludeSemantics: true,
      label: l10n.featureCardLabel(title, description),
      onTap: onStart,
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onStart,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: accent.withAlpha(36),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, size: 30, color: accent),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: scheme.onSurface.withAlpha(180),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: onStart,
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 50),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    label: Text(l10n.startButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
