import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/navigation/app_routes.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/honey_button.dart';
import '../../../../shared/widgets/honey_shimmer.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/entities/statistics_entity.dart';
import '../providers/statistics_provider.dart';

const _weekdayLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statisticsProvider);

    return Scaffold(
      backgroundColor: context.isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: statsAsync.when(
          loading: () => const _StatisticsShimmer(),
          error: (e, st) => EmptyStateWidget(
            emoji: '⚠️',
            title: 'Erro ao carregar histórico',
            subtitle: 'Tente novamente em instantes',
            action: HoneyButton(
              label: 'Tentar novamente',
              variant: ButtonVariant.outlined,
              onPressed: () => ref.read(statisticsProvider.notifier).refresh(),
            ),
          ),
          data: (stats) {
            if (stats.totalPomodoros == 0) {
              return EmptyStateWidget(
                emoji: '📚',
                title: 'Nenhuma sessão ainda',
                subtitle:
                    'Complete seu primeiro pomodoro para ver seu progresso aqui',
                action: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.focus),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Ir para o foco'),
                ),
              );
            }
            return _StatisticsBody(stats: stats);
          },
        ),
      ),
    );
  }
}

class _StatisticsBody extends StatelessWidget {
  final StatisticsEntity stats;

  const _StatisticsBody({required this.stats});

  @override
  Widget build(BuildContext context) {
    final unlocked = stats.achievements.where((a) => a.unlocked).toList();
    final locked = stats.achievements.where((a) => !a.unlocked).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metrics grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.0,
            children: [
              _MetricCard(
                label: 'Sequência atual',
                value: '${stats.currentStreak} dias',
                emoji: '🔥',
              ),
              _MetricCard(
                label: 'Maior sequência',
                value: '${stats.longestStreak} dias',
                emoji: '🏆',
              ),
              _MetricCard(
                label: 'Horas focadas',
                value: stats.totalHoursStudied.toStringAsFixed(1),
                emoji: '⏱️',
              ),
              _MetricCard(
                label: 'Pomodoros',
                value: '${stats.totalPomodoros}',
                emoji: '🍅',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          Text(
            'ESTA SEMANA',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.textSecondary,
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _WeeklyChart(stats: stats),
          const SizedBox(height: AppSpacing.xl),

          Text(
            'CONQUISTAS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.textSecondary,
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final a in unlocked) ...[
            _AchievementTile(achievement: a),
            const SizedBox(height: 8),
          ],
          if (locked.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ainda não desbloqueadas',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final a in locked) ...[
              _AchievementTile(achievement: a),
              const SizedBox(height: 8),
            ],
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _MetricCard({required this.label, required this.value, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final StatisticsEntity stats;

  const _WeeklyChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final days = stats.weeklyStats.days;
    final maxHours = days.fold<double>(
      1.0,
      (p, d) => d.hoursStudied > p ? d.hoursStudied : p,
    );
    final primaryColor =
        context.isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return RepaintBoundary(
      child: Container(
        height: 196,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: BarChart(
          BarChartData(
            maxY: maxHours * 1.2,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxHours / 2,
              getDrawingHorizontalLine: (value) => FlLine(
                color: context.dividerColor,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= _weekdayLabels.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _weekdayLabels[index],
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < days.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: days[i].hoursStudied,
                      color: primaryColor,
                      width: 18,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final AchievementEntity achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: unlocked
            ? null
            : Border.all(color: context.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          Opacity(
            opacity: unlocked ? 1.0 : 0.35,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (context.isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary)
                    .withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(achievement.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: unlocked
                            ? context.textPrimary
                            : context.textSecondary,
                      ),
                ),
                Text(
                  achievement.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          if (unlocked)
            Text(
              '🍯+${achievement.coinReward}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            )
          else
            Icon(Icons.lock_outline, size: 18, color: context.textSecondary),
        ],
      ),
    );
  }
}

class _StatisticsShimmer extends StatelessWidget {
  const _StatisticsShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(child: HoneyShimmer(width: double.infinity, height: 72)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: HoneyShimmer(width: double.infinity, height: 72)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: const [
              Expanded(child: HoneyShimmer(width: double.infinity, height: 72)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: HoneyShimmer(width: double.infinity, height: 72)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const HoneyShimmer(width: double.infinity, height: 196),
        ],
      ),
    );
  }
}
