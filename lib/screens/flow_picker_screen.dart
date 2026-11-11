import 'package:flutter/material.dart';

import 'local_posts_screen.dart';
import 'posts_screen.dart';

/// Home screen so students can try both approaches side by side.
class FlowPickerScreen extends StatelessWidget {
  const FlowPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posts App',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Same feature, two state styles. Open both and compare.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              _FlowCard(
                title: 'With Provider',
                subtitle:
                    'PostProvider holds the list. Add updates it; the list '
                    'rebuilds automatically.',
                icon: Icons.hub_outlined,
                filled: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PostsScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _FlowCard(
                title: 'Without Provider',
                subtitle:
                    'List lives in setState. Add works, but refresh reloads '
                    'from the API and your new post disappears.',
                icon: Icons.phone_android_outlined,
                filled: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LocalPostsScreen()),
                  );
                },
              ),
              const Spacer(),
              Text(
                'Uses JSONPlaceholder · Firebase init is off for this APK',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowCard extends StatelessWidget {
  const _FlowCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: filled ? colors.primary : Colors.white,
      elevation: filled ? 0 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: filled
            ? BorderSide.none
            : BorderSide(color: colors.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
                color: filled ? colors.onPrimary : colors.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: filled ? colors.onPrimary : colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        height: 1.4,
                        color: filled
                            ? colors.onPrimary.withValues(alpha: 0.9)
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: filled
                    ? colors.onPrimary.withValues(alpha: 0.85)
                    : colors.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
