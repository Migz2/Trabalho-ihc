import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/navigation/app_routes.dart';
import '../providers/onboarding_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingProvider.notifier).markCompleted();
    if (mounted) {
      context.go(AppRoutes.focus);
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimaryColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Page View
            PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _OnboardingScreen1(
                  bgColor: bgColor,
                  textPrimary: textPrimaryColor,
                  textSecondary: textSecondaryColor,
                  primaryColor: primaryColor,
                ),
                _OnboardingScreen2(
                  bgColor: bgColor,
                  textPrimary: textPrimaryColor,
                  textSecondary: textSecondaryColor,
                  primaryColor: primaryColor,
                ),
                _OnboardingScreen3(
                  bgColor: bgColor,
                  textPrimary: textPrimaryColor,
                  textSecondary: textSecondaryColor,
                  primaryColor: primaryColor,
                  accentColor: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                ),
              ],
            ),

            // Skip button (top right, only pages 0 and 1)
            if (_currentPage < 2)
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Pular',
                    style: TextStyle(
                      color: textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

            // Page indicator dots and next button
            Positioned(
              bottom: AppSpacing.lg,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: index == _currentPage ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? primaryColor
                              : dividerColor,
                          borderRadius:
                              BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Next button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: _nextPage,
                        child: Text(
                          _currentPage == 2 ? 'Começar' : 'Próximo',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingScreen1 extends StatelessWidget {
  final Color bgColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryColor;

  const _OnboardingScreen1({
    required this.bgColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Title
            Text(
              'Foco que transforma',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: textPrimary,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Subtitle
            Text(
              '25 minutos de atenção plena valem mais do que horas dispersas. A técnica Pomodoro vai mudar sua relação com o estudo.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingScreen2 extends StatelessWidget {
  final Color bgColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryColor;

  const _OnboardingScreen2({
    required this.bgColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon (coin)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '🍯',
                style: TextStyle(fontSize: 60),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Title
            Text(
              'Cada foco tem recompensa',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: textPrimary,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Subtitle
            Text(
              'Complete ciclos e ganhe moedas. Quanto mais consistente você for, mais rápido seu progresso cresce.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingScreen3 extends StatelessWidget {
  final Color bgColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryColor;
  final Color accentColor;

  const _OnboardingScreen3({
    required this.bgColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pet placeholder
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFE8C99A), // light gold
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Title
            Text(
              'Conheça a Mel',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: textPrimary,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Subtitle
            Text(
              'Seu companheiro de estudos. Cuide dela completando sessões de foco e ela vai crescer com você.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
