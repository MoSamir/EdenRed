import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/loading_icon.svg',
      width: 100,
      height: 100,
    );
  }
}
