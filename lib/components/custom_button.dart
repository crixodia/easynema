import 'package:flutter/material.dart';
import 'package:easynema/components/loader.dart';

import '../widgets/Widgets.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPress;
  final bool loading;
  const CustomButton(
      {Key? key,
      required this.text,
      this.loading = false,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.amber),
      child: MaterialButton(
          onPressed: loading ? null : onPress,
          child: loading
              ? const Loader()
              : TextBrand(text: text, fontWeight: FontWeight.bold)),
    );
  }
}
