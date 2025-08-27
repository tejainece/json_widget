/// JSON schema
class JsonSubSchema {
  final List<JsonType> types;
  final Object? const_;
  final List<dynamic> enum_;
  final List<dynamic> examples;

  final JsonSubSchema? not;
  final JsonSubSchema? if_;
  final JsonSubSchema? then;
  final JsonSubSchema? else_;

  final List<JsonSubSchema>? oneOf;
  final List<JsonSubSchema>? anyOf;
  final List<JsonSubSchema>? allOf;

  // number specific
  final num? minimum;
  final num? maximum;
  final num? minimumExclusive;
  final num? maximumExclusive;
  final num? multipleOf;

  // string specific
  final int? minLength;
  final int? maxLength;
  // TODO format
  final String? pattern;

  // array specific
  final int? minItems;
  final int? maxItems;
  final bool? uniqueItems;
  final List<JsonSubSchema>? prefixItems;
  final JsonSubSchema? items;
  final JsonSubSchema? contains;
  final int? minContains;
  final int? maxContains;
  final bool? additionalItems;

  // object specific
  final Map<String, JsonSubSchema>? properties;
  final bool? additionalProperties;
  final List<String>? required;
  final List<String>? displayOrder;

  /// alphabetic,alphabeticDescending,length,lengthDescending
  final JsonPropertiesDisplayOrderType? displayOrderType;

  JsonSubSchema({
    this.types = const [],
    this.const_,
    this.enum_ = const [],
    this.examples = const [],
    this.not,
    this.if_,
    this.then,
    this.else_,
    this.oneOf,
    this.anyOf,
    this.allOf,
    // number specific
    this.minimum,
    this.maximum,
    this.minimumExclusive,
    this.maximumExclusive,
    this.multipleOf,
    // string specific
    this.minLength,
    this.maxLength,
    this.pattern,
    // array specific
    this.minItems,
    this.maxItems,
    this.uniqueItems,
    this.prefixItems,
    this.items,
    this.contains,
    this.minContains,
    this.maxContains,
    this.additionalItems,
    // object specific
    this.properties,
    this.additionalProperties,
    this.required,
    this.displayOrder,
    this.displayOrderType,
  });

  factory JsonSubSchema.string({
    Object? const_,
    List<dynamic> enum_ = const [],
    List<dynamic> examples = const [],
    int? minLength,
    int? maxLength,
    String? pattern,
    // generic
    JsonSubSchema? not,
    JsonSubSchema? if_,
    JsonSubSchema? then,
    JsonSubSchema? else_,
    List<JsonSubSchema>? oneOf,
    List<JsonSubSchema>? anyOf,
    List<JsonSubSchema>? allOf,
  }) => JsonSubSchema(
    types: [JsonType.string],
    const_: const_,
    enum_: enum_,
    examples: examples,
    minLength: minLength,
    maxLength: maxLength,
    pattern: pattern,
    not: not,
    if_: if_,
    then: then,
    else_: else_,
    oneOf: oneOf,
    anyOf: anyOf,
    allOf: allOf,
  );

  factory JsonSubSchema.number({
    Object? const_,
    List<dynamic> enum_ = const [],
    List<dynamic> examples = const [],
    int? minimum,
    int? maximum,
    int? minimumExclusive,
    int? maximumExclusive,
    int? multipleOf,
    // generic
    JsonSubSchema? not,
    JsonSubSchema? if_,
    JsonSubSchema? then,
    JsonSubSchema? else_,
    List<JsonSubSchema>? oneOf,
    List<JsonSubSchema>? anyOf,
    List<JsonSubSchema>? allOf,
  }) => JsonSubSchema(
    types: [JsonType.number],
    const_: const_,
    enum_: enum_,
    examples: examples,
    minimum: minimum,
    maximum: maximum,
    minimumExclusive: minimumExclusive,
    maximumExclusive: maximumExclusive,
    multipleOf: multipleOf,
    // TODO
    not: not,
    if_: if_,
    then: then,
    else_: else_,
    oneOf: oneOf,
    anyOf: anyOf,
    allOf: allOf,
  );

