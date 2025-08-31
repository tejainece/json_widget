import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:json_widget/json_widget.dart';
import 'package:json_widget/util/after_init.dart';

class JsonKeyEditor extends StatefulWidget {
  final String string;

  final void Function(String string) onSubmit;

  final JsonEditorStyle style;

  final bool autoFocus;

  const JsonKeyEditor(
    this.string, {
    required this.onSubmit,
    required this.style,
    this.autoFocus = false,
    super.key,
  });

  @override
  State<JsonKeyEditor> createState() => _JsonKeyEditorState();
}

class _JsonKeyEditorState extends State<JsonKeyEditor> with AfterInit {
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
        controller: _controller,
        style: style.key,
        cursorHeight: style.key.fontSize,
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

  void _submit() {
    widget.onSubmit(_controller.text);
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
        if (mounted) setState(() {});
        if (!_focusNode.hasFocus) {
          _submit();
        }
      });

  JsonEditorStyle get style => widget.style;

  double width = 200;
  late double height = minHeight;

  final double minWidth = 100;
  final double maxWidth = 400;
  double get minHeight {
    return (style.key.fontSize ?? 16) / (style.key.height ?? 1) +
        (style.input.contentPadding?.collapsedSize.height ?? 0);
  }

  void _updateConstraints(BuildContext context) {
    TextStyle textStyle;
    if (mounted) {
      TextStyle s1 = Theme.of(context).textTheme.bodySmall ?? style.key;
      textStyle = s1.merge(style.key);
    } else {
      textStyle = style.key;
    }
    final span = TextSpan(text: _controller.text, style: textStyle);
    final scale = textStyle.height ?? 1.0;
    final fontSize = textStyle.fontSize ?? 16.0;
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    double magicNumber = fontSize * 3;
    double magicNumber1 = fontSize * scale;
    tp.layout(
      maxWidth:
          maxWidth -
          (style.input.contentPadding?.horizontal ?? 0) -
          magicNumber1,
    );
    width = tp.width + magicNumber;

    if (tp.width <
        maxWidth -
            (style.input.contentPadding?.horizontal ?? 0) -
            magicNumber1) {
      //if (tp.width / maxWidth < 0.8) {
      height =
          tp.height * 1 / 1.2 +
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
  void didUpdateWidget(covariant JsonKeyEditor oldWidget) {
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

class JsonKeyDropdown extends StatefulWidget {
  final String string;

  final void Function(String string) onSubmit;

  final JsonEditorStyle style;

  final List<String> enums;

  const JsonKeyDropdown(
    this.string, {
    required this.onSubmit,
    required this.enums,
    required this.style,
    super.key,
  });

  @override
  State<JsonKeyDropdown> createState() => _JsonKeyDropdownState();
}

class _JsonKeyDropdownState extends State<JsonKeyDropdown> with AfterInit {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // height,
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        // minHeight: minHeight,
        // maxHeight: height,
      ),
      child: TypeAheadField<String>(
        itemBuilder: (context, String option) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            child: Text(
              option,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          );
        },
        onSelected: (v) {
          _controller.text = v;
          _submit();
        },
        suggestionsCallback: (v) =>
            enums.where((en) => en.contains(v)).toList(),
        hideOnEmpty: true,
        hideOnUnfocus: true,
        showOnFocus: true,
        controller: _controller,
        focusNode: _focusNode,
        builder: (context, controller, focusNode) {
          return _buildTextField(context, controller, focusNode);
        },
      ),
    );
  }

  TextField _buildTextField(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return TextField(
      controller: controller,
      style: style.key,
      cursorHeight: style.key.fontSize,
      decoration: style.input.copyWith(
        fillColor: _focusNode.hasFocus
            ? style.input.focusColor
            : style.input.fillColor,
      ),
      focusNode: focusNode,
      onChanged: (v) {
        _updateConstraints(context);
      },
      onSubmitted: (value) {
        _submit();
      },
    );
  }

  void _submit() {
    widget.onSubmit(_controller.text);
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
        if (mounted) setState(() {});
        if (!_focusNode.hasFocus) {
          _submit();
        }
      });

  JsonEditorStyle get style => widget.style;
  List<String> get enums => widget.enums;

  double width = 200;

  double minWidth = 100;
  final double maxWidth = 400;

  void _updateMinWidth(BuildContext context, TextStyle textStyle) {
    final longest = enums.fold(
      enums.first,
      (prev, next) => next.length > prev.length ? next : prev,
    );
    final scale = textStyle.height ?? 1.0;
    final fontSize = textStyle.fontSize ?? 16.0;
    final span = TextSpan(text: longest, style: textStyle);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(
      maxWidth: maxWidth - (style.input.contentPadding?.horizontal ?? 0),
    );
    minWidth = tp.width + fontSize * scale * 3;
    if (minWidth > maxWidth) {
      minWidth = maxWidth;
    }
  }

  void _updateConstraints(BuildContext context) {
    TextStyle textStyle;
    if (mounted) {
      TextStyle s1 = Theme.of(context).textTheme.bodySmall ?? style.key;
      textStyle = s1.merge(style.key);
    } else {
      textStyle = style.key;
    }
    _updateMinWidth(context, textStyle);
    /*final span = _controller.buildTextSpan(
      context: context,
      withComposing: false,
    );*/
    final span = TextSpan(text: _controller.text, style: textStyle);
    final scale = textStyle.height ?? 1.0;
    final fontSize = textStyle.fontSize ?? 16.0;
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    double magicNumber = fontSize * 3;
    double magicNumber1 = fontSize * scale;
    tp.layout(
      maxWidth:
          maxWidth -
          (style.input.contentPadding?.horizontal ?? 0) -
          magicNumber1,
    );
    width = tp.width + magicNumber;

    if (!mounted) return;
    setState(() {});
  }

  @override
  void afterInit() {
    _controller.text = widget.string;
    _updateConstraints(context);
  }

  @override
  void didUpdateWidget(covariant JsonKeyDropdown oldWidget) {
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
