import 'package:flutter/material.dart';
import 'package:json_widget/editor/collection_header.dart';
import 'package:json_widget/editor/indent.dart';
import 'package:json_widget/json_widget.dart';

export 'key_editor.dart';
export 'scalar_editor.dart';

/*
TODO:
1) Icons for enum
2) if object has children that are objects or list, show expand all, collapse all icons
3) if list has children that are objects or list, show expand all, collapse all icons
*/

class JsonEditorStyle {
  final double indent;

  final double indentThickness;

  final Color indentColor;

  final double propertyValueSpacing;

  final double expanderIconSize;

  final double optionsIconSize;

  final TextStyle heading;

  final TextStyle key;

  final TextStyle text;

  final TextStyle colon;

  final InputDecoration input;

  final InputDecorationTheme dropdown;

  static const double _textSize = 16;

  const JsonEditorStyle({
    this.indent = 24,
    this.indentThickness = 2,
    this.indentColor = Colors.grey,
    this.propertyValueSpacing = 5,
    this.expanderIconSize = 16,
    this.optionsIconSize = 16,
    this.heading = const TextStyle(fontSize: 16),
    this.key = const TextStyle(
      fontSize: _textSize,
      color: Color.fromRGBO(50, 50, 50, 1.0),
    ),
    this.text = const TextStyle(fontSize: _textSize),
    this.colon = const TextStyle(
      fontSize: _textSize,
      color: Color.fromRGBO(0, 0, 0, 1.0),
      fontWeight: FontWeight.bold,
    ),
    this.input = const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 5),
      filled: true,
      fillColor: Colors.transparent,
      focusColor: Color.fromRGBO(200, 200, 200, 1.0),
      hoverColor: Color.fromRGBO(225, 225, 225, 1.0),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
    this.dropdown = const InputDecorationTheme(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 5),
      filled: true,
      fillColor: Colors.white,
      focusColor: Color.fromRGBO(200, 200, 200, 1.0),
      hoverColor: Color.fromRGBO(225, 225, 225, 1.0),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  });
}

class JsonWidget extends StatefulWidget {
  final dynamic data;

  final void Function(dynamic data) onChange;

  final JsonSubSchema? schema;

  final JsonEditorStyle style;

  const JsonWidget({
    required this.data,
    required this.onChange,
    this.schema,
    this.style = const JsonEditorStyle(),
    super.key,
  });

  @override
  State<JsonWidget> createState() => _JsonWidgetState();
}

