import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Home empty state: a tinted icon badge, optional title/message, and (by
/// default) a few dashed skeleton placeholder rows — as in the design's
/// "0 of 0 completed" home.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon = Icons.event_note_rounded,
    this.title,
    this.message,
    this.showPlaceholders = true,
  });

  final IconData icon;
  final String? title;
  final String? message;
  final bool showPlaceholders;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return Column(
      children: <Widget>[
        Container(
          width: 88,
          height: 88,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.avatarBackground,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: c.onPrimary, size: 28),
          ),
        ),
        if (title != null) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          Text(title!, style: context.text.titleMedium),
        ],
        if (message != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xs),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(color: c.textSecondary),
          ),
        ],
        if (showPlaceholders) ...<Widget>[
          const SizedBox(height: AppSpacing.xl),
          for (int i = 0; i < 3; i++) ...<Widget>[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            const _PlaceholderRow(),
          ],
        ],
      ],
    );
  }
}

/// A dashed-outline skeleton row hinting where tasks will appear.
class _PlaceholderRow extends StatelessWidget {
  const _PlaceholderRow();

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    Widget bar(double width) => Container(
      height: 10,
      width: width,
      decoration: BoxDecoration(
        color: c.field,
        borderRadius: BorderRadius.circular(4),
      ),
    );

    return CustomPaint(
      painter: _DashedBorderPainter(color: c.border, radius: AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: c.field, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  bar(double.infinity),
                  const SizedBox(height: 8),
                  bar(120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints a dashed rounded-rectangle border.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    const double dash = 6;
    const double gap = 4;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
