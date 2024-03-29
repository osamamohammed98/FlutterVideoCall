library splashscreen;

import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  /// Seconds to navigate after for time based navigation
  final int seconds;

  /// App title, shown in the middle of screen in case of no image available
  final Text title;

  /// Page background color
  final Color backgroundColor;

  /// Style for the laodertext
  final TextStyle? styleTextUnderTheLoader;

  /// The page where you want to navigate if you have chosen time based navigation
  /// String or Widget
  final Object navigateAfterSeconds;

  /// Main image size
  final double photoSize;

  /// Triggered if the user clicks the screen
  final GestureTapCallback? onClick;

  /// Loader color
  final Color loaderColor;

  /// Main image mainly used for logos and like that
  final Image image;

  /// Loading text, default: 'Loading'
  final Text? loadingText;

  /// Padding for long Loading text, default: EdgeInsets.all(0)
  final EdgeInsets? loadingTextPadding;

  /// Whether to display a loader or not
  final bool useLoader;

  /// Custom page route if you have a custom transition you want to play
  final Route? pageRoute;

  /// RouteSettings name for pushing a route with custom name (if left out in MaterialApp route names) to navigator stack (Contribution by Ramis Mustafa)
  final String? routeName;

  /// expects a function that returns a future, when this future is returned it will navigate
  /// Future<String> or Future<Widget>
  final Future<Object>? navigateAfterFuture;

  static const _defaultStyleTextUnderTheLoader = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  /// Use one of the provided factory constructors instead of.
  @protected
  SplashScreen({
     required this.loaderColor,
     this.navigateAfterFuture,
     required this.seconds,
     required this.photoSize,
     this.pageRoute,
     this.onClick,
     required this.navigateAfterSeconds,
     required this.title,
     required this.backgroundColor,
     this.styleTextUnderTheLoader,
     required this.image,
     this.loadingText,
     this.loadingTextPadding,
     required this.useLoader,
     this.routeName,
  })  : assert(
  routeName == null ||
      (routeName is String && routeName.startsWith('/')),
  'routeName must be a String beginning with forward slash (/)',
  ),
        assert(
        navigateAfterFuture == null ||
            navigateAfterFuture is Future<String> ||
            navigateAfterFuture is Future<Widget>,
        'navigateAfterFuture must be a Future<String> or Future<Widget>',
        ),
        assert(
        navigateAfterFuture != null || seconds != null,
        'navigateAfterFuture and seconds cant be null at the same time',
        ),
        assert(
        navigateAfterFuture != null ||
            navigateAfterSeconds is String ||
            navigateAfterSeconds is Widget,
        'navigateAfterSeconds must either be a String or Widget',
        ),
        assert(
        navigateAfterSeconds is! String ||
            (navigateAfterSeconds is String &&
                navigateAfterSeconds.startsWith('/')),
        'navigateAfterSeconds must be a String beginning with forward slash (/)',
        );

  factory SplashScreen.timer({
    required int seconds,
    required Color loaderColor,
    Color backgroundColor = Colors.white,
    required double photoSize,
    Text loadingText = const Text(''),
    EdgeInsets loadingTextPadding = const EdgeInsets.only(top: 10.0),
    required Image image,
    Route? pageRoute,
    required Object navigateAfterSeconds,
    Future<Object>? navigateAfterFuture,
    Text title = const Text(''),
    TextStyle styleTextUnderTheLoader = _defaultStyleTextUnderTheLoader,
    bool useLoader = true,
  }) =>
      SplashScreen(
        loaderColor: loaderColor,
        seconds: seconds,
        photoSize: photoSize,
        loadingText: loadingText,
        loadingTextPadding: loadingTextPadding,
        backgroundColor: backgroundColor,
        image: image,
        navigateAfterSeconds: navigateAfterSeconds,
        title: title,
        useLoader: useLoader,
      );

  // factory SplashScreen.future({
  //   //required Future<Object> navigateAfterFuture,
  //   Future<Object>? navigateAfterFuture,
  //   required Color loaderColor,
  //   Color backgroundColor = Colors.white,
  //   required double photoSize,
  //   Text loadingText = const Text(''),
  //   EdgeInsets loadingTextPadding = const EdgeInsets.only(top: 10.0),
  //   required Image image,
  //   required Route pageRoute,
  //   required GestureTapCallback onClick,
  //   dynamic navigateAfterSeconds,
  //   Text title = const Text(''),
  //   TextStyle styleTextUnderTheLoader = _defaultStyleTextUnderTheLoader,
  //   required ImageProvider imageBackground,
  //   required Gradient gradientBackground,
  //   bool useLoader = true,
  //   required String routeName,
  // }) =>
  //     SplashScreen(
  //       loaderColor: loaderColor,
  //       navigateAfterFuture: navigateAfterFuture!,
  //       photoSize: photoSize,
  //       loadingText: loadingText,
  //       loadingTextPadding: loadingTextPadding,
  //       backgroundColor: backgroundColor,
  //       image: image,
  //       pageRoute: pageRoute,
  //       onClick: onClick,
  //       navigateAfterSeconds: navigateAfterSeconds,
  //       title: title,
  //       styleTextUnderTheLoader: styleTextUnderTheLoader,
  //       imageBackground: imageBackground,
  //       gradientBackground: gradientBackground,
  //       useLoader: useLoader,
  //       routeName: routeName,
  //     );

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.navigateAfterFuture == null) {
      Timer(Duration(seconds: widget.seconds), () {
        if (widget.navigateAfterSeconds is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context).pushReplacementNamed(
            widget.navigateAfterSeconds as String,
          );
        } else if (widget.navigateAfterSeconds is Widget) {
          Navigator.of(context).pushReplacement(
            widget.pageRoute != null
                ? widget.pageRoute!
                : MaterialPageRoute(
              settings: widget.routeName != null
                  ? RouteSettings(name: widget.routeName)
                  : null,
              builder: (context) => widget.navigateAfterSeconds as Widget,
            ),
          );
        }
      });
    } else {
      widget.navigateAfterFuture!.then((navigateTo) {
        if (navigateTo is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context).pushReplacementNamed(navigateTo);
        } else if (navigateTo is Widget) {
          Navigator.of(context).pushReplacement(
            widget.pageRoute != null
                ? widget.pageRoute!
                : MaterialPageRoute(
                settings: widget.routeName != null
                    ? RouteSettings(name: widget.routeName)
                    : null,
                builder: (context) => navigateTo),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: widget.onClick,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.green, Colors.green.shade700, Colors.green.shade900])
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Hero(
                            tag: 'splashscreenImage',
                            child: Container(child: widget.image),
                          ),
                          radius: widget.photoSize,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        ),
                        widget.title
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.useLoader
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      Padding(
                        padding: widget.loadingTextPadding!,
                        child: widget.loadingText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
