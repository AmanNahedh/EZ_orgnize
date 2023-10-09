import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  TextForm({
    super.key,
    required this.hint,
    required this.controler,
    required this.valid,
    this.icon,
    this.pass = false,
  });

  final hint;
  var controler;
  final valid;
  late final icon;
  var pass;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(hint),
        icon: icon ?? null,
      ),
      controller: controler,
      validator: valid,
      obscureText: pass,

    );
  }
}
