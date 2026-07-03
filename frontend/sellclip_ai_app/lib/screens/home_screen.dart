import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/home/home_background.dart';
import 'package:sellclip_ai_app/components/home/home_cards.dart';
import 'package:sellclip_ai_app/components/navigation/sellclip_bottom_navigation.dart';
import 'package:sellclip_ai_app/components/motion/sellclip_motion.dart';
import 'package:sellclip_ai_app/screens/projects_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SellClipTab _currentTab = SellClipTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF020514),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.textScalerOf(context).clamp(
                minScaleFactor: 0.9,
                maxScaleFactor: 1.0,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: AnimatedSwitcher(
                duration: SellClipMotion.normal,
                reverseDuration: SellClipMotion.fast,
                switchInCurve: SellClipMotion.entranceCurve,
                switchOutCurve: SellClipMotion.exitCurve,
                transitionBuilder: (child, animation) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: SellClipMotion.entranceCurve,
                    reverseCurve: SellClipMotion.exitCurve,
                  );
                  return FadeTransition(
                    opacity: curved,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(curved),
                      child: child,
                    ),
                  );
                },
                child: _currentTab == SellClipTab.projects
                    ? const ProjectsScreenBody(key: ValueKey('projects-tab'))
                    : const _HomeTabBody(key: ValueKey('home-tab')),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SellClipBottomNavigation(
        currentTab: _currentTab,
        onTabSelected: (tab) => setState(() => _currentTab = tab),
      ),
    );
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = (constraints.maxWidth * 0.04).clamp(12.0, 20.0);
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(side, 14, side, 178),
              sliver: SliverList.list(
                children: const [
                  HomeHeader(),
                  SizedBox(height: 14),
                  HomeUserGreeting(),
                  SizedBox(height: 16),
                  CreditBalanceCard(),
                  SizedBox(height: 12),
                  CreateVideoPanel(),
                  SizedBox(height: 18),
                  QuickToolsSection(),
                  SizedBox(height: 18),
                  RecentProjectsSection(),
                  SizedBox(height: 18),
                  RenderingSection(),
                  SizedBox(height: 18),
                  SuggestedTemplatesSection(),
                  SizedBox(height: 18),
                  UpdatesSection(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _HorizontalBrand(),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
              color: Colors.white,
              iconSize: 34,
              tooltip: 'Thông báo',
            ),
            Positioned(
              top: 2,
              right: 4,
              child: Container(
                height: 24,
                width: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF8F25FF),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HorizontalBrand extends StatelessWidget {
  const _HorizontalBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_icon.png',
          width: 36,
          height: 36,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox(width: 10),
        const _BrandText(),
      ],
    );
  }
}

class _BrandText extends StatelessWidget {
  const _BrandText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
        children: [
          const TextSpan(text: 'SellClip '),
          TextSpan(
            text: 'AI',
            style: TextStyle(
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFFBE38FF), Color(0xFF168DFF)],
                ).createShader(const Rect.fromLTWH(0, 0, 64, 32)),
            ),
          ),
        ],
      ),
    );
  }
}
