import 'package:flutter/material.dart';

class TabWidgetTree extends StatefulWidget {
  const TabWidgetTree({super.key});

  @override
  State<TabWidgetTree> createState() => _TabWidgetTreeState();
}

class _TabWidgetTreeState extends State<TabWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tab Widget Tree')),
      body: const Center(
        child: Text('This is the Tab Widget Tree page'),
      ),
    );
  }
}