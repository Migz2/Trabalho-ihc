import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/honey_scaffold.dart';
import '../../../../shared/widgets/honey_button.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../core/constants/hive_keys.dart';

/// Placeholder Onboarding page
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _isLoading = false;

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Mark onboarding as complete
      final prefs = HiveService.userPreferences;
      await prefs.put(HiveKeys.onboardingCompleteKey, true);

      if (mounted) {
        context.go('/focus');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoneyScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 80),
            const SizedBox(height: 24),
            const Text('Welcome to Honey'),
            const SizedBox(height: 16),
            Text(
              'Your personal productivity companion\nwith a virtual pet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),
            HoneyButton(
              label: 'Get Started',
              onPressed: _completeOnboarding,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
