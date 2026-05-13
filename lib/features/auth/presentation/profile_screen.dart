import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/router/typed_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/error/result.dart';
import '../../../core/theme/app_colors.dart';
import '../../subscription/domain/subscription_providers.dart';
import '../domain/auth_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isDeleting = false;
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = '${info.version}+${info.buildNumber}');
    });
  }

  String _proExpiryLabel(customerInfo) {
    final expiry =
        customerInfo?.entitlements.active['pro']?.expirationDate as DateTime?;
    if (expiry == null) return 'Active';
    final d = expiry;
    return 'Renews ${d.day} ${_monthName(d.month)} ${d.year}';
  }

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];

  Future<void> _handleSignOut(BuildContext context) async {
    final authRepo = ref.read(authRepositoryProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await authRepo.signOut();
      if (context.mounted) context.goLogin();
    }
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account, bookmarks, notes, and all associated data. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    setState(() => _isDeleting = true);

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.deleteAccount();

    if (!context.mounted) return;

    setState(() => _isDeleting = false);

    switch (result) {
      case Ok():
        context.goLogin();
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    final isSubscribed = ref.watch(isSubscribedProvider);
    final customerInfo = ref.watch(customerInfoProvider).valueOrNull;

    final name = profile?['full_name'] as String? ?? '—';
    final email = profile?['email'] as String? ?? '—';
    final barNo = profile?['bar_enrollment_no'] as String? ?? '—';
    final state = profile?['state'] as String? ?? '—';
    final court = profile?['court'] as String? ?? '—';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'A',
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 32,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  name,
                  style: GoogleFonts.libreBaskerville(fontSize: 22),
                ),
              ),
              Center(
                child: Text(
                  email,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _SectionHeader('Professional Details'),
              _InfoRow('Bar Enrollment No.', barNo),
              _InfoRow('State', state),
              _InfoRow('Court', court),
              const SizedBox(height: 24),
              _SectionHeader('Subscription'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isSubscribed
                      ? Icons.workspace_premium
                      : Icons.workspace_premium_outlined,
                  color: isSubscribed ? AppColors.primary : AppColors.textSecondary,
                ),
                title: Text(
                  isSubscribed ? 'LexRef Pro' : 'Free Plan',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSubscribed ? AppColors.primary : null,
                  ),
                ),
                subtitle: Text(
                  isSubscribed
                      ? _proExpiryLabel(customerInfo)
                      : '5 AI queries · 3 case searches per day',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: isSubscribed
                    ? null
                    : TextButton(
                        onPressed: () => context.pushPaywall(reason: 'upgrade'),
                        child: const Text('Upgrade'),
                      ),
              ),
              const SizedBox(height: 24),
              _SectionHeader('Preferences'),
              SwitchListTile(
                title:
                    Text('Dark Mode', style: GoogleFonts.dmSans(fontSize: 14)),
                value: themeMode == ThemeMode.dark,
                onChanged: (val) {
                  ref.read(themeModeProvider.notifier).state =
                      val ? ThemeMode.dark : ThemeMode.light;
                },
              ),
              const SizedBox(height: 24),
              _SectionHeader('Account'),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: Text(
                  'Sign Out',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.error,
                  ),
                ),
                onTap: _isDeleting ? null : () => _handleSignOut(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_forever_outlined,
                  color: AppColors.error,
                ),
                title: Text(
                  'Delete Account',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.error,
                  ),
                ),
                subtitle: Text(
                  'Permanently removes your account and all data',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap:
                    _isDeleting ? null : () => _handleDeleteAccount(context),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  _version.isEmpty ? 'LexRef' : 'LexRef v$_version',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (_isDeleting)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
