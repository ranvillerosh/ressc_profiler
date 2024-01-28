import 'package:flutter/material.dart';
import '../directory.dart';

class System {
  String systemName;
  BuildContext context;
  System (this.context, this.systemName);

  void navigateToSystem(BuildContext context) {
    if (systemName.contains("Directory")) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RESSCDirectory(title: "RESSCDirectory")));
    }
  }
}