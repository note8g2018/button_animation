import 'package:flutter/material.dart';
import 'package:button_animation/Screens/Login/index.dart';
import 'package:button_animation/Screens/Home/index.dart';

class Routes {
  Routes() {
    runApp(MaterialApp(
      title: "Dribbble Animation App",
      debugShowCheckedModeBanner: false,
      home: LoginScreen(key: null,),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return MyCustomRoute(
              builder: (_) => LoginScreen(key: null,),
              settings: settings,
            );

          case '/home':
            return MyCustomRoute(
              builder: (_) => HomeScreen(key: null,),
              settings: settings,
            );
        }
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.arguments) return child;
    return FadeTransition(opacity: animation, child: child);
  }
}
