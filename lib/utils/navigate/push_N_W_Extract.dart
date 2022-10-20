import 'package:flutter/material.dart';

import '../../steps/step3.1_docs/step3.1.dart';

push_N_W_Extract(BuildContext context, String title, String message, List<Map<dynamic, dynamic>> imagesInfo) {
  Navigator.pushNamed(
    context,
    ExtractArgumentsScreen.routeName,
    arguments: ScreenArguments(
      title,
      message,
      imagesInfo,
    ),
  );
}
