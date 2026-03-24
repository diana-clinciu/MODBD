import 'dart:ui';

extension ColorWithAlpha on Color {
  Color withTransparency(double alpha) {
    return withAlpha((alpha.clamp(0.0, 1.0) * 255).toInt());
  }
}
