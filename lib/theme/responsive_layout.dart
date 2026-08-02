import 'package:flutter/material.dart';

/// Breakpoints for Screen Sizes
class ResponsiveBreakpoints {
  static const double mobileMax = 600;
  static const double tabletMax = 1024;
}

/// Helper methods to detect screen size category
bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobileMax;

bool isTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width >= ResponsiveBreakpoints.mobileMax &&
      width < ResponsiveBreakpoints.tabletMax;
}

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tabletMax;

/// Responsive Center Widget
/// Wraps screen contents so that on large screens (tablets & desktops),
/// the layout is neatly centered within a maximum width constraint.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 950.0,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topCenter,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to display responsive bottom sheets with max-width on large screens
Future<T?> showResponsiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double maxWidth = 600,
  bool isScrollControlled = true,
  ShapeBorder? shape,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor ?? Colors.transparent,
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
    builder: (ctx) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: builder(ctx),
        ),
      );
    },
  );
}

/// Helper function to display responsive dialogs with max-width on large screens
Future<T?> showResponsiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double maxWidth = 500,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: builder(ctx),
        ),
      );
    },
  );
}
