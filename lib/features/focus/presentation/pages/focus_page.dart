import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/navigation/app_routes.dart';
import '../../../../shared/widgets/coin_display.dart';
import '../../domain/entities/timer_state_entity.dart';
import '../providers/timer_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/timer_painter.dart';
import '../widgets/cycle_indicator.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final timerNotifier = ref.read(timerProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        timerNotifier.onAppResumed();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        timerNotifier.onAppPaused();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bom dia';
    } else if (hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getPhaseName(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.focus:
        return 'FOCO';
      case TimerPhase.shortBreak:
        return 'PAUSA';
      case TimerPhase.longBreak:
        return 'DESCANSO';
    }
  }

  double _getProgress(TimerStateEntity timer) {
    const focusDurationMinutes = 25;
    const shortBreakDurationMinutes = 5;
    const longBreakDurationMinutes = 15;

    final totalSeconds = timer.getTotalSecondsForPhase(
      focusDurationMinutes,
      shortBreakDurationMinutes,
      longBreakDurationMinutes,
    );
    if (totalSeconds == 0) return 0;
    return timer.getProgress(totalSeconds);
  }

  String _getBannerMessage(TimerStateEntity timer) {
    if (timer.phase == TimerPhase.focus) {
      return 'Mais um foco e a Mel fica super feliz!';
    }
    if (timer.currentCycle == 1) {
      return 'Você está indo muito bem! Continue.';
    }
    return 'Mel está te esperando — só mais um ciclo!';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    final timerState = ref.watch(timerProvider);
    final userState = ref.watch(userProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      backgroundColor: bgColor,
      body: timerState.when(
        data: (timer) {
          final progress = _getProgress(timer);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with greeting and coins
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      userState.when(
                        data: (user) => Expanded(
                          child: Text(
                            '${_getGreeting()}, ${user.name} ✨',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: textPrimary,
                                ),
                          ),
                        ),
                        loading: () => Expanded(
                          child: Text(
                            '${_getGreeting()}, Mel ✨',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: textPrimary,
                                ),
                          ),
                        ),
                        error: (_, __) => Expanded(
                          child: Text(
                            '${_getGreeting()}, Mel ✨',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: textPrimary,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      userState.when(
                        data: (user) => CoinDisplay(
                          coins: user.coins,
                          textStyle: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          showBackground: true,
                        ),
                        loading: () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                          ),
                          child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Banner with rotating messages
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      _getBannerMessage(timer),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).animate().fade(duration: 400.ms).slide(begin: const Offset(0, 0.08), end: Offset.zero),
                  const SizedBox(height: AppSpacing.xl),

                  // Timer circle
                  Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primaryColor.withValues(alpha: 0.1),
                            primaryColor.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(240, 240),
                            painter: TimerPainter(
                              progress: progress,
                              phase: timer.phase,
                              brightness: Theme.of(context).brightness,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getPhaseName(timer.phase),
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                _formatTime(timer.remainingSeconds),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Ciclo ${timer.currentCycle} de ${timer.totalCycles}',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Cycle indicator
                  Center(
                    child: CycleIndicator(
                      currentCycle: timer.currentCycle,
                      totalCycles: timer.totalCycles,
                      brightness: Theme.of(context).brightness,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Reset button
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: dividerColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: textPrimary,
                          ),
                          onPressed: () {
                            timerNotifier.reset();
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),

                      // Play/Pause button
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            timer.isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            if (timer.isRunning) {
                              timerNotifier.pause();
                            } else if (timer.isPaused) {
                              timerNotifier.resume();
                            } else {
                              timerNotifier.start();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),

                      // Skip button
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: dividerColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.skip_next_rounded,
                            color: textPrimary,
                          ),
                          onPressed: () {
                            timerNotifier.skipPhase();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Status cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: dividerColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Apps bloqueados',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '12 ativos',
                                style: TextStyle(
                                  color: textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: dividerColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notificações',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Silenciadas',
                                style: TextStyle(
                                  color: textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Pet preview card
                  InkWell(
                    onTap: () {
                      context.go(AppRoutes.pet);
                    },
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8C99A).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: const Color(0xFFE8C99A).withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8C99A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mel está animada!',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '+12 moedas após este ciclo',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          );
        },
        loading: () => Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
        ),
        error: (error, stack) => Center(
          child: Text('Erro: $error'),
        ),
      ),
    );
  }
}
