import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_widget/editor/dropdown.dart';
import 'package:json_widget/editor/indent.dart';
import 'package:json_widget/editor/text_editor.dart';
import 'package:json_widget/json_widget.dart';

class JsonScalarEditor extends StatefulWidget {
  final dynamic value;

  final JsonSubSchema? schema;

  final void Function(dynamic) onChanged;

  final JsonEditorStyle style;

  final int indents;

  final double paddingLeft;

  final List<MenuItemButton> actions;

  final bool autoFocus;

  const JsonScalarEditor({
    required this.value,
    required this.schema,
    required this.onChanged,
    required this.style,
    required this.indents,
    required this.paddingLeft,
    required this.actions,
    required this.autoFocus,
    super.key,
  });

  @override
  State<JsonScalarEditor> createState() => _JsonScalarEditorState();
}

class _JsonScalarEditorState extends State<JsonScalarEditor> {
  @override
  Widget build(BuildContext context) {
    Widget child;

    final enums = widget.schema?.enum_;
    if (enums != null && enums.isNotEmpty) {
      child = JsonEnumDropdown(
        stringifyForTextField(value),
        autoFocus: widget.autoFocus,
        onSubmit: (newJson) {
          widget.onChanged(newJson);
        },
        enums: enums.map(stringifyForTextField).toList(),
        style: style,
      );
      /*child = JsonValueDropdownEditor(
        json,
        enums: [null, ...enum_],
        style: style,
        onSubmit: (newJson) {
          widget.onChanged(newJson);
        },
      );*/
    } else {
      child = JsonValueTextEditor(
        json,
        style: style,
        autoFocus: widget.autoFocus,
        onSubmit: (newJson) {
          widget.onChanged(newJson);
        },
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        MenuAnchor(
          controller: _menuController,
          menuChildren: actions,
          onOpen: () {
            setState(() {});
          },
          onClose: () {
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _menuController.isOpen
                  ? Colors.blue.shade300
                  : Colors.transparent,
            ),
            child: actions.isNotEmpty
                ? InkWell(
                    onTap: () {
                      if (_menuController.isOpen) {
                        _menuController.close();
                      } else {
                        _menuController.open();
                      }
                    },
                    child: Icon(Icons.more_vert_rounded),
                  )
                : null,
          ),
        ),
        JsonIndentWidget(widget.indents, style: style),
        SizedBox(width: widget.paddingLeft),
        child,
      ],
    );
  }

  dynamic get value => widget.value;

  late final json = stringifyForTextField(value);

  JsonEditorStyle get style => widget.style;

  List<MenuItemButton> get actions => widget.actions;

  final MenuController _menuController = MenuController();
}

String stringifyForTextField(Object? value) {
  return JsonEncoder.withIndent('  ').convert(value);
}