  factory JsonSubSchema.integer({
    Object? const_,
    List<dynamic> enum_ = const [],
    List<dynamic> examples = const [],
    int? minimum,
    int? maximum,
    int? minimumExclusive,
    int? maximumExclusive,
    int? multipleOf,
    // generic
    JsonSubSchema? not,
    JsonSubSchema? if_,
    JsonSubSchema? then,
    JsonSubSchema? else_,
    List<JsonSubSchema>? oneOf,
    List<JsonSubSchema>? anyOf,
    List<JsonSubSchema>? allOf,
  }) => JsonSubSchema(
    types: [JsonType.integer],
    const_: const_,
    enum_: enum_,
    examples: examples,
    minimum: minimum,
    maximum: maximum,
    minimumExclusive: minimumExclusive,
    maximumExclusive: maximumExclusive,
    multipleOf: multipleOf,
    // TODO
    not: not,
    if_: if_,
    then: then,
    else_: else_,
    oneOf: oneOf,
    anyOf: anyOf,
    allOf: allOf,
  );

  factory JsonSubSchema.array({
    Object? const_,
    List<JsonType> examples = const [],
    int? minItems,
    int? maxItems,
    bool? uniqueItems,
    List<JsonSubSchema>? prefixItems,
    JsonSubSchema? items,
    JsonSubSchema? contains,
    int? minContains,
    int? maxContains,
    bool? additionalItems,
    // generic
    JsonSubSchema? not,
    JsonSubSchema? if_,
    JsonSubSchema? then,
    JsonSubSchema? else_,
    List<JsonSubSchema>? oneOf,
    List<JsonSubSchema>? anyOf,
    List<JsonSubSchema>? allOf,
  }) => JsonSubSchema(
    types: [JsonType.array],
    const_: const_,
    examples: examples,
    minItems: minItems,
    maxItems: maxItems,
    uniqueItems: uniqueItems,
    prefixItems: prefixItems,
    items: items,
    contains: contains,
    minContains: minContains,
    maxContains: maxContains,
    additionalItems: additionalItems,
    not: not,
    if_: if_,
    then: then,
    else_: else_,
    oneOf: oneOf,
    anyOf: anyOf,
    allOf: allOf,
  );

  factory JsonSubSchema.object({
    Object? const_,
    List<JsonType> examples = const [],
    Map<String, JsonSubSchema>? properties,
    bool? additionalProperties,
    List<String>? required,
    // generic
    JsonSubSchema? not,
    JsonSubSchema? if_,
    JsonSubSchema? then,
    JsonSubSchema? else_,
    List<JsonSubSchema>? oneOf,
    List<JsonSubSchema>? anyOf,
    List<JsonSubSchema>? allOf,
    List<String>? displayOrder,
    JsonPropertiesDisplayOrderType? displayOrderType,
  }) => JsonSubSchema(
    types: [JsonType.object],
    const_: const_,
    examples: examples,
    properties: properties,
    additionalProperties: additionalProperties,
    required: required,
    not: not,
    if_: if_,
    then: then,
    else_: else_,
    oneOf: oneOf,
    anyOf: anyOf,
    allOf: allOf,
    displayOrder: displayOrder,
    displayOrderType: displayOrderType,
  );

  JsonMessage? _validateNumber(Object? data) {
    final minimum = this.minimum;
    final maximum = this.maximum;
    final minimumExclusive = this.minimumExclusive;
    final maximumExclusive = this.maximumExclusive;
    final multipleOf = this.multipleOf;

    if (minimum == null &&
        maximum == null &&
        minimumExclusive == null &&
        maximumExclusive == null &&
        multipleOf == null) {
      return null;
    }
    if (data is! num) {
      return JsonMessage(".", "must be a number");
    }
    if (minimum != null && data < minimum) {
      return JsonMessage(".", "cannot be less than $minimum");
    }
    if (maximum != null && data > maximum) {
      return JsonMessage(".", "cannot be greater than $maximum");
    }
    if (minimumExclusive != null && data <= minimumExclusive) {
      return JsonMessage(
        ".",
        "cannot be less than or equal to $minimumExclusive",
      );
    }
    if (maximumExclusive != null && data >= maximumExclusive) {
      return JsonMessage(
        ".",
        "cannot be greater than or equal to $maximumExclusive",
      );
    }
    if (multipleOf != null && data % multipleOf != 0) {
      return JsonMessage(".", "must be a multiple of $multipleOf");
    }
    return null;
  }

