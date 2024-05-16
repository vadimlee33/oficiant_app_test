import 'package:flutter/material.dart';
import 'package:oficiant_app_test/src/core/widgets/custom_nav_bar.dart';

class BaseScaffold extends StatelessWidget {
  final String appTitle;
  final Widget body;
  final bool withPadding;
  const BaseScaffold({super.key, required this.appTitle, required this.body, required this.withPadding});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(appTitle),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: Padding(padding: withPadding ? const EdgeInsets.all(16) : EdgeInsets.zero, child: body));
  }
}
