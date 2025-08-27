import 'package:flutter/material.dart';
import 'package:json_widget/editor/editor.dart';

class JsonIndentWidget extends StatefulWidget {
  final JsonEditorStyle style;

  final int indents;

  const JsonIndentWidget(this.indents, {required this.style, super.key});

  @override
  State<JsonIndentWidget> createState() => _JsonIndentWidgetState();
}

class _JsonIndentWidgetState extends State<JsonIndentWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < indents - 2; i++)
          Container(
            width: style.indent,
            // height: style.indent,
            height: double.infinity,
            child: CustomPaint(painter: _JsonIndentPainter(bent: false)),
          ),
        if (indents > 0)
          Container(
            width: style.indent,
            // height: style.indent,
            height: double.infinity,
            child: CustomPaint(painter: _JsonIndentPainter(bent: true)),
          ),
      ],
    );
  }

  int get indents => widget.indents;

  JsonEditorStyle get style => widget.style;
}

class _JsonIndentPainter extends CustomPainter {
  final bool bent;

  const _JsonIndentPainter({required this.bent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    if (!bent) {
      final path = Path()
        ..moveTo(size.width / 2, 0)
        ..lineTo(size.width / 2, size.height);
      canvas.drawPath(path, paint);
    } else {
      final path = Path()
        ..moveTo(size.width / 2, 0)
        ..lineTo(size.width / 2, size.height)
        ..moveTo(size.width / 2, size.height / 2)
        ..lineTo(size.width, size.height / 2);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
