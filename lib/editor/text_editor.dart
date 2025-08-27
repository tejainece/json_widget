import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_widget/json_widget.dart';
import 'package:json_widget/util/after_init.dart';
import 'dart:convert';

class JsonValueTextEditor extends StatefulWidget {
  final String string;

  final void Function(Object? string) onSubmit;

  final JsonEditorStyle style;

  final bool autoFocus;

  const JsonValueTextEditor(
    this.string, {
    required this.onSubmit,
    required this.style,
    this.autoFocus = false,
    super.key,
  });

  @override
  State<JsonValueTextEditor> createState() => _JsonValueTextEditorState();
}

class _JsonValueTextEditorState extends State<JsonValueTextEditor>
    with AfterInit {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height, // height,
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        // minHeight: minHeight,
        // maxHeight: height,
      ),
      child: TextField(
        autofocus: widget.autoFocus,
        maxLines: null,
        // expands: true,
        //selectAllOnFocus: false,
        controller: _controller,
        style: style.text,
        cursorHeight: style.text.fontSize,
        decoration: style.input.copyWith(
          fillColor: _focusNode.hasFocus
              ? style.input.focusColor
              : style.input.fillColor,
        ),
        focusNode: _focusNode,
        onChanged: (v) {
          _updateConstraints(context);
        },
        onSubmitted: (value) {
          _submit();
        },
      ),
    );
  }

  double width = 200;
  late double height = minHeight;

  final double minWidth = 100;
  final double maxWidth = 400;
  double get minHeight {
    return (widget.style.text.fontSize ?? 16) /
            (widget.style.text.height ?? 1) +
        (widget.style.input.contentPadding?.collapsedSize.height ?? 0);
  }

  void _submit() {
    final value = _controller.text;
    dynamic v;
    try {
      v = jsonDecode(value);
    } catch (e) {
      v = value;
    }
    widget.onSubmit(v);
  }

  late final TextEditingController _controller = TextEditingController(
    text: widget.string,
  );

  late final FocusNode _focusNode =
      FocusNode(
        canRequestFocus: true,
        onKeyEvent: (_, e) {
          if (e.logicalKey == LogicalKeyboardKey.escape) {
            _focusNode.unfocus();
            _controller.text = widget.string;
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
      )..addListener(() {
        if (!_focusNode.hasFocus) {
          _submit();
        }
      });

  JsonEditorStyle get style => widget.style;

  void _updateConstraints(BuildContext context) {
    TextStyle textStyle;
    if (mounted) {
      TextStyle s1 = Theme.of(context).textTheme.bodySmall ?? style.text;
      textStyle = s1.merge(style.text);
    } else {
      textStyle = style.text;
    }
    final span = TextSpan(text: _controller.text, style: textStyle);
    final scale = textStyle.height ?? 1.0;
    final fontSize = textStyle.fontSize ?? 16.0;
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    double magicNumber = fontSize * 4;
    double magicNumber1 = fontSize * scale;
    tp.layout(
      maxWidth:
          maxWidth -
          (style.input.contentPadding?.horizontal ?? 0) -
          magicNumber1,
    );
    width = tp.width + magicNumber;

    if (tp.height <= (fontSize * scale).ceil() + 1) {
      height =
          fontSize +
          (widget.style.input.contentPadding?.collapsedSize.height ?? 0);
    } else {
      height =
          tp.height +
          (widget.style.input.contentPadding?.collapsedSize.height ?? 0);
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  void afterInit() {
    _controller.text = widget.string;
    _updateConstraints(context);
  }

  @override
  void didUpdateWidget(covariant JsonValueTextEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.text = widget.string;
    _updateConstraints(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
