import 'package:flutter/material.dart';

class NavBarItemWidget extends StatelessWidget {
  final bool isSelected;
  final Widget child;
  final Color backgroundColor;
  final Duration animationDuration;
  final Curve curve;
  final String label;
  final TextStyle labelTextStyle;
  final bool showLabelWhenInactive;
  final bool showLabelWhenActive;
  final bool enlargeWhenSelected;
  final double width;
  final double height;
  final Widget activeChild;

  NavBarItemWidget(
      {this.isSelected,
      this.child,
      this.width,
      this.activeChild,
      this.height,
      this.labelTextStyle,
      this.backgroundColor,
      this.animationDuration,
      this.curve,
      this.enlargeWhenSelected,
      this.label,
      this.showLabelWhenInactive,
      this.showLabelWhenActive}) {
    assert(label != null || !(showLabelWhenActive || showLabelWhenInactive));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            duration: animationDuration,
            width: width,
            height: enlargeWhenSelected
                ? isSelected
                    ? height * 0.75
                    : height * 0.65
                : height * 0.75,
            child: isSelected ? activeChild ?? child : child,
          ),
          if (((showLabelWhenActive && isSelected) ||
              (showLabelWhenInactive && !isSelected)))
            Expanded(
              child: Text(
                label,
                style: labelTextStyle,
              ),
            )
        ],
      ),
    );
  }
}

class NavBarItem {
  final Widget child;
  final Widget activeChild;
  final String label;

  NavBarItem({
    this.child,
    this.activeChild,
    this.label,
  }) {
    assert(child != null);
  }
}
