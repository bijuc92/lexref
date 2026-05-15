import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../auth/domain/auth_providers.dart';
import '../domain/selected_state_provider.dart';

const _centralActs = [
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

const _specialActs = [
  _ActInfo(
    id: 'ni_act',
    shortName: 'NI Act',
    fullName: 'Negotiable Instruments Act',
    year: '1881',
    color: AppColors.niActBadge,
    bgColor: AppColors.niActBadgeBg,
    icon: Icons.receipt_long,
    description: 'Cheques, promissory notes and bills of exchange',
  ),
  _ActInfo(
    id: 'tp_act',
    shortName: 'TP Act',
    fullName: 'Transfer of Property Act',
    year: '1882',
    color: AppColors.tpActBadge,
    bgColor: AppColors.tpActBadgeBg,
    icon: Icons.home_work,
    description: 'Sale, mortgage, lease, exchange and gift of property',
  ),
  _ActInfo(
    id: 'it_act',
    shortName: 'IT Act',
    fullName: 'Information Technology Act',
    year: '2000',
    color: AppColors.itActBadge,
    bgColor: AppColors.itActBadgeBg,
    icon: Icons.computer,
    description: 'Electronic records, cybercrime and digital signatures',
  ),
  _ActInfo(
    id: 'mv_act',
    shortName: 'MV Act',
    fullName: 'Motor Vehicles Act',
    year: '1988',
    color: AppColors.mvActBadge,
    bgColor: AppColors.mvActBadgeBg,
    icon: Icons.directions_car,
    description: 'Licensing, insurance and accident claims',
  ),
];

/// State-level acts keyed by jurisdiction key (see [kSupportedStates]).
const _stateActs = <String, List<_ActInfo>>{
  'maharashtra': [
    _ActInfo(
      id: 'mh_rent_act',
      shortName: 'MH Rent Act',
      fullName: 'Maharashtra Rent Control Act',
      year: '1999',
      color: AppColors.stateActBadge,
      bgColor: AppColors.stateActBadgeBg,
      icon: Icons.house,
      description: 'Standard rent, eviction and possession',
    ),
    _ActInfo(
      id: 'mh_coop_act',
      shortName: 'MH Co-op Act',
      fullName: 'Maharashtra Co-operative Societies Act',
      year: '1960',
      color: AppColors.stateActBadge,
      bgColor: AppColors.stateActBadgeBg,
      icon: Icons.groups,
      description: 'Co-operative societies and disputes',
    ),
  ],
  'delhi': [
    _ActInfo(
      id: 'dl_rent_act',
      shortName: 'DL Rent Act',
      fullName: 'Delhi Rent Control Act',
      year: '1958',
      color: AppColors.stateActBadge,
      bgColor: AppColors.stateActBadgeBg,
      icon: Icons.house,
      description: 'Standard rent and protection against eviction',
    ),
  ],
  'karnataka': [
    _ActInfo(
      id: 'ka_rent_act',
      shortName: 'KA Rent Act',
      fullName: 'Karnataka Rent Act',
      year: '1999',
      color: AppColors.stateActBadge,
      bgColor: AppColors.stateActBadgeBg,
      icon: Icons.house,
      description: 'Rent regulation and eviction of tenants',
    ),
    _ActInfo(
      id: 'ka_land_revenue_act',
      shortName: 'KA Land Revenue',
      fullName: 'Karnataka Land Revenue Act',
      year: '1964',
      color: AppColors.stateActBadge,
      bgColor: AppColors.stateActBadgeBg,
      icon: Icons.terrain,
      description: 'Land revenue and record of rights',
    ),
  ],
  'tamil_nadu': [
    _ActInfo(
      id: 'tn_rent_act',
      shortName: 'TN Rent Act',
      fullName: 'TN Buildings (Lease and Rent Control) Act',
      year: '1960',
      color: AppColors.stateActBadge,
      bgColor: AppColors.stateActBadgeBg,
      icon: Icons.house,
      description: 'Fair rent and eviction of tenants',
    ),
  ],
  'uttar_pradesh': [
    _ActInfo(
      id: 'up_buildings_act',
      shortName: 'UP Buildings Act',
      fullName: 'UP Urban Buildings (Rent and Eviction) Act',
      year: '1972',
      color: AppColors.stateActBadge,
      bgColor: AppColors.stateActBadgeBg,
      icon: Icons.house,
      description: 'Letting, rent and regulation of eviction',
    ),
  ],
};

class ActsListScreen extends ConsumerWidget {
  const ActsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final manualKey = ref.watch(selectedStateProvider);
    final profileState =
        ref.watch(profileProvider).valueOrNull?['state'] as String?;
    final effectiveKey =
        manualKey ?? jurisdictionKeyFromProfileState(profileState);
    final stateActs = effectiveKey == null
        ? const <_ActInfo>[]
        : (_stateActs[effectiveKey] ?? const <_ActInfo>[]);

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
                _SectionLabel(label: 'Central Acts', isDark: isDark),
                const SizedBox(height: 12),
                ..._centralActs.map((act) => _ActCard(act: act)),
                const SizedBox(height: 12),
                _SectionLabel(
                    label: 'Special & Commercial Acts', isDark: isDark),
                const SizedBox(height: 12),
                ..._specialActs.map((act) => _ActCard(act: act)),
                const SizedBox(height: 12),
                _SectionLabel(label: 'State Acts', isDark: isDark),
                const SizedBox(height: 8),
                _StatePicker(
                  selectedKey: effectiveKey,
                  isDark: isDark,
                  onChanged: (key) =>
                      ref.read(selectedStateProvider.notifier).select(key),
                ),
                const SizedBox(height: 12),
                if (effectiveKey == null)
                  _StateHint(
                    text:
                        'Select your state above to see applicable state-level acts.',
                    isDark: isDark,
                  )
                else if (stateActs.isEmpty)
                  _StateHint(
                    text:
                        'State acts for ${kSupportedStates[effectiveKey]} are coming soon.',
                    isDark: isDark,
                  )
                else
                  ...stateActs.map((act) => _ActCard(act: act)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatePicker extends StatelessWidget {
  final String? selectedKey;
  final bool isDark;
  final ValueChanged<String?> onChanged;

  const _StatePicker({
    required this.selectedKey,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 18, color: AppColors.stateActBadge),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedKey,
                hint: Text(
                  'Select state',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                items: kSupportedStates.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(
                          e.value,
                          style: GoogleFonts.dmSans(fontSize: 14),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StateHint extends StatelessWidget {
  final String text;
  final bool isDark;
  const _StateHint({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          color:
              isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        letterSpacing: 0.5,
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
                        Flexible(
                          child: Text(
                            act.shortName,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 18,
                              color: act.color,
                            ),
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
