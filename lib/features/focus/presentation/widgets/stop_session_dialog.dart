import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';

/// Shows a confirmation dialog when the user tries to interrupt an active
/// (running or paused) focus/break session. Returns `true` if the user
/// chose to abandon the session, `false` if they chose to keep going.
Future<bool> showStopConfirmationDialog(
  BuildContext context, {
  required int remainingSeconds,
  required int currentCycle,
  required int totalCycles,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _StopSessionDialog(
      remainingSeconds: remainingSeconds,
      currentCycle: currentCycle,
      totalCycles: totalCycles,
    ),
  );
  return confirmed ?? false;
}

class _StopSessionDialog extends StatelessWidget {
  final int remainingSeconds;
  final int currentCycle;
  final int totalCycles;

  const _StopSessionDialog({
    required this.remainingSeconds,
    required this.currentCycle,
    required this.totalCycles,
  });

  String _buildMessage() {
    final minutes = remainingSeconds ~/ 60;
    if (minutes <= 2) {
      return 'Você está quase lá! Faltam menos de 3 minutos para completar '
          'o Ciclo $currentCycle de $totalCycles e ganhar suas moedas! 🍯';
    }
    if (minutes <= 5) {
      return 'Só mais $minutes minutinhos! A Mel está torcendo por você '
          'nesse Ciclo $currentCycle. Não desanime agora! 🐾';
    }
    return 'Você está no Ciclo $currentCycle de $totalCycles. Se parar '
        'agora, perderá o progresso e as moedas deste ciclo. Que tal '
        'continuar? 💪';
  }

  String _formatRemaining() {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return 'Faltam apenas ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}!';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const hungerColor = Color(0xFFE8736A);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: hungerColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 32,
                color: hungerColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tem certeza?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _buildMessage(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatRemaining(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.primary,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Continuar sessão',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: hungerColor),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Abandonar sessão',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: hungerColor,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
