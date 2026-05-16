import 'package:flutter/material.dart';
import 'utils/utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _turns = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _turns = 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedRotation(
          turns: _turns,
          duration: const Duration(milliseconds: 400),
          child: FlutterLogo(size: 128),
        ),
      ),
      backgroundColor: context.colors.primary,
    );
  }
}
