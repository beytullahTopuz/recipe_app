import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:splashscreen/splashscreen.dart';

import 'home_page2.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 1,
      backgroundColor: Color(0xffF6F5F0),
      title: Text(
        "RECIPE APP",
        style: _textStyle,
      ),
      navigateAfterSeconds: HomePage2(),
      loaderColor: Color(0xffFF3E00),
      loadingText: Text("loading.."),
    );
  }

  get _textStyle {
    return GoogleFonts.adventPro(
        textStyle: Theme.of(context)
            .textTheme
            .headline2
            .copyWith(fontWeight: FontWeight.bold, color: Color(0xffFF3E00)));
  }
}
