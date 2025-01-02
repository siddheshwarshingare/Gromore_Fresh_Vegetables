import 'package:flutter/cupertino.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 10);
    path.cubicTo(100, size.height - 50, size.width - 50, size.height + 50,
        size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  /// this must be true
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
// TODO: implement shouldReclip
}
