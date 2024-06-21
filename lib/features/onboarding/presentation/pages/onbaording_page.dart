import 'package:flutter/material.dart';
import 'package:tasky/core/widgets/onboarding_image.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:tasky/features/onboarding/presentation/widgets/onboarding_text.dart';

class OnbaordingPage extends StatefulWidget {
  const OnbaordingPage({super.key});

  @override
  State<OnbaordingPage> createState() => _OnbaordingPageState();
}

class _OnbaordingPageState extends State<OnbaordingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const OnboardingImage(),
              verticalSpacing(24),
              const OnboardingText(),
              verticalSpacing(24),
              const OnboardingButton(),
              verticalSpacing(75),
            ],
          ),
        ),
      ),
    );
  }
}
