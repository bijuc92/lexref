import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/subscription_providers.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  final String reason;
  const PaywallScreen({super.key, required this.reason});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  Offerings? _offerings;
  Package? _selectedPackage;
  bool _loading = true;
  bool _purchasing = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) {
        setState(() {
          _offerings = offerings;
          _selectedPackage = offerings.current?.availablePackages.firstOrNull;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _purchase() async {
    if (_selectedPackage == null) return;
    setState(() => _purchasing = true);
    try {
      await Purchases.purchasePackage(_selectedPackage!);
      ref.invalidate(customerInfoProvider);
      if (mounted) Navigator.of(context).pop(true);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Purchase failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _purchasing = true);
    try {
      await Purchases.restorePurchases();
      ref.invalidate(customerInfoProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchases restored successfully')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  String get _title => switch (widget.reason) {
        'ai' => "Daily AI limit reached",
        'cases' => "Daily case search limit reached",
        'sync' => 'Cloud sync requires Pro',
        _ => 'Upgrade to LexRef Pro',
      };

  String get _subtitle => switch (widget.reason) {
        'ai' =>
          'Free users get $_freeAiDisplay AI queries per day. Upgrade for unlimited legal AI assistance.',
        'cases' =>
          'Free users get $_freeCaseDisplay case searches per day. Upgrade for unlimited IndianKanoon access.',
        'sync' =>
          'Keep your bookmarks and notes backed up and synced across all your devices.',
        _ => 'Unlock the full power of LexRef for unlimited research.',
      };

  String get _freeAiDisplay => '5';
  String get _freeCaseDisplay => '3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LexRef Pro')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildFeatureList(),
                  const SizedBox(height: 24),
                  _buildPlanSelector(),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _purchasing ? null : _restore,
                    child: const Text('Restore Purchases'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Subscriptions auto-renew unless cancelled at least 24 hours before renewal.',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.workspace_premium, color: AppColors.primary, size: 48),
          const SizedBox(height: 12),
          Text(
            _title,
            style: GoogleFonts.libreBaskerville(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _subtitle,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    const features = [
      ('Unlimited AI Chat', 'Ask unlimited legal questions powered by Groq AI'),
      ('Unlimited Case Law Search', 'Search millions of Indian court judgments on IndianKanoon'),
      ('Cloud Sync', 'Sync bookmarks and notes across all your devices'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHAT YOU GET WITH PRO',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        ...features.map(
          (f) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.$1,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        f.$2,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanSelector() {
    final packages = _offerings?.current?.availablePackages ?? [];

    if (packages.isEmpty) {
      return Text(
        'Subscription plans are not available right now. Please check back later.',
        style: GoogleFonts.dmSans(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'CHOOSE YOUR PLAN',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        ...packages.map((pkg) {
          final isSelected = _selectedPackage?.identifier == pkg.identifier;
          final isAnnual = pkg.packageType == PackageType.annual;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPackage = pkg),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.05)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAnnual ? 'Yearly' : 'Monthly',
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isAnnual)
                          Text(
                            'Best value — save 37%',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      pkg.storeProduct.priceString,
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: (_purchasing || _selectedPackage == null) ? null : _purchase,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
          child: _purchasing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Subscribe to Pro'),
        ),
      ],
    );
  }
}
