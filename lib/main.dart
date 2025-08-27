import 'package:flutter/material.dart';
import 'package:json_widget/json_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: JsonWidget(
          data: {
            'worldRadius': 7,
            'provinceRadius': 7,
            'baseTerrain': 'Grass',

            // TODO
          },
          schema: JsonSubSchema.object(
            properties: {
              'worldRadius': JsonSubSchema.integer(),
              'provinceRadius': JsonSubSchema.integer(),
              'baseTerrain': JsonSubSchema.string(),
            },
          ),
          onChange: (v) {},
        ),
      ),
    );
  }
}
