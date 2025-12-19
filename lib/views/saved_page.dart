import 'package:yegnabet/controller/home_controller.dart';
import 'package:yegnabet/model/home_madel.dart';
import 'package:yegnabet/utils/globals.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yegnabet/views/details_page.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});
  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _positionAnimation;

  late Animation<Color?> _bgGradientColor;
  late Animation<double?> _bgPositionAnimation;
  late Animation<double> _scaleDownAnimation;
  late Animation<double> _bgFadeAnimation;
  late Animation<double> _imgZoomAnimation;

  int _index = 0;
  double _dx = 0;
  double _dy = 0;
  double _rotation = 0;
  bool _swiping = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600), lowerBound: 0, upperBound: 1);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _positionAnimation = Tween<double>(begin: 40, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _bgPositionAnimation = Tween<double>(begin: 0, end: 40).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleDownAnimation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _bgFadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _bgGradientColor = ColorTween(
      begin: Colors.grey,
      end: Colors.black,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _imgZoomAnimation = Tween<double>(begin: 1, end: 1.09).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails d) {
    if (_swiping) return;
    _controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_swiping) return;

    setState(() {
      _dx += d.delta.dx;
      _dy += d.delta.dy;
      _rotation = _dx / 200;
      _controller.value = (_dx.abs() / 200).clamp(0, 1);
    });
  }

  void _onPanEnd(DragEndDetails d) {
    if (_swiping) return;

    final velocity = d.velocity.pixelsPerSecond.dx;
    final leftDrag = _dx < 0;

    final shouldSwipe = (_dx.abs() > 120 || velocity.abs() > 300);

    if (shouldSwipe) {
      _swiping = true;
      _controller
          .animateTo(1, duration: const Duration(milliseconds: 400), curve: Curves.easeOut)
          .whenComplete(() => leftDrag ? _previousCard() : _nextCard());
    } else {
      setState(() {
        _dx = 0;
        _dy = 0;
        _rotation = 0;
      });
      _controller.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  void _nextCard() {
    final ctr = Get.find<HomeController>();
    setState(() {
      _index = (_index + 1) % ctr.homeModel!.data!.length;
      _dx = 0;
      _dy = 0;
      _rotation = 0;
      _swiping = false;
    });
    _controller.value = 0;
  }

  void _previousCard() {
    final ctr = Get.find<HomeController>();
    setState(() {
      _index = (_index + 1) % ctr.homeModel!.data!.length;
      _dx = 0;
      _dy = 0;
      _rotation = 0;
      _swiping = false;
    });
    _controller.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(left: hPadding, right: hPadding, bottom: hPadding * 3),
        child: GetBuilder<HomeController>(
          builder: (ctr) {
            if (ctr.isLoading) {
              return Center(
                child: Container(
                  width: 80,
                  height: 80,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: hPadding),
                      child: Icon(Icons.hourglass_empty_rounded, color: Colors.white),
                    ),
                  ),
                ),
              );
            } else if (ctr.homeModel == null) {
              return Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [getTheme(context).secondary.withValues(alpha: 0.25), Colors.white.withValues(alpha: 0.08)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: Offset(0, 3))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image_outlined, color: Colors.white, size: 28),
                      SizedBox(height: 6),
                      Text("Failed", style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                    ],
                  ),
                ),
              );
            } else {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (_index < ctr.homeModel!.data!.length - 2)
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, widget) {
                        return Opacity(
                          opacity: _bgFadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _bgPositionAnimation.value!),
                            child: Transform.scale(
                              scale: 0.9 + (_scaleDownAnimation.value - 0.9),
                              child: _background(
                                ctr.homeModel!.data![_index + 1],
                                Colors.grey,
                                _imgZoomAnimation.value,
                                _bgPositionAnimation.value!,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  if (_index < ctr.homeModel!.data!.length - 1)
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, widget) {
                        return Transform.translate(
                          offset: Offset(0, _positionAnimation.value),
                          child: Transform.scale(
                            scale: 0.9 + (_scaleAnimation.value - 0.9),
                            child: _background(
                              ctr.homeModel!.data![_index + 1],
                              _bgGradientColor.value!,
                              _imgZoomAnimation.value,
                              _bgPositionAnimation.value!,
                            ),
                          ),
                        );
                      },
                    ),
                  GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, wiwidgetd) {
                        final screen = MediaQuery.sizeOf(context).width;
                        final direction = _dx.isNegative ? -1 : 1;
                        final exit = _controller.value * screen * direction;

                        return Transform.translate(
                          offset: Offset(_dx + exit, _dy),
                          child: Transform.rotate(angle: _rotation, child: _card(ctr.homeModel!.data![_index])),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _card(Datum data) {
    return GestureDetector(
      onTap: () {
        Get.find<HomeController>().fetchDetail(data);
        Get.toNamed(DetailsPage.route);
      },
      child: Stack(
        children: [
          Hero(
            tag: '${data.id} img',
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Transform.scale(
                    scale: 1.09,
                    child: data.coverImage != null ? CachedNetworkImage(imageUrl: data.coverImage!, fit: BoxFit.cover) : Container(),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.3), Colors.black],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title ?? data.location!.name!,
                    style: const TextStyle(color: Colors.white, fontSize: xxlfont * 1.4, fontWeight: FontWeight.bold, letterSpacing: 0),
                  ),
                  Column(
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Icon(Icons.space_bar_outlined),
                          Text(
                            '${data.squareMeter!} sq',
                            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: mfont),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Icon(Icons.location_on_outlined),
                              Text(
                                data.location!.city!,
                                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: mfont),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: formatNumberWithCommas(data.prices!.price!),
                                  style: TextStyle(color: getTheme(context).onPrimary, fontWeight: FontWeight.bold, fontSize: xlfont),
                                ),
                                TextSpan(
                                  text: ' ${data.prices!.currency!}',
                                  style: TextStyle(color: getTheme(context).secondary, fontWeight: FontWeight.bold, fontSize: lfont),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _background(Datum data, Color gradientColor, double zoom, double pos) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Transform.scale(
                scale: zoom,
                child: data.coverImage != null ? CachedNetworkImage(imageUrl: data.coverImage!, fit: BoxFit.cover) : Container(),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [gradientColor.withValues(alpha: 0.3), gradientColor],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title ?? data.location!.name!,
                  style: const TextStyle(color: Colors.white, fontSize: xxlfont * 1.4, fontWeight: FontWeight.bold, letterSpacing: 0),
                ),
                Column(
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        Icon(Icons.space_bar_outlined),
                        Text(
                          '${data.squareMeter!} sq',
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: mfont),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Icon(Icons.location_on_outlined),
                            Text(
                              data.location!.city!,
                              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: mfont),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: formatNumberWithCommas(data.prices!.price!),
                                style: TextStyle(color: getTheme(context).onPrimary, fontWeight: FontWeight.bold, fontSize: xlfont),
                              ),
                              TextSpan(
                                text: ' ${data.prices!.currency!}',
                                style: TextStyle(color: getTheme(context).secondary, fontWeight: FontWeight.bold, fontSize: lfont),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
