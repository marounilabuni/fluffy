import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FadeInWidget extends StatefulWidget {
  Widget child;

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
  FadeInWidget(
    this.child, {
    Key? key,
  }) : super(key: key);
}

class _FadeInWidgetState extends State<FadeInWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  //
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool started = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    //
    _slideAnimation = Tween<Offset>(begin: Offset(0, 60), end: Offset.zero)
        .animate(controller);

    animation = Tween<double>(begin: 0, end: 1).animate(controller);
  }

  Key visibiltyKey = Key(
      "visibility_detector ${Random().nextInt(10000)}-${Random().nextInt(10000)}");
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: visibiltyKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2) {
          controller.forward();

          started = true;
        }
        if (widget.child.runtimeType == Text) {
          print(info.visibleFraction);
        }
        //setState(() {});
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Transform.translate(
          offset: _slideAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
    return VisibilityDetector(
      key: visibiltyKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2) {
          controller.forward();

          started = true;
        }
        setState(() {});
      },
      child: Opacity(
        opacity: controller.value,
        child: AnimatedContainer(
          padding: started ? EdgeInsets.zero : EdgeInsets.only(top: 100),
          duration: Duration(milliseconds: 800),
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
