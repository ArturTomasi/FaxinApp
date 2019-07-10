import 'dart:ui';

import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'tab_item.dart';
import 'package:vector_math/vector_math.dart' as vector;

class FancyTabBar extends StatefulWidget {
  final ValueChanged<int> onChanged;

  FancyTabBar({Key key, @required this.onChanged}) : super(key: key);

  @override
  FancyTabBarState createState() => FancyTabBarState();
}

class FancyTabBarState extends State<FancyTabBar>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Tween<double> _positionTween;
  Animation<double> _positionAnimation;

  AnimationController _fadeOutController;
  Animation<double> _fadeFabOutAnimation;
  Animation<double> _fadeFabInAnimation;

  double fabIconAlpha = 1;
  IconData nextIcon = Icons.shopping_cart;
  IconData activeIcon = Icons.clear_all;

  int currentSelected = 1;

  void move(int idx) {
    switch (idx) {
      case 0:
        moveChart();
        break;
      case 1:
        moveCleaning();
        break;
      case 2:
        moveProduct();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: ANIM_DURATION));
    _fadeOutController = AnimationController(
        vsync: this, duration: Duration(milliseconds: (ANIM_DURATION ~/ 5)));

    _positionTween = Tween<double>(begin: 0, end: 0);

    _positionAnimation = _positionTween.animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _fadeFabOutAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabOutAnimation.value;
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            activeIcon = nextIcon;
          });
        }
      });

    _fadeFabInAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.8, 1, curve: Curves.easeOut)))
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabInAnimation.value;
        });
      });
  }

  void moveChart() {
    setState(() {
      nextIcon = Icons.insert_chart;
      currentSelected = 0;
    });

    _initAnimationAndStart(_positionAnimation.value, -1);
  }

  void moveCleaning() {
    setState(() {
      nextIcon = Icons.clear_all;
      currentSelected = 1;
    });

    _initAnimationAndStart(_positionAnimation.value, 0);
  }

  void moveProduct() {
    setState(() {
      nextIcon = Icons.shopping_cart;
      currentSelected = 2;
    });

    _initAnimationAndStart(_positionAnimation.value, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: AppColors.PRIMARY_LIGHT,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: 55,
            margin: EdgeInsets.only(top: 45),
            color: AppColors.PRIMARY,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TabItem(
                    selected: currentSelected == 0,
                    iconData: Icons.insert_chart,
                    title: "Gráficos",
                    callbackFunction: () {
                      moveChart();
                      widget.onChanged(0);
                    }),
                TabItem(
                    selected: currentSelected == 1,
                    iconData: Icons.clear_all,
                    title: "Faxinas",
                    callbackFunction: () {
                      moveCleaning();
                      widget.onChanged(1);
                    }),
                TabItem(
                    selected: currentSelected == 2,
                    iconData: Icons.shopping_cart,
                    title: "Produto",
                    callbackFunction: () {
                      moveProduct();
                      widget.onChanged(2);
                    }),
              ],
            ),
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Align(
                heightFactor: 1,
                alignment: Alignment(_positionAnimation.value, 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: ClipRect(
                            clipper: HalfClipper(),
                            child: Container(
                              child: Center(
                                child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: AppColors.PRIMARY,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.PRIMARY,
                                              blurRadius: 8)
                                        ])),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: PURPLE,
                              border: Border.all(
                                  color: AppColors.PRIMARY,
                                  width: 5,
                                  style: BorderStyle.none)),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Opacity(
                              opacity: fabIconAlpha,
                              child: Icon(
                                activeIcon,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _initAnimationAndStart(double from, double to) {
    _positionTween.begin = from;
    _positionTween.end = to;

    _animationController.reset();
    _fadeOutController.reset();
    _animationController.forward();
    _fadeOutController.forward();
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height / 2);
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class HalfPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect beforeRect = Rect.fromLTWH(0, (size.height / 2) - 10, 10, 10);
    final Rect largeRect = Rect.fromLTWH(10, 0, size.width - 20, 70);
    final Rect afterRect =
        Rect.fromLTWH(size.width - 10, (size.height / 2) - 10, 10, 10);

    final path = Path();
    path.arcTo(beforeRect, vector.radians(0), vector.radians(90), false);
    path.lineTo(20, size.height / 2);
    path.arcTo(largeRect, vector.radians(0), -vector.radians(180), false);
    path.moveTo(size.width - 10, size.height / 2);
    path.lineTo(size.width - 10, (size.height / 2) - 10);
    path.arcTo(afterRect, vector.radians(180), vector.radians(-90), false);
    path.close();

    canvas.drawPath(path, Paint()..color = AppColors.SECONDARY);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