class _JsonWidgetState extends State<JsonWidget> {
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (data is Map) {
      child = JsonObjectEditor(
        object: data,
        schema: widget.schema,
        style: widget.style,
        indents: 0,
        actions: [],
        onChange: _onChange,
      );
    } else if (data is List) {
      child = JsonListEditor(
        list: data,
        schema: widget.schema,
        style: widget.style,
        indents: 0,
        actions: [],
        onChange: _onChange,
      );
    } else {
      child = JsonScalarEditor(
        value: data,
        schema: widget.schema,
        onChanged: _onChange,
        style: widget.style,
        indents: 0,
        paddingLeft: 0,
        autoFocus: false,
        actions: [],
      );
    }
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Scrollbar(
        thickness: 12.0,
        trackVisibility: true,
        interactive: true,
        controller: _verticalController,
        scrollbarOrientation: ScrollbarOrientation.right,
        thumbVisibility: true,
        child: Scrollbar(
          thickness: 12.0,
          trackVisibility: true,
          interactive: true,
          controller: _horizontalController,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          thumbVisibility: true,
          notificationPredicate: (ScrollNotification notif) => notif.depth == 1,
          child: SingleChildScrollView(
            controller: _verticalController,
            padding: EdgeInsets.only(right: 16, bottom: 16),
            child: SingleChildScrollView(
              primary: false,
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  void _onChange(dynamic v) {
    setState(() {
      data = v;
    });
    // widget.onChange(cloneJson(data));
    widget.onChange(data);
  }

  @override
  void initState() {
    super.initState();
    data = widget.data; // cloneJson(widget.data);
  }

  @override
  void didUpdateWidget(covariant JsonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    data = widget.data; // cloneJson(oldWidget.data);
  }

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  dynamic data;

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }
}

class JsonObjectEditor extends StatefulWidget {
  final Map<String, dynamic> object;

  final void Function(dynamic data) onChange;

  final JsonSubSchema? schema;

  final JsonEditorStyle style;

  final int indents;

  final bool showHeader;

  final List<MenuItemButton> actions;

  const JsonObjectEditor({
    required this.object,
    required this.schema,
    required this.onChange,
    required this.style,
    required this.indents,
    this.showHeader = true,
    required this.actions,
    super.key,
  });

  @override
  State<JsonObjectEditor> createState() => _JsonObjectEditorState();
}

class _JsonObjectEditorState extends State<JsonObjectEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showHeader) _buildHeader(context),
        if (_expanded)
          ...keysOrdered.map(
            (key) => _buildItem(context, MapEntry(key, object[key])),
          ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, MapEntry<String, dynamic> entry) {
    return JsonPropertyEditor(
      key: Key('${entry.key}: ${entry.value}'),
      property: entry,
      schema: schema?.properties?[entry.key],
      possibleKeys: allProperties,
      style: style,
      indents: widget.indents + 1,
      /* TODO paddingLeft: widget.showHeader ? style.expanderIconSize : 0,*/
      actions: [
        MenuItemButton(
          onPressed: () {
            setState(() {
              object.remove(entry.key);
              _update();
            });
            widget.onChange(object);
          },
          child: Row(children: [Icon(Icons.delete_forever), Text('Delete')]),
        ),
        // TODO copy from schema
      ],
      onChange: (v) {
        setState(() {
          if (v.key == entry.key) {
            object[v.key] = v.value;
          } else {
            object.remove(entry.key);
            object[v.key] = v.value;
          }
          _update();
        });
        widget.onChange(object);
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return JsonCollectionHeader(
      object,
      schema: schema,
      style: style,
      text: 'Object',
      expanded: _expanded,
      indents: widget.indents,
      showActions: true,
      onExpandChange: (v) {
        setState(() {
          _expanded = v;
        });
      },
      onChange: (v) {
        widget.onChange(v);
      },
      actions: widget.actions,
      options: [
        MenuAnchor(
          menuChildren: [
            MenuItemButton(
              child: Text('Add key'),
              onPressed: () {
                setState(() {
                  object['Key#${object.length}'] = 'New value';
                  _update();
                });
                widget.onChange(object);
              },
            ),
            ...possibleProperties.map(
              (e) => MenuItemButton(
                child: Text(e),
                onPressed: () {
                  setState(() {
                    object[e] = schema?.valueForProperty(object, e);
                    _update();
                  });
                  widget.onChange(object);
                },
              ),
            ),
          ],
          builder: (_, MenuController controller, Widget? child) {
            return InkWell(
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Icon(Icons.add, size: style.optionsIconSize),
            );
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  void didUpdateWidget(covariant JsonObjectEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  bool _expanded = true;

  late Map<String, dynamic> object = widget.object;

  JsonEditorStyle get style => widget.style;

  JsonSubSchema? schema;

  List<String> allProperties = [];

  List<String> possibleProperties = [];

  List<String> keysOrdered = [];

  Iterable<String> _computeKeysOrdered() sync* {
    final displayOrder = schema?.displayOrder;
    if (schema?.displayOrder != null) {
      for (final key in schema!.displayOrder!) {
        if (object.containsKey(key)) {
          yield key;
        }
      }
    }
    Iterable<String> keys = object.keys;
    if (displayOrder != null) {
      keys = keys.where((key) => !displayOrder.contains(key));
    }
    final displayOrderType = schema?.displayOrderType;
    if (displayOrderType != null) {
      keys = keys.toList()..sort(displayOrderType.compare);
    }
    yield* keys;
  }

  void _update() {
    schema = widget.schema?.matchType({JsonType.object});
    // TODO order keys
    allProperties = schema?.possibleProperties(object).keys.toList() ?? [];
    // TODO order keys
    possibleProperties =
        schema
            ?.possibleProperties(object, onlyNotPresent: true)
            .keys
            .toList() ??
        [];
    possibleProperties.sort();
    keysOrdered = _computeKeysOrdered().toList();
  }
}

class JsonPropertyEditor extends StatefulWidget {
  final MapEntry<String, dynamic> property;

  final void Function(MapEntry<String, dynamic>) onChange;

  final JsonSubSchema? schema;

  final JsonEditorStyle style;

  final int indents;

  final List<String> possibleKeys;

  final List<MenuItemButton> actions;

  const JsonPropertyEditor({
    required this.property,
    required this.schema,
    required this.style,
    required this.indents,
    required this.onChange,
    required this.possibleKeys,
    required this.actions,
    super.key,
  });

  @override
  State<JsonPropertyEditor> createState() => _JsonPropertyEditorState();
}

class _JsonPropertyEditorState extends State<JsonPropertyEditor> {
  @override
  Widget build(BuildContext context) {
    Widget valueWidget;
    if (propertyValue is Map || propertyValue is List) {
      valueWidget = Padding(
        padding: EdgeInsetsGeometry.only(left: style.propertyValueSpacing),
        child: JsonCollectionHeader(
          propertyValue,
          schema: schema,
          style: style,
          text: propertyValue is Map ? 'Object' : 'List',
          expanded: _expanded,
          indents: 0,
          showActions: false,
          onExpandChange: (v) {
            setState(() {
              _expanded = v;
            });
          },
          onChange: (v) {
            setState(() {});
            widget.onChange(MapEntry(propertyKey, v));
          },
          actions: [],
          options: [
            MenuAnchor(
              menuChildren: [
                if (propertyValue is Map)
                  MenuItemButton(
                    child: Text('Add item'),
                    onPressed: () {
                      setState(() {
                        if (propertyValue is Map) {
                          propertyValue['Key#${propertyValue.length}'] =
                              'New value';
                        } else {
                          propertyValue.add(
                            schema?.valueAtIndex(
                              (propertyValue as List).length,
                            ),
                          );
                        }
                        _expanded = true;
                      });
                      widget.onChange(MapEntry(propertyKey, propertyValue));
                    },
                  ),
                if (propertyValue is Map)
                  ...valuePossibleProperties.map(
                    (e) => MenuItemButton(
                      child: Text(e),
                      onPressed: () {
                        setState(() {
                          propertyValue[e] = schema?.valueForProperty(
                            propertyValue,
                            e,
                          );
                        });
                        widget.onChange(MapEntry(propertyKey, propertyValue));
                      },
                    ),
                  ),
                if (propertyValue is List)
                  MenuItemButton(
                    child: Text('Add item'),
                    onPressed: () {
                      setState(() {
                        propertyValue.add('New item');
                      });
                      widget.onChange(MapEntry(propertyKey, propertyValue));
                    },
                  ),
                // TODO for list, add new item

                // TODO for list, add item from schema
              ],
              builder: (_, MenuController controller, Widget? child) {
                return InkWell(
                  onTap: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  child: Icon(Icons.add, size: style.optionsIconSize),
                );
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      );
    } else {
      valueWidget = Container(
        padding: EdgeInsets.only(left: style.propertyValueSpacing),
        child: JsonScalarEditor(
          value: propertyValue,
          schema: schema,
          style: style,
          indents: 0,
          paddingLeft: 0,
          autoFocus: false,
          actions: [],
          onChanged: (v) {
            widget.onChange(MapEntry(propertyKey, v));
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Row(
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
                    child: Icon(Icons.more_vert_rounded),
                  ),
                ),
              ),
              JsonIndentWidget(widget.indents, style: style),
              possibleKeys.isNotEmpty
                  ? JsonKeyDropdown(
                      propertyKey,
                      enums: possibleKeys,
                      style: style,
                      onSubmit: (change) {
                        if (change == propertyKey) {
                          return;
                        }
                        widget.onChange(MapEntry(change, propertyValue));
                      },
                    )
                  : JsonKeyEditor(
                      propertyKey,
                      style: style,
                      onSubmit: (change) {
                        if (change == propertyKey) return;
                        widget.onChange(MapEntry(change, propertyValue));
                      },
                    ),
              Text(':', style: style.colon),
              valueWidget,
            ],
          ),
        ),
        if (_expanded && (propertyValue is Map || propertyValue is List)) ...[
          if (propertyValue is Map)
            JsonObjectEditor(
              object: (propertyValue as Map).cast<String, dynamic>(),
              schema: schema,
              style: style,
              indents: widget.indents,
              showHeader: false,
              actions: [],
              onChange: (json) {
                widget.onChange(MapEntry(propertyKey, json));
              },
            ),
          if (propertyValue is List)
            JsonListEditor(
              list: propertyValue,
              schema: schema,
              style: style,
              indents: widget.indents,
              showHeader: false,
              actions: [],
              onChange: (json) {
                widget.onChange(MapEntry(propertyKey, json));
              },
            ),
        ],
      ],
    );
  }

  bool _expanded = true;

  MapEntry<String, dynamic> get property => widget.property;

  List<MenuItemButton> get actions => widget.actions;

  String get propertyKey => property.key;

  dynamic get propertyValue => property.value;

  JsonEditorStyle get style => widget.style;

  JsonSubSchema? get schema => widget.schema;

  List<String> get possibleKeys => widget.possibleKeys;

  List<String> get valuePossibleProperties {
    if (propertyValue is! Map) return [];
    return schema
            ?.possibleProperties(propertyValue, onlyNotPresent: true)
            .keys
            .toList() ??
        [];
  }

  final MenuController _menuController = MenuController();
}

class JsonListEditor extends StatefulWidget {
  final List<dynamic> list;

  final JsonSubSchema? schema;

  final void Function(dynamic data) onChange;

  final JsonEditorStyle style;

  final int indents;

  final bool showHeader;

  final List<MenuItemButton> actions;

  const JsonListEditor({
    required this.list,
    required this.schema,
    required this.onChange,
    required this.style,
    required this.indents,
    this.showHeader = true,
    required this.actions,
    super.key,
  });

  @override
  State<JsonListEditor> createState() => _JsonListEditorState();
}

class _JsonListEditorState extends State<JsonListEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showHeader) _buildHeader(context),
        if (_expanded)
          ...list.indexed.map((e) => _buildItem(context, e.$1, e.$2)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return JsonCollectionHeader(
      list,
      schema: widget.schema,
      style: style,
      text: 'List',
      expanded: _expanded,
      indents: 0,
      showActions: true,
      onExpandChange: (v) {
        setState(() {
          _expanded = v;
        });
      },
      onChange: (json) {
        widget.onChange(json);
      },
      actions: widget.actions,
      options: [
        MenuItemButton(
          child: Text('Add item'),
          onPressed: () {
            setState(() {
              list.add('New item');
              _expanded = true;
            });
            widget.onChange(list);
          },
        ),
        // TODO
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index, dynamic value) {
    if (value is Map) {
      return JsonObjectEditor(
        object: value.cast<String, dynamic>(),
        schema: widget.schema?.schemaForIndex(index),
        style: style,
        indents: widget.indents + 1,
        // TODO paddingLeft: style.expanderIconSize,
        key: Key('$index'),
        actions: [
          MenuItemButton(
            onPressed: () {
              setState(() {
                list.removeAt(index);
              });
              widget.onChange(list);
            },
            child: Row(children: [Icon(Icons.delete_forever), Text('Delete')]),
          ),
        ],
        onChange: (json) {
          setState(() {
            list[index] = json;
          });
          widget.onChange(list);
        },
      );
    } else if (value is List) {
      return JsonListEditor(
        list: value,
        schema: widget.schema?.schemaForIndex(index),
        style: style,
        indents: widget.indents + 1,
        // TODO paddingLeft: style.expanderIconSize,
        key: Key('$index'),
        actions: [
          MenuItemButton(
            onPressed: () {
              setState(() {
                list.removeAt(index);
              });
              widget.onChange(list);
            },
            child: Row(children: [Icon(Icons.delete_forever), Text('Delete')]),
          ),
        ],
        onChange: (json) {
          setState(() {
            list[index] = json;
          });
          widget.onChange(list);
        },
      );
    } else {
      return IntrinsicHeight(
        child: JsonScalarEditor(
          value: value,
          schema: widget.schema?.schemaForIndex(index),
          style: style,
          indents: widget.indents + 1,
          paddingLeft: 0,
          key: Key('$index'),
          autoFocus: false,
          actions: [
            MenuItemButton(
              onPressed: () {
                setState(() {
                  list.removeAt(index);
                });
                widget.onChange(list);
              },
              child: Row(
                children: [Icon(Icons.delete_forever), Text('Delete')],
              ),
            ),
          ],
          onChanged: (v) {
            setState(() {
              list[index] = v;
            });
            widget.onChange(list);
          },
        ),
      );
    }
  }

  bool _expanded = true;

  List<dynamic> get list => widget.list;

  JsonEditorStyle get style => widget.style;

  JsonSubSchema? get schema => widget.schema?.matchType({JsonType.array});
}

class OptBox<T> {
  final T? value;

  const OptBox(this.value);
}

dynamic cloneJson(dynamic json) {
  if (json is Map) {
    final ret = <String, dynamic>{};
    for (final entry in json.entries) {
      ret[entry.key] = cloneJson(entry.value);
    }
    return ret;
  } else if (json is List) {
    return json.map(cloneJson).toList();
  }
  return json;
}
