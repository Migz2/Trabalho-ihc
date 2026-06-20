import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:honey/core/theme/app_colors.dart';
import 'package:honey/core/theme/app_radius.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/features/pet/domain/entities/pet_entity.dart';
import 'package:honey/features/pet/domain/entities/pet_mood_enum.dart';
import 'package:honey/features/pet/presentation/constants/pet_assets.dart';
import 'package:honey/features/pet/presentation/widgets/pet_fallback_painter.dart';

class PetDisplayWidget extends StatefulWidget {
  final PetEntity pet;
  final double size;
  final VoidCallback? onEatAnimation;
  final VoidCallback? onLoveAnimation;

  const PetDisplayWidget({
    Key? key,
    required this.pet,
    this.size = 180,
    this.onEatAnimation,
    this.onLoveAnimation,
  }) : super(key: key);

  @override
  State<PetDisplayWidget> createState() => _PetDisplayWidgetState();
}

class _PetDisplayWidgetState extends State<PetDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _happyController;
  late AnimationController _eatController;
  late AnimationController _loveController;

  @override
  void initState() {
    super.initState();
    _happyController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _eatController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(PetDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger happy animation when mood changes to ecstatic
    if (oldWidget.pet.computedMood != PetMood.ecstatic &&
        widget.pet.computedMood == PetMood.ecstatic) {
      _triggerHappyAnimation();
    }
  }

  void _triggerHappyAnimation() {
    _happyController.forward(from: 0.0);
  }

  void triggerEatAnimation() {
    _eatController.forward(from: 0.0);
  }

  void triggerLoveAnimation() {
    _loveController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _happyController.dispose();
    _eatController.dispose();
    _loveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size + AppSpacing.lg,
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D2E22), Color(0xFF2A1F18)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pet image with idle animation
          _buildPetImage(),

          // Love hearts animation
          if (widget.pet.computedMood == PetMood.happy ||
              widget.pet.computedMood == PetMood.ecstatic ||
              widget.pet.computedMood == PetMood.content)
            _buildLoveHearts(),

          // Speech bubble
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform.translate(
              offset: const Offset(0, 40),
              child: _buildSpeechBubble(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetImage() {
    final assetPath = PetAssets.getAssetForMood(widget.pet.computedMood);

    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _happyController, curve: Curves.elasticOut),
      ),
      child: Image.asset(
        assetPath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        // Real pet artwork isn't bundled yet (assets/images/pet/ only has a
        // .gitkeep) — fall back to a hand-drawn puppy so we never show a
        // broken-image error instead of Mel.
        errorBuilder: (context, error, stackTrace) => CustomPaint(
          size: Size(widget.size, widget.size),
          painter: PetFallbackPainter(mood: widget.pet.computedMood),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .moveY(begin: 0, end: -8)
          .then()
          .moveY(begin: -8, end: 0),
    );
  }

  Widget _buildLoveHearts() {
    return AnimatedBuilder(
      animation: _loveController,
      builder: (context, child) {
        final progress = _loveController.value;

        if (progress == 0) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeart(progress, 0.3),
            _buildHeart(progress, 0.15),
            _buildHeart(progress, 0.45),
          ],
        );
      },
    );
  }

  Widget _buildHeart(double progress, double delay) {
    final opacity = (1.0 - (progress - delay).clamp(0.0, 1.0)).clamp(0.0, 1.0);
    final translateY = -(progress - delay).clamp(0.0, 1.0) * 60;

    if (delay > progress) return const SizedBox.shrink();

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Opacity(
        opacity: opacity,
        child: const Text(
          '♥️',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSpeechBubble() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final message = _getMoodMessage(widget.pet.computedMood);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  String _getMoodMessage(PetMood mood) {
    switch (mood) {
      case PetMood.ecstatic:
        return '"Uhuuu! Adoro você!" 🎉';
      case PetMood.happy:
        return '"Vamos brincar?" 🐾';
      case PetMood.content:
        return '"Estou bem!" 😊';
      case PetMood.neutral:
        return '"Hmm..." 🤔';
      case PetMood.sad:
        return '"Saudade de você..." 😢';
      case PetMood.neglected:
        return '"Por favor, cuide de mim..." 😞';
    }
  }
}
