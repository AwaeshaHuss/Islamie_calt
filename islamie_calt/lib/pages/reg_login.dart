import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:islamic_calt/helpers/globals.dart';

class RegLogin extends StatefulWidget {
  @override
  _RegLoginState createState() => _RegLoginState();
}

class _RegLoginState extends State<RegLogin> {
  PageController _pagecontroller = PageController();
  // Register Form Controllers
  TextEditingController _fController = TextEditingController();
  TextEditingController _lController = TextEditingController();
  TextEditingController _eController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _repassController = TextEditingController();
  // Login Form Controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  saveUid(String id) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString('user_id', id);
  }

  Future postRegister(
      String fName, String lName, String email, String password) async {
    var url = Uri.parse(
        '${Globals.apiKey}SaveUser?FName=$fName&LName=$lName&email=$email&Pass=$password');
    var data = {};
    var response = await http.post(url, body: data);
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse != 0) {
      setState(() {
        Navigator.of(context).pushNamed('home_page');
        Globals.userID = decodedResponse.toString();
        saveUid(decodedResponse.toString());
      });
    }
    return decodedResponse;
  }

  Future postLogin(String email, String password) async {
    var url = Uri.parse('${Globals.apiKey}LogIN?email=$email&Pass=$password');
    var data = {'email': email, 'Pass': password};
    var response = await http.post(url, body: data);
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse[0]['ID'] != '') {
      setState(() {
        Navigator.of(context).pushNamed('home_page');
        Globals.userID = decodedResponse[0]['ID'].toString();
        saveUid(decodedResponse[0]['ID'].toString());
      });
      return decodedResponse;
    }
  }

  // saveUserCredintials(String id, String name, String lName, String email,
  //     String endDate) async {
  //   SharedPreferences shared = await SharedPreferences.getInstance();
  //   shared.setString('user_id', id);
  //   shared.setString('user_name', name);
  //   shared.setString('user_lName', lName);
  //   shared.setString('user_email', email);
  //   shared.setString('profile_endDate', endDate);
  // }

  @override
  void initState() {
    _pagecontroller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _fController.dispose();
    _lController.dispose();
    _eController.dispose();
    _passController.dispose();
    _repassController.dispose();
    //----------
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('regLog_page');
          return true;
        },
        child: Container(
          margin: EdgeInsets.only(top: 20),
          color: Colors.black,
          child: buildPageView(),
        ),
      ),
      // bottomNavigationBar: buildBottomAppBar(),
      // floatingActionButton: buildFloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PageView buildPageView() {
    return PageView(
      controller: _pagecontroller,
      scrollDirection: Axis.vertical,
      children: [buildRegisterPageView(), buildLoginPageView()],
    );
  }

  ListView buildRegisterPageView() {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Register'.tr(),
                style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.lightBlue.withOpacity(0.6))),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    if (_pagecontroller.hasClients) {
                      _pagecontroller.animateToPage(1,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_right,
                    color: Colors.lightBlue.withOpacity(0.6),
                    size: 40,
                  )),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 36, horizontal: 21),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white,
                Colors.white30,
                Colors.white54,
                Colors.white70
              ]),
              borderRadius: BorderRadius.circular(25)),
          child: buildRegisterForm(),
        ),
        // Register Button start.
        InkWell(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.lightBlue.withOpacity(0.3),
                  Colors.lightBlue.withOpacity(0.5),
                  Colors.lightBlue.withOpacity(0.8),
                  Colors.lightBlue
                ]),
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Register'.tr(),
                  style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Typicons.user_add,
                  color: Colors.black,
                )
              ],
            ),
          ),
          onTap: () {
            if (_fController.text != '' &&
                _lController.text != '' &&
                _eController.text != '' &&
                _passController.text != '' &&
                _repassController.text != '' &&
                _repassController.text == _passController.text &&
                _eController.text.contains('@') &&
                _passController.text.length >= 3) {
              postRegister(_fController.text.trim(), _lController.text.trim(),
                  _eController.text.trim(), _passController.text.trim());
            }
          },
        ),
        // register Button end.
      ],
    );
  }

  ListView buildLoginPageView() {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Login'.tr(),
                style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.lightBlue)),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    if (_pagecontroller.hasClients) {
                      _pagecontroller.animateToPage(0,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_right,
                    color: Colors.lightBlue,
                    size: 40,
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email'.tr(),
                  hintText: 'Email'.tr(),
                  filled: true,
                  fillColor: Colors.lightBlue,
                  prefixIcon: Icon(Typicons.mail),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'PasWord'.tr(),
                  hintText: 'PasWord'.tr(),
                  filled: true,
                  fillColor: Colors.lightBlue,
                  prefixIcon: Icon(Icons.password),
                ),
              ),
            ],
          )),
        ),
        InkWell(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.lightBlue.withOpacity(0.3),
                  Colors.lightBlue.withOpacity(0.5),
                  Colors.lightBlue.withOpacity(0.8),
                  Colors.lightBlue
                ]),
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Login'.tr(),
                  style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.login,
                  color: Colors.black,
                )
              ],
            ),
          ),
          onTap: () {
            if (_emailController.text != '' &&
                _passwordController.text != '' &&
                _emailController.text.contains('@') &&
                _passwordController.text.length >= 3) {
              postLogin(_emailController.text.trim(),
                  _passwordController.text.trim());
            }
          },
        ),
        // login Button end.
      ],
    );
  }

  Form buildRegisterForm() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextFormField(
            controller: _fController,
            decoration: InputDecoration(
              labelText: 'FirstName'.tr(),
              hintText: 'FirstName'.tr(),
              filled: true,
              fillColor: Colors.lightBlue,
              prefixIcon: Icon(Typicons.user),
            ),
          ),
          TextFormField(
            controller: _lController,
            decoration: InputDecoration(
              labelText: 'LastName'.tr(),
              hintText: 'LastName'.tr(),
              filled: true,
              fillColor: Colors.lightBlue,
              prefixIcon: Icon(Typicons.user),
            ),
          ),
          TextFormField(
            controller: _eController,
            decoration: InputDecoration(
              labelText: 'Email'.tr(),
              hintText: 'Email'.tr(),
              filled: true,
              fillColor: Colors.lightBlue,
              prefixIcon: Icon(Typicons.mail),
            ),
          ),
          TextFormField(
            controller: _passController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'PasWord'.tr(),
              hintText: 'PasWord'.tr(),
              filled: true,
              fillColor: Colors.lightBlue,
              prefixIcon: Icon(Icons.password),
            ),
          ),
          TextFormField(
            obscureText: true,
            controller: _repassController,
            decoration: InputDecoration(
              labelText: 'RePassWord'.tr(),
              hintText: 'RePassWord'.tr(),
              filled: true,
              fillColor: Colors.lightBlue,
              prefixIcon: Icon(Icons.password),
            ),
          )
        ],
      ),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.lightBlue.withOpacity(0.6),
      child: Container(
        height: 50,
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    // print('the page view index ' + page.toString());
    return FloatingActionButton(
      child: Text(
        'reset password'.tr(),
        style: GoogleFonts.cairo(
            textStyle: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: Colors.grey[560])),
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        // Navigate to reset passwowd.
      },
    );
  }
}
