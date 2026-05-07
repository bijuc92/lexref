import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/cases/domain/case_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/string_utils.dart';
import 'court_badge.dart';

class CaseCard extends StatelessWidget {
  final CaseResult caseResult;
  final VoidCallback? onTap;

  const CaseCard({super.key, required this.caseResult, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CourtBadge(caseResult.court),
                  if (caseResult.year != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${caseResult.year}',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                caseResult.title,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (caseResult.citation != null && caseResult.citation!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  caseResult.citation!,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              if (caseResult.summary != null) ...[
                const SizedBox(height: 6),
                Text(
                  truncate(caseResult.summary!, 120),
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
