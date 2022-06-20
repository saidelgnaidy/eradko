import 'dart:math';
import 'package:flutter/material.dart';

class DotsIndicator extends AnimatedWidget {
   const DotsIndicator({Key? key,
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
    this.color = Colors.white,
  }) : super(key: key, listenable: controller);
   final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;

  final Color color;

  Widget _buildDot(int index) {
    double selectedNess = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = .5 + (1.0 - .5) * selectedNess;
    return  SizedBox(
      width: 20.0,
      child:  Center(
        child:  Material(
          color: Colors.black54,
          type: MaterialType.circle,
          child:  SizedBox(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
            child:  InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  List<Widget>.generate(itemCount, _buildDot),
    );
  }
}