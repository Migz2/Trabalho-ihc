import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/animation_constants.dart';
import '../../../../shared/navigation/app_routes.dart';
import '../../../pet/presentation/providers/pet_provider.dart';
import '../providers/onboarding_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;
  late TextEditingController _petNameController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _petNameController = TextEditingController(text: 'Mel');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _petNameController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final petName = _petNameController.text.trim();
    await ref.read(petProvider.future);
    await ref
        .read(petProvider.notifier)
        .renamePet(petName.isNotEmpty ? petName : 'Mel');
    await ref.read(onboardingProvider.notifier).markCompleted();
    if (mounted) {
      context.go(AppRoutes.focus);
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: AnimationDurations.normal,
        curve: AnimationCurves.standard,
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
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;

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
                  accentColor: accentColor,
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
                  accentColor: accentColor,
                  nameController: _petNameController,
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
                      (index) => AnimatedContainer(
                        duration: AnimationDurations.fast,
                        curve: AnimationCurves.spring,
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

                  // Next / Começar button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    child: _currentPage == 2
                        ? _StartButton(
                            onPressed: _nextPage,
                            primaryColor: primaryColor,
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: _nextPage,
                              child: const Text(
                                'Próximo',
                                style: TextStyle(fontSize: 16),
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

/// Special "Começar 🍯" CTA used on the final onboarding screen.
class _StartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color primaryColor;

  const _StartButton({required this.onPressed, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.full),
            onTap: onPressed,
            child: const Center(
              child: Text(
                'Começar 🍯',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate(delay: 600.ms)
        .slideY(begin: 0.5, end: 0, duration: AnimationDurations.slow)
        .fadeIn(duration: AnimationDurations.slow);
  }
}

/// Decorative ring of small circles around a central illustration.
class _DecorativeCircles extends StatelessWidget {
  final Color color;

  const _DecorativeCircles({required this.color});

  @override
  Widget build(BuildContext context) {
    const specs = [
      (dx: -70.0, dy: -60.0, size: 24.0),
      (dx: 80.0, dy: -40.0, size: 16.0),
      (dx: -85.0, dy: 50.0, size: 20.0),
      (dx: 75.0, dy: 65.0, size: 28.0),
    ];

    return Stack(
      alignment: Alignment.center,
      children: specs
          .map(
            (s) => Transform.translate(
              offset: Offset(s.dx, s.dy),
              child: Container(
                width: s.size,
                height: s.size,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _OnboardingScreen1 extends StatelessWidget {
  final Color bgColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryColor;
  final Color accentColor;

  const _OnboardingScreen1({
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
            // Illustration: big circle with clock icon + decorative circles
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _DecorativeCircles(color: accentColor),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.schedule_rounded,
                      size: 64,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: AnimationDurations.slow,
                  curve: AnimationCurves.enter,
                )
                .fadeIn(duration: AnimationDurations.slow),
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

  Widget _coinParticle(int delayMs) {
    return Positioned(
      bottom: 60,
      child: Text('🍯', style: const TextStyle(fontSize: 20))
          .animate(onPlay: (c) => c.repeat(), delay: delayMs.ms)
          .moveY(begin: 0, end: -40, duration: 1200.ms)
          .fadeOut(duration: 1200.ms),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Coin illustration with rising coin particles
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _coinParticle(0),
                  _coinParticle(400),
                  _coinParticle(800),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🍯', style: TextStyle(fontSize: 60)),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .scale(
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.08, 1.08),
                        duration: 1200.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.08, 1.08),
                        end: const Offset(1.0, 1.0),
                        duration: 1200.ms,
                      ),
                ],
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
  final TextEditingController nameController;

  const _OnboardingScreen3({
    required this.bgColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryColor,
    required this.accentColor,
    required this.nameController,
  });

  Widget _heart(double angleDeg, int delayMs) {
    final rad = angleDeg * math.pi / 180;
    final offset = Offset(math.cos(rad) * 90, math.sin(rad) * 90);
    return Positioned(
      left: 80 + offset.dx,
      top: 80 + offset.dy,
      child: const Text('♥️', style: TextStyle(fontSize: 18))
          .animate(onPlay: (c) => c.repeat(), delay: delayMs.ms)
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            duration: 600.ms,
          )
          .then()
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(0, 0),
            duration: 600.ms,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Note: real pet artwork (mel_happy.png) isn't bundled as an asset yet
    // (assets/images/pet/ only has a .gitkeep) — fall back to a drawn
    // illustration so we never render a broken-image icon.
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                children: [
                  _heart(-60, 0),
                  _heart(40, 300),
                  _heart(150, 600),
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🐻', style: TextStyle(fontSize: 64)),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .moveY(begin: 0, end: -8, duration: 1000.ms)
                        .then()
                        .moveY(begin: -8, end: 0, duration: 1000.ms),
                  ),
                ],
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
            const SizedBox(height: AppSpacing.xl),

            // Pet name field
            Text(
              'Como você quer chamar seu pet?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
              child: TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                maxLength: 12,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Ex: Mel, Bolinha, Thor...',
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: textPrimary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
