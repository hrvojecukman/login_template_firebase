import 'package:flutter/material.dart';

class Page4 extends StatelessWidget {
  final String title;

  const Page4({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
