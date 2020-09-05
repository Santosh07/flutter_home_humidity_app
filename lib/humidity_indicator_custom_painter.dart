import 'package:flutter/material.dart';

const bool isDebug = false;

class HumidityIndicatorCustomPainter extends CustomPainter {
  Paint myPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.blue
    ..strokeWidth = 4;

  Paint myRedPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.red
    ..strokeWidth = 4;

  Paint controlPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.green
    ..strokeWidth = 4;

  Paint panButtonPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.blue[900];

  Paint upIndicatorPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  double position = 0.0;
  BuildContext context;
  Function callBack;

  HumidityIndicatorCustomPainter({this.context, this.position, this.callBack});

  @override
  void paint(Canvas canvas, Size size) {
    Offset startOffset = Offset(size.width * 0.4, 0);
    Offset endOffset = Offset(startOffset.dx, size.height);
    Offset indicatorCenter =
        Offset(startOffset.dx, size.height * (position / 100.0));

    double indicatorRadius = 50;
    double adjustment = (indicatorRadius * 1.3);

    if (indicatorCenter.dy < adjustment) {
      indicatorCenter = Offset(indicatorCenter.dx, adjustment);
    } else if (indicatorCenter.dy > (size.height - adjustment)) {
      indicatorCenter = Offset(indicatorCenter.dx, (size.height - adjustment));
    }

    //Points
    Offset indicatorOffsetStart = Offset(
        indicatorCenter.dx, indicatorCenter.dy - (indicatorRadius * 1.2));

    Offset indicatorMid1 = Offset(indicatorCenter.dx - (indicatorRadius * 0.5),
        indicatorCenter.dy - (indicatorRadius * 0.36));

    Offset indicatorMid2 = Offset(indicatorCenter.dx - (indicatorRadius * 0.5),
        indicatorCenter.dy + (indicatorRadius * 0.36));

    Offset indicatorOffsetEnd = Offset(
        indicatorCenter.dx, indicatorCenter.dy + (indicatorRadius * 1.2));

    //Control Points
    Offset controlPoint1A = Offset(indicatorOffsetStart.dx,
        indicatorOffsetStart.dy + (indicatorRadius * .50));

    Offset controlPoint1B = Offset(
        indicatorOffsetStart.dx - (indicatorRadius * .30),
        indicatorOffsetStart.dy + (indicatorRadius * .45));

    Offset controlPoint2A = Offset(startOffset.dx - indicatorRadius * .60,
        indicatorCenter.dy - (indicatorRadius * .10));

    Offset controlPoint2B = Offset(startOffset.dx - indicatorRadius * .60,
        indicatorCenter.dy + (indicatorRadius * .10));

    Offset controlPoint3A = Offset(
        indicatorOffsetEnd.dx - (indicatorRadius * .30),
        indicatorOffsetEnd.dy - (indicatorRadius * .45));

    Offset controlPoint3B = Offset(
        indicatorOffsetEnd.dx, indicatorOffsetEnd.dy - (indicatorRadius * .50));

    if (isDebug) {
      canvas.drawCircle(controlPoint1A, 4, controlPaint);
      canvas.drawCircle(controlPoint1B, 4, controlPaint);

      canvas.drawCircle(controlPoint2A, 4, controlPaint);
      canvas.drawCircle(controlPoint2B, 4, controlPaint);

      canvas.drawCircle(controlPoint3B, 4, controlPaint);
      canvas.drawCircle(controlPoint3A, 4, controlPaint);

      canvas.drawCircle(indicatorOffsetStart, 4, myRedPaint);
      canvas.drawCircle(indicatorOffsetEnd, 4, myRedPaint);
      canvas.drawCircle(indicatorCenter, 4, myRedPaint);

      canvas.drawCircle(indicatorMid1, 4, myRedPaint);
      canvas.drawCircle(indicatorMid2, 4, myRedPaint);
    }

    Path path = Path()
      ..moveTo(startOffset.dx, startOffset.dy)
      ..lineTo(indicatorOffsetStart.dx, indicatorOffsetStart.dy)
      ..cubicTo(controlPoint1A.dx, controlPoint1A.dy, controlPoint1B.dx,
          controlPoint1B.dy, indicatorMid1.dx, indicatorMid1.dy)
      ..cubicTo(controlPoint2A.dx, controlPoint2A.dy, controlPoint2B.dx,
          controlPoint2B.dy, indicatorMid2.dx, indicatorMid2.dy)
      ..cubicTo(controlPoint3A.dx, controlPoint3A.dy, controlPoint3B.dx,
          controlPoint3B.dy, indicatorOffsetEnd.dx, indicatorOffsetEnd.dy)
      ..lineTo(endOffset.dx, endOffset.dy);
    canvas.drawPath(path, myPaint);

    double panButtonRadius = indicatorRadius * .4;

    Offset panButtonCenter = Offset(
        indicatorCenter.dx + (indicatorRadius * 0.15), indicatorCenter.dy);

    canvas.drawCircle(panButtonCenter, panButtonRadius, panButtonPaint);

    Offset triangleBottomLeft = Offset(
        panButtonCenter.dx - (panButtonRadius * 0.4),
        panButtonCenter.dy - (panButtonRadius * 0.10));
    Offset triangleBottomRight = Offset(
        panButtonCenter.dx + (panButtonRadius * 0.4),
        panButtonCenter.dy - (panButtonRadius * 0.10));

    Path upTrianglePath = Path()
      ..moveTo(triangleBottomLeft.dx, triangleBottomLeft.dy)
      ..lineTo(triangleBottomRight.dx, triangleBottomRight.dy)
      ..lineTo((triangleBottomLeft.dx + triangleBottomRight.dx) / 2,
          panButtonCenter.dy - (panButtonRadius * 0.50))
      ..close();

    Offset triangleTopLeft = Offset(
        panButtonCenter.dx - (panButtonRadius * 0.4),
        panButtonCenter.dy + (panButtonRadius * 0.10));
    Offset triangleTopRight = Offset(
        panButtonCenter.dx + (panButtonRadius * 0.4),
        panButtonCenter.dy + (panButtonRadius * 0.10));

    Path downTrianglePath = Path()
      ..moveTo(triangleTopLeft.dx, triangleTopLeft.dy)
      ..lineTo(triangleTopRight.dx, triangleTopRight.dy)
      ..lineTo((triangleTopLeft.dx + triangleTopRight.dx) / 2,
          panButtonCenter.dy + (panButtonRadius * 0.50))
      ..close();

    canvas.drawPath(upTrianglePath, upIndicatorPaint);
    canvas.drawPath(downTrianglePath, upIndicatorPaint);

    callBack(
        center: Offset(panButtonCenter.dx, panButtonCenter.dy),
        radius: panButtonRadius,
        height: size.height);
  }

  @override
  bool shouldRepaint(HumidityIndicatorCustomPainter oldDelegate) {
    return true;
  }
}
