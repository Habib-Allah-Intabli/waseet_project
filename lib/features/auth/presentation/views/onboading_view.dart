import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingScreeView();
}

class _OnboardingScreeView extends State<OnboardingView> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: 'assets/images/onboarding_image_1.png',
      title: 'أهلاً بك في وسيط',
      description:
          'نصلك بالمسافرين لنقل أغراضك وأمتعتك بكل سهولة وأمان بين المحافظات السورية.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_image_2.png',
      title: 'شارك رحلتك ووفر تكاليفك',
      description:
          'إذا كنت مسافراً، يمكنك مشاركة رحلتك ونقل الأغراض في طريقك لتقليل تكاليف سفرك.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_image_3.png',
      title: 'تواصل مباشر وآمن',
      description:
          'نظام محادثة فورية يتيح لك الاتفاق على كافة التفاصيل وتتبع حالة طلبك لحظة بلحظة.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => isLastPage = index == _pages.length - 1);
            },
            itemBuilder: (context, index) =>
                OnboardingItem(model: _pages[index]),
          ),

          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: !isLastPage,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: TextButton(
                    onPressed: () =>
                        _pageController.jumpToPage(_pages.length - 1),
                    child: Text(
                      'تخطي',
                      style: TextStyle(color: colorScheme.secondary),
                    ),
                  ),
                ),

                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: colorScheme.primary,
                    dotColor: Colors.grey.shade400,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),

                isLastPage
                    ? ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            CompleteOnboardingRequested(),
                          );
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 48),
                        ),
                        child: const Text('ابدأ الآن'),
                      )
                    : CircleAvatar(
                        radius: 28,
                        backgroundColor: colorScheme.primary,
                        child: IconButton(
                          onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          ),
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
                          ),
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

class OnboardingItem extends StatelessWidget {
  final OnboardingModel model;
  const OnboardingItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            model.image,
            height: MediaQuery.of(context).size.height * 0.35,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 50),
          Text(
            model.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            model.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}
