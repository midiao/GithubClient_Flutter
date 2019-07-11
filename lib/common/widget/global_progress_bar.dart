import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final bool visibility;

  ProgressBar({Key key, this.visibility = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: (!visibility),
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
      ),
    );
  }
}
