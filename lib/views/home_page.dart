import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:rentify/service/liquid_effct/liquid_glass_lens_shader.dart';
import 'package:rentify/utils/globals.dart';
import 'package:rentify/utils/image_constants.dart';
import 'package:rentify/views/foryou_page.dart';
import 'package:rentify/views/saved_page.dart';
import 'package:rentify/views/widgets/dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:rentify/views/widgets/main_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = "/";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final GlobalKey backgroundKey = GlobalKey();
  late LiquidGlassLensShader liquidGlassLensShader = LiquidGlassLensShader()..initialize();
  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildStaticImageBackground());
  }

  Widget _buildStaticImageBackground() {
    return Stack(
      children: [
        RepaintBoundary(
          key: backgroundKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/sample_1.png', fit: BoxFit.cover),
                Image.asset('assets/images/sample_2.jpg', fit: BoxFit.cover),
                Image.asset('assets/images/sample_3.jpg', fit: BoxFit.cover),
              ],
            ),
          ),
        ),
        BackgroundCaptureWidget(
          width: 160,
          height: 160,
          initialPosition: Offset(0, 0),
          backgroundKey: backgroundKey,
          shader: liquidGlassLensShader,
          child: Center(child: Image.asset('assets/images/photo.png', width: 72, height: 72)),
        ),
      ],
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            key: backgroundKey,
            child: Stack(
              children: [
                Positioned(top: 200, left: 20, child: blurryCircle(context)),
                Positioned(top: 80, right: 40, child: blurryCircle(context)),

                Positioned.fill(
                  child: Column(
                    children: [
                      SafeArea(child: SizedBox(height: 15)),
                      MainAppbar(),
                      SizedBox(height: 20.h),

                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: hPadding),
                              child: Container(
                                width: double.infinity,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [getTheme(context).secondary.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: hPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text("Nearby"), Text("Rant"), Text("Sell")],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: hPadding),
                            child: Container(
                              width: 50,
                              height: 50,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [getTheme(context).secondary.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),

                                child: Icon(Icons.tune, color: Colors.white, size: iconSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      Expanded(
                        child: TabBarView(
                          clipBehavior: Clip.none,
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [ForYouPage(), SavedPage(), Container(), Container()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: BackgroundCaptureWidget(
          //     width: double.infinity,
          //     height: 70,
          //     initialPosition: Offset(0, 0),
          //     backgroundKey: backgroundKey,
          //     shader: liquidGlassLensShader,
          //     child: Container(
          //       // decoration: BoxDecoration(borderRadius: BorderRadius.circular(kRadius), gradient: gradient(context)),
          //       // child: Center(child: Text("hello")),
          //       child: TabBar(
          //         controller: _tabController,
          //         indicatorColor: getTheme(context).secondary,
          //         labelColor: getTheme(context).secondary,
          //         dividerColor: getTheme(context).surface,
          //         indicator: DotIndicator(color: getTheme(context).secondary, radius: 3),
          //         tabs: [
          //           _buildTabItem('Home', ImageConstants.home, Icons.home, Icons.home_outlined, 0),
          //           _buildTabItem('Saved', ImageConstants.saved, Icons.bookmark_rounded, Icons.bookmark_outline_outlined, 1),
          //           _buildTabItem('Reels', ImageConstants.reels, Icons.play_arrow, Icons.play_arrow_outlined, 2),
          //           _buildTabItem('Setting', ImageConstants.notification, Icons.settings, Icons.settings, 3),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        height: 75,
        child: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 30),
            child: TabBar(
              controller: _tabController,
              indicatorColor: getTheme(context).secondary,
              labelColor: getTheme(context).secondary,
              dividerColor: getTheme(context).surface,
              indicator: DotIndicator(color: getTheme(context).secondary, radius: 3),
              tabs: [
                _buildTabItem('Home', ImageConstants.home, Icons.home, Icons.home_outlined, 0),
                _buildTabItem('Saved', ImageConstants.saved, Icons.bookmark_rounded, Icons.bookmark_outline_outlined, 1),
                _buildTabItem('Reels', ImageConstants.reels, Icons.play_arrow, Icons.play_arrow_outlined, 2),
                _buildTabItem('Setting', ImageConstants.notification, Icons.settings, Icons.settings, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, String activeIcon, IconData icon, IconData? inactiveIcon, int index) {
    return Tab(
      // text: text,
      // icon: Icon(
      //   _currentIndex == index ? icon : inactiveIcon,
      //   color: _currentIndex == index ? getTheme(context).secondary : getTheme(context).onPrimary,
      //   size: 25,
      // ),
      icon: Image.asset(activeIcon, scale: 30, color: _currentIndex == index ? getTheme(context).secondary : getTheme(context).onPrimary),
    );
  }

  Widget blurryCircle(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;

    return CustomPaint(foregroundPainter: CircleBlurPainter(circleWidth: 80, color: color, blurSigma: 100.0));
  }
}

class CircleBlurPainter extends CustomPainter {
  CircleBlurPainter({required this.circleWidth, required this.color, this.blurSigma});

  Color color;
  double circleWidth;
  double? blurSigma = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma!);
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
