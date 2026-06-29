import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/projects/project_cards.dart';

class ProjectsScreenBody extends StatelessWidget {
  const ProjectsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = (constraints.maxWidth * 0.045).clamp(14.0, 22.0);
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(side, 14, side, 178),
              sliver: SliverList.list(
                children: const [
                  _ProjectsHeader(),
                  SizedBox(height: 22),
                  _ProjectsTitleRow(),
                  SizedBox(height: 18),
                  ProjectSearchField(),
                  SizedBox(height: 16),
                  ProjectFilters(),
                  SizedBox(height: 18),
                  ProjectList(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProjectsHeader extends StatelessWidget {
  const _ProjectsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo_icon.png',
          width: 34,
          height: 34,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              children: [
                const TextSpan(text: 'SellClip '),
                TextSpan(
                  text: 'AI',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [projectPurple, projectBlue],
                      ).createShader(const Rect.fromLTWH(0, 0, 48, 24)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        const _CreateProjectButton(),
      ],
    );
  }
}

class _ProjectsTitleRow extends StatelessWidget {
  const _ProjectsTitleRow();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Dự án',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: 34,
        height: 1,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _CreateProjectButton extends StatelessWidget {
  const _CreateProjectButton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [projectPurple, projectBlue]),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: projectPurple.withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: () {},
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline_rounded,
                    color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Tạo project',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