  JsonMessage? _validateString(Object? data) {
    final minLength = this.minLength;
    final maxLength = this.maxLength;
    final pattern = this.pattern;

    if (minLength == null && maxLength == null && pattern == null) {
      return null;
    }
    if (data is! String) {
      return JsonMessage(".", "must be a string");
    }
    if (minLength != null && data.length < minLength) {
      return JsonMessage(".", "should be at least $minLength characters");
    }
    if (maxLength != null && data.length > maxLength) {
      return JsonMessage(".", "should be at most $maxLength characters");
    }
    if (pattern != null && !RegExp(pattern).hasMatch(data)) {
      return JsonMessage(".", "does not match pattern");
    }
    return null;
  }

  JsonMessage? _validateMapClauses(Object? data) {
    final properties = this.properties;
    final additionalProperties = this.additionalProperties;
    final required = this.required;

    if (properties == null &&
        additionalProperties == null &&
        required == null) {
      return null;
    }

    if (data is! Map) {
      return JsonMessage(
        ".",
        "${JsonType.typeOf(data)} cannot have properties. object is expected",
      );
    }

    if (properties != null) {
      for (final property in properties.entries) {
        final item = data[property.key];
        final error = property.value.validate(item);
        if (error != null) {
          return error.prefixed('.${property.key}');
        }
      }
    }

    if (additionalProperties != null && !additionalProperties) {
      if (properties == null) {
        if (data.isNotEmpty) {
          return JsonMessage(".", "additional properties not allowed");
        }
      } else {
        for (final entry in data.entries) {
          if (!properties.containsKey(entry.key)) {
            return JsonMessage(".", "property ${entry.key} not allowed");
          }
        }
      }
    }

    if (required != null) {
      for (final property in required) {
        if (!data.containsKey(property)) {
          return JsonMessage(".", "property $property is required");
        }
      }
    }

    return null;
  }

  JsonMessage? _validateArrayClauses(Object? data) {
    final minItems = this.minItems;
    final maxItems = this.maxItems;
    final uniqueItems = this.uniqueItems;
    final prefixItems = this.prefixItems;
    final items = this.items;
    final contains = this.contains;
    final int? minContains = this.minContains;
    final maxContains = this.maxContains;
    final additionalItems = this.additionalItems;

    if (minItems == null &&
        maxItems == null &&
        uniqueItems == null &&
        prefixItems == null &&
        items == null &&
        contains == null &&
        minContains == null &&
        maxContains == null &&
        additionalItems == null) {
      return null;
    }

    if (data is! List) {
      return JsonMessage(
        ".",
        "${JsonType.typeOf(data)} cannot have items. array is expected",
      );
    }

    if (minItems != null && data.length < minItems) {
      return JsonMessage(".", "array too short");
    }
    if (maxItems != null && data.length > maxItems) {
      return JsonMessage(".", "array too long");
    }
    if (uniqueItems != null) {
      for (int i = 0; i < data.length; i++) {
        for (int j = i + 1; j < data.length; j++) {
          if (objectEquals(data[i], data[j]) == null) {
            return JsonMessage(
              ".",
              "array items must be unique. duplicated at $i, $j",
            );
          }
        }
      }
    }

    if (prefixItems != null) {
      if (data.length < prefixItems.length) {
        return JsonMessage(
          ".",
          "array must have atleast ${prefixItems.length} items",
        );
      }
      for (int i = 0; i < prefixItems.length; i++) {
        final error = prefixItems[i].validate(data[i]);
        if (error != null) {
          return error.prefixed('.$i');
        }
      }
    }

    if (additionalItems != null && !additionalItems) {
      if (prefixItems == null) {
        if (data.isNotEmpty) {
          return JsonMessage(".", "array must be empty");
        }
      } else {
        if (data.length > prefixItems.length) {
          return JsonMessage(
            ".",
            "array must not contain more than ${prefixItems.length} items",
          );
        }
      }
    }

    if (items != null) {
      for (int i = prefixItems?.length ?? 0; i < data.length; i++) {
        final error = items.validate(data[i]);
        if (error != null) {
          return error.prefixed(".$i");
        }
      }
    }

    if (contains != null) {
      final count = data
          .map((item) => contains.validate(item) == null ? 1 : 0)
          .fold(0, (v, item) => v + item);
      if (count == 0) {
        return JsonMessage(".", "does not contain a required item");
      }
      if (minContains != null && count < minContains) {
        return JsonMessage(
          ".",
          "required item must occur atleast $minContains times",
        );
      }
      if (maxContains != null && count < maxContains) {
        return JsonMessage(
          ".",
          "required item must occur atmost $minContains times",
        );
      }
    }

    return null;
  }

