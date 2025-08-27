import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_widget/editor/indent.dart';
import 'package:json_widget/json_widget.dart';

class JsonCollectionHeader extends StatefulWidget {
  final dynamic data;

  final JsonSubSchema? schema;

  final void Function(dynamic data) onChange;

  final JsonEditorStyle style;

  final String text;

  final bool expanded;

  final void Function(bool expanded) onExpandChange;

  final int indents;

  final List<MenuItemButton> actions;

  final List<Widget> options;

  final bool showActions;

  const JsonCollectionHeader(
    this.data, {
    required this.schema,
    required this.onChange,
    required this.style,
    required this.text,
    required this.expanded,
    required this.onExpandChange,
    required this.indents,
    required this.actions,
    required this.options,
    required this.showActions,
    super.key,
  });

  @override
  State<JsonCollectionHeader> createState() => _JsonCollectionHeaderState();
}

class _JsonCollectionHeaderState extends State<JsonCollectionHeader> {
  @override
  Widget build(BuildContext context) {
    Widget child = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showActions)
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
                child: InkWell(
                  onTap: actions.isNotEmpty
                      ? () {
                          if (_menuController.isOpen) {
                            _menuController.close();
                          } else {
                            _menuController.open();
                          }
                        }
                      : null,
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: actions.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          JsonIndentWidget(widget.indents, style: style),
          if (_editing == null) ...[
            InkWell(
              onTap: () => widget.onExpandChange(!widget.expanded),
              child: buildExpander(expanded, style),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  widget.onExpandChange(false);
                  _editing = widget.data;
                });
              },
              child: Text(widget.text, style: style.heading),
            ),
            SizedBox(width: 5),
            ...widget.options,
          ],
          if (_editing != null)
            JsonScalarEditor(
              value: _editing!,
              schema: widget.schema,
              style: style,
              indents: 0,
              paddingLeft: 0,
              actions: [],
              autoFocus: true,
              onChanged: (newJson) {
                if (newJson == null) {
                  setState(() {
                    _editing = null;
                  });
                  return;
                }
                setState(() {
                  _editing = null;
                });
                widget.onChange(newJson);
              },
            ),
        ],
      ),
    );

    return Material(color: Colors.transparent, child: child);
  }

  List<MenuItemButton> get actions => widget.actions;

  final MenuController _menuController = MenuController();

  bool get expanded => widget.expanded;

  Object? _editing;

  JsonEditorStyle get style => widget.style;

  Widget buildExpander(bool expanded, JsonEditorStyle style) {
    return Icon(
      expanded
          ? CupertinoIcons.arrowtriangle_down_fill
          : CupertinoIcons.arrowtriangle_right_fill,
      size: style.expanderIconSize,
    );
  }
}
