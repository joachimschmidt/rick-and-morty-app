import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/bloc.dart';

import 'my_bottom_navigation_bar_item.dart';

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final double navBarHeight;
  final Color navBarBackgroundColor;
  final Color defaultIndicatorColor;
  final Duration animationDuration;
  final List<NavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final Curve curve;
  final TextStyle labelTextStyle;
  final Widget indicator;
  final bool showLabelWhenInactive;
  final bool showLabelWhenActive;
  final bool enlargeWhenSelected;
  final double itemWidth;
  final double itemHeight;
  final double emptySpacePercent;

  CustomNavigationBar(
      {this.enlargeWhenSelected = true,
      this.itemWidth,
      this.itemHeight,
      this.defaultIndicatorColor,
      @required this.selectedIndex,
      this.navBarBackgroundColor,
      this.indicator,
      this.animationDuration = const Duration(milliseconds: 100),
      @required this.items,
      this.emptySpacePercent = 0.2,
      this.navBarHeight = 70,
      this.labelTextStyle = const TextStyle(fontSize: 12),
      this.showLabelWhenInactive = false,
      this.showLabelWhenActive = false,
      @required this.onItemSelected,
      this.curve = Curves.easeOutCubic});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  double _emptySpaceSize = 0,
      _childWidth = 0,
      _childHeight = 0,
      _indicatorLeftPosition = 0;

  _calculateConstraints(double screenWidth) {
    _calculateChildWidth(screenWidth);
    _calculateEmptySpace(screenWidth);
    _calculateChildHeight(screenWidth);
  }

  _calculateChildWidth(double screenWidth) {
    if (widget.itemWidth != null) {
      _childWidth = widget.itemWidth;
    } else {
      _childWidth = (screenWidth - screenWidth * widget.emptySpacePercent) /
          widget.items.length;
    }
  }

  _calculateChildHeight(double screenWidth) {
    if (widget.itemHeight != null) {
      _childHeight = widget.itemHeight;
    } else {
      _childHeight = widget.navBarHeight - widget.navBarHeight * 0.2;
    }
  }

  _calculateEmptySpace(double screenWidth) {
    _emptySpaceSize = (screenWidth - (widget.items.length * _childWidth)) /
        (widget.items.length + 1);
  }

  _calculateIndicatorLeftPosition(int index) {
    setState(() {
      _indicatorLeftPosition =
          (index + 1) * _emptySpaceSize + index * _childWidth;
      widget.onItemSelected(index);
    });
  }

  _calculateInitialIndicatorLeftPosition() {
    _indicatorLeftPosition = (widget.selectedIndex + 1) * _emptySpaceSize +
        widget.selectedIndex * _childWidth;
  }

  _postBuildConfig() {
    var screenWidth = MediaQuery.of(context).size.width;
    _calculateConstraints(screenWidth);
    setState(() {
      _calculateInitialIndicatorLeftPosition();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _postBuildConfig());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.navBarBackgroundColor,
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: widget.navBarHeight,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              AnimatedPositioned(
                curve: widget.curve,
                left: _indicatorLeftPosition,
                duration: widget.animationDuration,
                child: Container(
                  width: _childWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (widget.indicator == null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: _childWidth,
                            height: _childHeight * 1.1,
                            color: widget.defaultIndicatorColor ??
                                Colors.grey[800],
                          ),
                        )
                      else
                        widget.indicator,
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.items.map((localItem) {
                  var index = widget.items.indexOf(localItem);
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _calculateIndicatorLeftPosition(index);
                    },
                    child: NavBarItemWidget(
                      width: _childWidth ?? 0,
                      height: _childHeight ?? 0,
                      child: localItem.child,
                      enlargeWhenSelected: widget.enlargeWhenSelected,
                      isSelected: index ==
                          BlocProvider.of<NavigationScreenBloc>(context)
                              .state
                              .index,
                      animationDuration: widget.animationDuration,
                      curve: widget.curve,
                      label: localItem.label,
                      activeChild: localItem.activeChild,
                      labelTextStyle: widget.labelTextStyle,
                      showLabelWhenActive: widget.showLabelWhenActive,
                      showLabelWhenInactive: widget.showLabelWhenInactive,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