  JsonMessage? validate(Object? data, {bool skipThenElse = false}) {
    JsonMessage? error;

    final types = this.types;
    if (types.isNotEmpty) {
      final myType = JsonType.typeOf(data);
      if (!types.any((type) => myType == type)) {
        return JsonMessage(
          ".",
          "type mismatch. must be one of ${types.join(', ')}",
        );
      }
    }

    if (const_ != null) {
      error = objectEquals(const_, data);
      if (error != null) return error;
    }
    if (enum_.isNotEmpty) {
      if (!enum_.any((en) => objectEquals(en, data) == null)) {
        return JsonMessage(".", "does not match any of the enum");
      }
    }

    error = _validateNumber(data);
    if (error != null) return error;
    error = _validateString(data);
    if (error != null) return error;
    error = _validateMapClauses(data);
    if (error != null) return error;
    error = _validateArrayClauses(data);
    if (error != null) return error;

    if (not != null) {
      if (not!.validate(data) == null) {
        return JsonMessage(".", "does not fail not clause");
      }
    }
    if (if_ != null) {
      if (if_!.validate(data) == null) {
        final then = this.then;
        if (!skipThenElse) {
          if (then != null) {
            final error = then.validate(data);
            if (error != null) return error;
          }
        }
      } else {
        final else_ = this.else_;
        if (!skipThenElse) {
          if (else_ != null) {
            final error = else_.validate(data);
            if (error != null) return error;
          }
        }
      }
    }

    final oneOf = this.oneOf;
    if (oneOf != null) {
      int count = oneOf
          .map((cond) => cond.validate(data) == null ? 1 : 0)
          .fold(0, (v, item) => v + item);
      if (count != 1) {
        return JsonMessage(".", "does not match any of the oneOf conditions");
      }
    }
    final anyOf = this.anyOf;
    if (anyOf != null) {
      if (!anyOf.any((cond) => cond.validate(data) == null)) {
        return JsonMessage(".", "does not match any of the anyOf conditions");
      }
    }
    final allOf = this.allOf;
    if (allOf != null) {
      if (!allOf.every((cond) => cond.validate(data) == null)) {
        return JsonMessage(".", "does not match all of the allOf conditions");
      }
    }

    return null;
  }

  List<JsonSubSchema> getAllMatchingSchemas(Object? data) {
    // TODO validate against this?

    final ret = <JsonSubSchema>[this];
    final if_ = this.if_;
    if (if_ != null) {
      if (if_.validate(data) == null) {
        final then = this.then;
        if (then != null) {
          ret.add(then);
          ret.addAll(then.getAllMatchingSchemas(data));
        }
      } else {
        final else_ = this.else_;
        if (else_ != null) {
          ret.add(else_);
          ret.addAll(else_.getAllMatchingSchemas(data));
        }
      }
    }

    // oneOf
    final oneOf = this.oneOf;
    if (oneOf != null) {
      for (final schema in oneOf) {
        final error = schema.validate(data, skipThenElse: true);
        if (error != null) continue;
        ret.add(schema);
        ret.addAll(schema.getAllMatchingSchemas(data));
        break;
      }
    }

    // anyOf
    final anyOf = this.anyOf;
    if (anyOf != null) {
      for (final schema in anyOf) {
        final error = schema.validate(data, skipThenElse: true);
        if (error != null) continue;
        ret.add(schema);
        ret.addAll(schema.getAllMatchingSchemas(data));
      }
    }

    // allOf
    final allOf = this.allOf;
    if (allOf != null) {
      final list = <JsonSubSchema>[];
      for (final schema in allOf) {
        list.add(schema);
        list.addAll(schema.getAllMatchingSchemas(data));
      }
      ret.addAll(list);
    }

    return ret;
  }

  Map<String, JsonSubSchema> possibleProperties(
    Map data, {
    bool onlyNotPresent = false,
  }) {
    final ret = <String, JsonSubSchema>{};
    final allSchemas = getAllMatchingSchemas(data);
    for (final schema in allSchemas) {
      final properties = schema.properties;
      if (properties != null) {
        ret.addAll(properties);
      }
    }
    if (onlyNotPresent) {
      ret.removeWhere((key, value) => data.containsKey(key));
    }
    return ret;
  }

