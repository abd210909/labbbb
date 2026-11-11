import 'package:flutter/material.dart';

/// Soft teaching note shown at the top of demo screens.
class LessonHint extends StatelessWidget {
  const LessonHint({
    super.key,
    required this.text,
    required this.onClose,
  });

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.primaryContainer.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.school_outlined, color: colors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: colors.onSurface,
                    height: 1.35,
                    fontSize: 13.5,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Dismiss',
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
