import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class ActBadge extends StatelessWidget {
  final String actName;

  const ActBadge(this.actName, {super.key});

  (Color, Color) get _colors {
    switch (actName.toUpperCase()) {
      case 'IPC':
        return (AppColors.ipcBadge, AppColors.ipcBadgeBg);
      case 'CRPC':
      case 'CR.P.C':
        return (AppColors.crpcBadge, AppColors.crpcBadgeBg);
      case 'CPC':
        return (AppColors.cpcBadge, AppColors.cpcBadgeBg);
      case 'EVIDENCE':
      case 'EVIDENCE ACT':
        return (AppColors.evidenceBadge, AppColors.evidenceBadgeBg);
      default:
        return (AppColors.primary, AppColors.primary.withOpacity(0.1));
    }
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
        actName.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
