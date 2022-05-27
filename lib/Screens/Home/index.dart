import 'package:flutter/material.dart';
import 'styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../Components/ListViewContainer.dart';
import '../../Components/AddButton.dart';
import '../../Components/HomeTopView.dart';
import '../../Components/FadeContainer.dart';
import 'homeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Animation<double> containerGrowAnimation;
  late AnimationController _screenController;
  late AnimationController _buttonController;
  late Animation<double> buttonGrowAnimation;
  late Animation<double> listTileWidth;
  late Animation<Alignment> listSlideAnimation;
  late Animation<Alignment> buttonSwingAnimation;
  late Animation<EdgeInsets> listSlidePosition;
  late Animation<Color?> fadeScreenAnimation;
  var animateStatus = 0;
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String month = DateFormat.MMMM().format(
    DateTime.now(),
  );
  int index = DateTime.now().month;
  void _selectforward() {
    if (index < 12)
      setState(() {
        ++index;
        month = months[index - 1];
      });
  }

  void _selectbackward() {
    if (index > 1)
      setState(() {
        --index;
        month = months[index - 1];
      });
  }

  @override
  void initState() {
    super.initState();

    _screenController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _buttonController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    fadeScreenAnimation = new ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: Curves.ease,
      ),
    );
    containerGrowAnimation = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );

    buttonGrowAnimation = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOut,
    );
    containerGrowAnimation.addListener(() {
      setState(() {});
    });
    containerGrowAnimation.addStatusListener((AnimationStatus status) {});

    listTileWidth = Tween<double>(
      begin: 1000.0,
      end: 600.0,
    )
        .animate(
      CurvedAnimation(
        parent: _screenController,
        curve: Interval(
          0.225,
          0.600,
          curve: Curves.bounceIn,
        ),
      ),
    );

    listSlideAnimation = AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    )
        .animate(
      CurvedAnimation(
        parent: _screenController,
        curve: Interval(
          0.325,
          0.700,
          curve: Curves.ease,
        ),
      ),
    );
    buttonSwingAnimation = AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    )
        .animate(
      CurvedAnimation(
        parent: _screenController,
        curve: Interval(
          0.225,
          0.600,
          curve: Curves.ease,
        ),
      ),
    );
    listSlidePosition = EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 16.0),
      end: const EdgeInsets.only(bottom: 80.0),
    )
        .animate(
      CurvedAnimation(
        parent: _screenController,
        curve: Interval(
          0.325,
          0.800,
          curve: Curves.ease,
        ),
      ),
    );
    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.3;
    Size screenSize = MediaQuery.of(context).size;

    return (WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: Stack(
            //alignment: buttonSwingAnimation.value,
            alignment: Alignment.bottomRight,
            children: <Widget>[
              ListView(
                shrinkWrap: _screenController.value < 1 ? false : true,
                padding: const EdgeInsets.all(0.0),
                children: <Widget>[
                  ImageBackground(
                    backgroundImage: backgroundImage,
                    containerGrowAnimation: containerGrowAnimation,
                    profileImage: profileImage,
                    month: month,
                    selectbackward: _selectbackward,
                    selectforward: _selectforward,
                  ),
                  //new Calender(),
                  ListViewContent(
                    listSlideAnimation: listSlideAnimation,
                    listSlidePosition: listSlidePosition,
                    listTileWidth: listTileWidth,
                  )
                ],
              ),
              FadeBox(
                fadeScreenAnimation: fadeScreenAnimation,
                containerGrowAnimation: containerGrowAnimation,
              ),
              animateStatus == 0
                  ? Padding(
                      padding: EdgeInsets.all(20.0),
                      child: InkWell(
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          onTap: () {
                            setState(() {
                              animateStatus = 1;
                            });
                            _playAnimation();
                          },
                          child: AddButton(
                            buttonGrowAnimation: buttonGrowAnimation,
                          )))
                  : StaggerAnimation(
                      buttonController: _buttonController.view),
            ],
          ),
        ),
      ),
    ));
  }
}
