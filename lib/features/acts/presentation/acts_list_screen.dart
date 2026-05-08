import 'package:flutter/material.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/offline_banner.dart';

const _acts = [
  _ActInfo(
    id: 'bns',
    shortName: 'BNS',
    fullName: 'Bharatiya Nyaya Sanhita',
    year: '2023',
    color: AppColors.bnsBadge,
    bgColor: AppColors.bnsBadgeBg,
    icon: Icons.gavel,
    description: 'Replaces Indian Penal Code 1860',
  ),
  _ActInfo(
    id: 'bnss',
    shortName: 'BNSS',
    fullName: 'Bharatiya Nagrik Suraksha Sanhita',
    year: '2023',
    color: AppColors.bnssBadge,
    bgColor: AppColors.bnssBadgeBg,
    icon: Icons.account_balance,
    description: 'Replaces Code of Criminal Procedure 1973',
  ),
  _ActInfo(
    id: 'ipc',
    shortName: 'IPC',
    fullName: 'Indian Penal Code',
    year: '1860',
    color: AppColors.ipcBadge,
    bgColor: AppColors.ipcBadgeBg,
    icon: Icons.gavel,
    description: 'Defines criminal offences and punishments',
  ),
  _ActInfo(
    id: 'crpc',
    shortName: 'CrPC',
    fullName: 'Code of Criminal Procedure',
    year: '1973',
    color: AppColors.crpcBadge,
    bgColor: AppColors.crpcBadgeBg,
    icon: Icons.account_balance,
    description: 'Procedure for investigation and trial of offences',
  ),
  _ActInfo(
    id: 'cpc',
    shortName: 'CPC',
    fullName: 'Code of Civil Procedure',
    year: '1908',
    color: AppColors.cpcBadge,
    bgColor: AppColors.cpcBadgeBg,
    icon: Icons.balance,
    description: 'Procedure for civil suits, appeals and execution',
  ),
  _ActInfo(
    id: 'evidence',
    shortName: 'Evidence',
    fullName: 'Indian Evidence Act',
    year: '1872',
    color: AppColors.evidenceBadge,
    bgColor: AppColors.evidenceBadgeBg,
    icon: Icons.find_in_page,
    description: 'Rules relating to admissibility of evidence',
  ),
];

class ActsListScreen extends StatelessWidget {
  const ActsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Law Library'),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Central Acts',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                ..._acts.map((act) => _ActCard(act: act)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActCard extends StatelessWidget {
  final _ActInfo act;
  const _ActCard({required this.act});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.pushSectionsForAct(act.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: act.bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(act.icon, color: act.color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          act.shortName,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 18,
                            color: act.color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: act.bgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            act.year,
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: act.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      act.fullName,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      act.description,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActInfo {
  final String id;
  final String shortName;
  final String fullName;
  final String year;
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String description;

  const _ActInfo({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.year,
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.description,
  });
}
