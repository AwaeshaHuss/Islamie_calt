import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*import 'package:introduction_screen/introduction_screen.dart';
import 'package:islamic_calt/helpers/globals.dart';*/

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // var _connected;
/*
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset('assets/imgs/intro1.jpg', fit: BoxFit.fill),
          title: 'Welcome to IslamicCalture app',
          body:
              'Application for viewing series and films that are legitimate observer',
          footer: Text('@IslamicCulture')),
      PageViewModel(
          image: Image.asset('assets/imgs/intro2.jpg', fit: BoxFit.fill),
          title: 'Welcome to IslamicCalture app',
          body:
              'Application for viewing series and films that are legitimate observer',
          footer: Text('@IslamicCulture')),
      PageViewModel(
          image: Image.asset('assets/imgs/intro3.jpg', fit: BoxFit.fill),
          title: 'Welcome to IslamicCalture app',
          body:
              'Application for viewing series and films that are legitimate observer',
          footer: Text('@IslamicCulture')),
      PageViewModel(
          image: Image.asset('assets/imgs/intro1.jpg', fit: BoxFit.fill),
          title: 'Welcome to IslamicCalture app',
          body:
              'Application for viewing series and films that are legitimate observer',
          footer: Text('@IslamicCulture')),
      PageViewModel(
          image: Image.asset('assets/imgs/intro2.jpg', fit: BoxFit.fill),
          title: 'Welcome to IslamicCalture app',
          body:
              'Application for viewing series and films that are legitimate observer',
          footer: Text('@IslamicCulture')),
    ];
  }
  */
  String user_id = '';
  getUid() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    user_id = shared.getString('user_id').toString();
  }

  @override
  void initState() {
    setState(() {
      getUid();
    });
    Future.delayed(Duration(seconds: 5), () {
      if (user_id == '') {
        Navigator.of(context).pushNamed('regLog_page');
      } else {
        Navigator.of(context).pushNamed('home_page');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        'assets/imgs/islamic_intro.gif',
        fit: BoxFit.cover,
      ),
    ));
  }

/*
  connectionState() async {
    var result = await (Connectivity().checkConnectivity());
    (result != ConnectivityResult.none)
        ? _connected = true
        : _connected = false;
  }
  */
}

/*

Directionality(
      textDirection: TextDirection.ltr,
      child: IntroductionScreen(
        pages: getPages(),
        done: Container(
            width: 65,
            decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30)),
            child: const Text(
              "Done",
              style: TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )),
        doneColor: Colors.white,
        next: Container(
            width: 50,
            decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30)),
            child: const Icon(
              Icons.skip_next,
              color: Colors.white,
            )),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.lightBlue,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
        onDone: () {
          Navigator.of(context).pushNamed('home_page');
        },
        showDoneButton: true,
        showNextButton: true,
        showSkipButton: false,
      ),
    ));

 */
