import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class CourtBadge extends StatelessWidget {
  final String courtName;

  const CourtBadge(this.courtName, {super.key});

  (Color, Color) get _colors {
    final upper = courtName.toUpperCase();
    if (upper.contains('SUPREME') || upper == 'SC') {
      return (AppColors.scBadge, AppColors.scBadgeBg);
    }
    if (upper.contains('HIGH') || upper == 'HC') {
      return (AppColors.hcBadge, AppColors.hcBadgeBg);
    }
    return (AppColors.tribunalBadge, AppColors.tribunalBadgeBg);
  }

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        courtName,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
