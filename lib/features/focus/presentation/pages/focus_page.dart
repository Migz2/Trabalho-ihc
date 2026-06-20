import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/coin_display.dart';
import '../../domain/entities/timer_state_entity.dart';
import '../providers/timer_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/timer_painter.dart';
import '../widgets/cycle_indicator.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../settings/presentation/pages/app_blocking_page.dart';
import '../widgets/cycle_complete_overlay.dart';
import '../widgets/pet_focus_preview.dart';
import '../../../pet/presentation/widgets/level_up_overlay.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage>
    with WidgetsBindingObserver {
  double _lastProgress = 0.0;

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

  /// Min/max bounds (minutes) allowed for a given phase's duration,
  /// matching the ranges already used by the Settings sliders.
  (int, int) _boundsForPhase(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.focus:
        return (5, 60);
      case TimerPhase.shortBreak:
        return (1, 15);
      case TimerPhase.longBreak:
        return (5, 30);
    }
  }

  void _adjustPhaseDuration(TimerPhase phase, int currentMinutes, int delta) {
    final (min, max) = _boundsForPhase(phase);
    final newValue = (currentMinutes + delta).clamp(min, max);
    if (newValue == currentMinutes) return;

    ref.read(timerProvider.notifier).setPhaseDuration(phase, newValue);

    final settingsNotifier = ref.read(settingsProvider.notifier);
    switch (phase) {
      case TimerPhase.focus:
        settingsNotifier.updateFocusDuration(newValue);
        break;
      case TimerPhase.shortBreak:
        settingsNotifier.updateShortBreak(newValue);
        break;
      case TimerPhase.longBreak:
        settingsNotifier.updateLongBreak(newValue);
        break;
    }
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
    final textHintColor = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;

    final timerState = ref.watch(timerProvider);
    final userName = ref.watch(userProvider.select((u) => u.value?.name ?? 'Mel'));
    final userCoins = ref.watch(userProvider.select((u) => u.value?.coins ?? 0));
    final timerNotifier = ref.read(timerProvider.notifier);
    final settingsState = ref.watch(settingsProvider);
    final settings = settingsState.value;
    final blockingActive = settings?.appBlockingEnabled ?? false;

    ref.listen(lastCycleCoinsEarnedProvider, (previous, next) {
      if (next != null) {
        CycleCompleteOverlay.show(context, coinsEarned: next);
        ref.read(lastCycleCoinsEarnedProvider.notifier).state = null;
      }
    });

    ref.listen(petLevelUpEventProvider, (previous, next) {
      if (next != null) {
        LevelUpOverlay.show(context, newLevel: next);
        ref.read(petLevelUpEventProvider.notifier).state = null;
      }
    });
    final blockedAppsCount = settings?.blockedAppPackages.length ?? 0;
    final notificationsSilenced = settings?.silenceNotifications ?? true;

    return Scaffold(
      backgroundColor: bgColor,
      body: timerState.when(
        data: (timer) {
          final progress = _getProgress(timer);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg + 8,
                bottom: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with greeting and coins
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$userName ✨',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      CoinDisplay(
                        coins: userCoins,
                        textStyle: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        showBackground: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Banner with rotating messages
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 44),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('✨', style: TextStyle(fontSize: 16, color: textPrimary)),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            _getBannerMessage(timer),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
                          // Pseudo-depth circle behind the progress painter
                          Container(
                            width: 236,
                            height: 236,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.surfaceVariant,
                            ),
                          ),
                          RepaintBoundary(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: _lastProgress,
                                end: progress,
                              ),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOut,
                              onEnd: () => _lastProgress = progress,
                              builder: (context, animatedProgress, _) {
                                return CustomPaint(
                                  size: const Size(240, 240),
                                  painter: TimerPainter(
                                    progress: animatedProgress,
                                    phase: timer.phase,
                                    brightness: Theme.of(context).brightness,
                                  ),
                                );
                              },
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
                                  letterSpacing: 3.0,
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
                                      fontWeight: FontWeight.w600,
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
                              if (timer.isIdle) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'toque +/− para ajustar',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: textHintColor.withOpacity(0.6),
                                      ),
                                ),
                              ],
                            ],
                          ),
                          // Duration adjustment controls (idle only)
                          Positioned(
                            left: -8,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: timer.isIdle ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: IgnorePointer(
                                  ignoring: !timer.isIdle,
                                  child: _TimeAdjustButton(
                                    icon: Icons.remove,
                                    onTap: () => _adjustPhaseDuration(
                                      timer.phase,
                                      timer.remainingSeconds ~/ 60,
                                      -5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -8,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: timer.isIdle ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: IgnorePointer(
                                  ignoring: !timer.isIdle,
                                  child: _TimeAdjustButton(
                                    icon: Icons.add,
                                    onTap: () => _adjustPhaseDuration(
                                      timer.phase,
                                      timer.remainingSeconds ~/ 60,
                                      5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.surfaceVariant,
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
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.surfaceVariant,
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AppBlockingPage()),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 72),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: dividerColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: (blockingActive
                                            ? Colors.green
                                            : textSecondary)
                                        .withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.shield_outlined,
                                    size: 16,
                                    color: blockingActive
                                        ? Colors.green
                                        : textSecondary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        blockingActive
                                            ? '$blockedAppsCount ativos'
                                            : 'Desativado',
                                        style: TextStyle(
                                          color: blockingActive
                                              ? Colors.green
                                              : textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 72),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: dividerColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: (notificationsSilenced
                                          ? Colors.orange
                                          : textSecondary)
                                      .withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  notificationsSilenced
                                      ? Icons.notifications_off_outlined
                                      : Icons.notifications_outlined,
                                  size: 16,
                                  color: notificationsSilenced
                                      ? Colors.orange
                                      : textSecondary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      notificationsSilenced ? 'Silenciadas' : 'Ativas',
                                      style: TextStyle(
                                        color: notificationsSilenced
                                            ? Colors.orange
                                            : textPrimary,
                                        fontWeight: FontWeight.bold,
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
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Pet preview card
                  const PetFocusPreview(),
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

/// Small circular +/- button used to adjust the timer duration while idle.
class _TimeAdjustButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TimeAdjustButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: textSecondary),
      ),
    );
  }
}
