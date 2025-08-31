import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:json_widget/json_widget.dart';
import 'package:json_widget/util/after_init.dart';

class JsonEnumDropdown extends StatefulWidget {
  final String string;

  final void Function(Object? string) onSubmit;

  final JsonEditorStyle style;

  final List<String> enums;

  final bool autoFocus;

  const JsonEnumDropdown(
    this.string, {
    required this.onSubmit,
    required this.enums,
    required this.style,
    required this.autoFocus,
    super.key,
  });

  @override
  State<JsonEnumDropdown> createState() => _JsonEnumDropdownState();
}

class _JsonEnumDropdownState extends State<JsonEnumDropdown> with AfterInit {
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
        suggestionsCallback: (v) => enums
            .where((en) => en.toLowerCase().contains(v.toLowerCase()))
            .toList(),
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
      style: style.text,
      cursorHeight: style.text.fontSize,
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
    final text = _controller.text;
    Object? v;
    try {
      v = jsonDecode(text);
    } catch (e) {
      v = text;
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
      TextStyle s1 = Theme.of(context).textTheme.bodySmall ?? style.text;
      textStyle = s1.merge(style.text);
    } else {
      textStyle = style.text;
    }
    _updateMinWidth(context, textStyle);
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
    if (widget.autoFocus) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (!mounted) return;
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(covariant JsonEnumDropdown oldWidget) {
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

/*
class JsonValueDropdownEditor extends StatefulWidget {
  final String string;

  final List<dynamic> enums;

  final void Function(Object? string) onSubmit;

  final JsonEditorStyle style;

  const JsonValueDropdownEditor(
    this.string, {
    required this.enums,
    required this.onSubmit,
    required this.style,
    super.key,
  });

  @override
  State<JsonValueDropdownEditor> createState() =>
      _JsonValueDropdownEditorState();
}

class _JsonValueDropdownEditorState extends State<JsonValueDropdownEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 200, maxWidth: 200),
      child: DropdownMenu(
        showTrailingIcon: false,
        requestFocusOnTap: true,
        focusNode: _focusNode,
        initialSelection: widget.string,
        width: double.infinity,
        inputDecorationTheme: style.dropdown.copyWith(
          fillColor: _focusNode.hasFocus
              ? style.dropdown.focusColor
              : style.dropdown.fillColor,
        ),
        cursorHeight: style.text.fontSize,
        textStyle: style.text,
        enableFilter: true,
        onSelected: (value) {
          widget.onSubmit(value);
          _focusNode.unfocus();
        },
        dropdownMenuEntries: enums
            .map(
              (item) => DropdownMenuEntry(value: item, label: item.toString()),
            )
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  late final TextEditingController _controller = TextEditingController(
    text: widget.string,
  );

  late final FocusNode _focusNode = FocusNode(
    canRequestFocus: true,
    onKeyEvent: (_, e) {
      if (e.logicalKey == LogicalKeyboardKey.escape) {
        FocusManager.instance.primaryFocus?.unfocus();
        _focusNode.unfocus();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
  );

  JsonEditorStyle get style => widget.style;

  List<dynamic> get enums => widget.enums;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
*/
