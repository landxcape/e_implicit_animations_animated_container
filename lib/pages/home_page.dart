import 'dart:math';

import 'package:flutter/material.dart';

enum ZoomLevel {
  zoomIn('Zoom In', 75.0, Curves.bounceOut),
  zoomOut('Zoom Out', 250.0, Curves.elasticOut);

  final String title;
  final double width;
  final Curve curve;
  const ZoomLevel(this.title, this.width, this.curve);
}

const _zoomDuration = Duration(milliseconds: 500);
const _rotationDuration = Duration(seconds: 3);

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  void _toggleZoomLevel() {
    setState(() {
      zoomLevel = zoomLevel == ZoomLevel.zoomIn ? ZoomLevel.zoomOut : ZoomLevel.zoomIn;
    });
  }

  ZoomLevel zoomLevel = ZoomLevel.zoomIn;

  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _rotationDuration,
    );
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: _zoomDuration,
                  width: zoomLevel.width,
                  curve: zoomLevel.curve,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..rotateX(_animation.value)
                              ..rotateY(_animation.value)
                              ..rotateZ(_animation.value),
                            child: const Text('Hello World!'),
                          );
                        }),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: _toggleZoomLevel,
              child: Text(zoomLevel.title),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