  JsonSubSchema? matchType(Set<JsonType> matchTypes) {
    if (types.isEmpty) return null;
    if (matchTypes.intersection(types.toSet()).isEmpty) {
      return null;
    }
    return this;
  }

  JsonSubSchema? schemaForIndex(int index) {
    final prefixItems = this.prefixItems;
    if (prefixItems != null && prefixItems.length > index) {
      return prefixItems[index];
    }
    return items;
  }

  dynamic value() {
    if (const_ != null) return const_;
    if (enum_.isNotEmpty) return enum_.first;
    if (types.isNotEmpty) {
      if (types.contains(JsonType.object)) {
        final ret = {};
        if (properties != null) {
          for (final entry in properties!.entries) {
            ret[entry.key] = entry.value.value();
          }
        }
        return ret;
      } else if (types.contains(JsonType.array)) {
        final ret = [];
        if (prefixItems != null) {
          for (final item in prefixItems!) {
            ret.add(item.value());
          }
        }
        if (items != null) {
          ret.add(items!.value());
        }
        if (contains != null) {
          ret.add(contains!.value());
        }
        return ret;
      }
      return types.first.value;
    }
    if (examples.isNotEmpty) return examples.first;
    return null;
  }

  dynamic valueAtIndex(int index) {
    final prefixItems = this.prefixItems;
    if (prefixItems != null) {
      // TODO check other sources of prefixItems
      if (index < prefixItems.length) {
        return prefixItems[index].value();
      }
    }
    // TODO check other sources of items
    return items?.value();
  }

  dynamic valueForProperty(Map data, String property) {
    final properties = possibleProperties(data);
    final schema = properties[property];
    if (schema != null) {
      return schema.value();
    }
    return null;
  }
}

enum JsonType {
  null_,
  boolean,
  string,
  number,
  integer,
  array,
  object;

  dynamic get value {
    switch (this) {
      case null_:
        return null;
      case boolean:
        return false;
      case string:
        return 'string';
      case number:
        return 7.7;
      case integer:
        return 7;
      case array:
        return [];
      case object:
        return {};
    }
  }

  String toJson() {
    if (this == null_) return "null";
    return name;
  }

  static JsonType fromJson(String json) {
    switch (json) {
      case "null":
        return null_;
      default:
        return values.byName(json);
    }
  }

  static JsonType typeOf(Object? data) {
    if (data == null) return null_;
    if (data is bool) return boolean;
    if (data is String) return string;
    if (data is num) return number;
    if (data is List) return array;
    if (data is Map) return object;
    return null_;
  }
}

enum JsonPropertiesDisplayOrderType {
  alphabetic,
  alphabeticDescending,
  length,
  lengthDescending;

  int compare(String a, String b) {
    switch (this) {
      case alphabetic:
        return a.compareTo(b);
      case alphabeticDescending:
        return b.compareTo(a);
      case length:
        return a.length - b.length;
      case lengthDescending:
        return b.length - a.length;
    }
  }
}

JsonMessage? objectEquals(Object? json1, Object? json2) {
  if (JsonType.typeOf(json1) != JsonType.typeOf(json2)) {
    return JsonMessage(".", "type mismatch");
  }

  if (json1 == null) {
    return null;
  } else if (json1 is String || json1 is num || json1 is bool) {
    if (json1 != json2) {
      return JsonMessage(".", "value mismatch");
    }
    return null;
  } else if (json1 is List) {
    final list1 = json1;
    final list2 = json2 as List;
    if (list1.length != list2.length) {
      return JsonMessage(".", "length mismatch");
    }
    for (var i = 0; i < list1.length; i++) {
      final error = objectEquals(list1[i], list2[i]);
      if (error != null) {
        return error.prefixed('.$i');
      }
    }
    return null;
  } else if (json1 is Map) {
    final map1 = json1;
    final map2 = json2 as Map;
    if (map1.length != map2.length) {
      return JsonMessage(".", "length mismatch");
    }
    for (final entry in map1.entries) {
      final error = objectEquals(entry.value, map2[entry.key]);
      if (error != null) {
        return error.prefixed('.${entry.key}');
      }
    }
  } else {
    return JsonMessage(".", "unknown type");
  }
  return null;
}

class JsonMessage {
  final String path;
  final String message;

  JsonMessage(this.path, this.message);

  JsonMessage prefixed(String prefix) {
    return JsonMessage(
      prefix + path.split('.').where((v) => v.isNotEmpty).join('.'),
      message,
    );
  }
}
