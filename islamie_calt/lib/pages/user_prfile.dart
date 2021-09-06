import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/globals.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future getUserCredintials() async {
    var url = (Globals.userID.toString() != '')
        ? Uri.parse(
            '${Globals.apiKey}GetUserDateWID?userid=${Globals.userID.toString()}')
        : Uri.parse('${Globals.apiKey}GetUserDateWID?userid=2');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: ListView(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'User Profile'.tr(),
                  style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey)),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('home_page');
                    },
                    icon: Icon(Icons.arrow_right, color: Colors.blueGrey)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            // margin: EdgeInsets.only(top: 10),
            color: Colors.transparent,
            child: Stack(
              // clipBehavior: Clip.none,
              // overflow: Overflow.visible,
              // alignment: Alignment.topRight,
              fit: StackFit.loose,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.lightBlue.withOpacity(0.4),
                      Colors.lightBlue.withOpacity(0.5),
                      Colors.lightBlue.withOpacity(0.6),
                      Colors.lightBlue.withOpacity(0.7),
                    ]),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(70),
                      topLeft: Radius.circular(70),
                    ),
                  ),
                  child: FutureBuilder(
                    future: getUserCredintials(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 80),
                              child: Card(
                                elevation: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlue.withOpacity(0.7),
                                      Colors.lightBlue.withOpacity(0.8),
                                      Colors.lightBlue.withOpacity(0.8),
                                      Colors.lightBlue.withOpacity(0.9),
                                    ]),
                                  ),
                                  child: ListTile(
                                    leading: Text(
                                      snapshot.data[0]['FirstName'] ?? '',
                                      style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Card(
                                elevation: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlue.withOpacity(0.7),
                                      Colors.lightBlue.withOpacity(0.8),
                                      Colors.lightBlue.withOpacity(0.8),
                                      Colors.lightBlue.withOpacity(0.9),
                                    ]),
                                  ),
                                  child: ListTile(
                                    leading: Text(
                                      snapshot.data[0]['LastName'] ?? '',
                                      style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Card(
                                elevation: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlue.withOpacity(0.7),
                                      Colors.lightBlue.withOpacity(0.8),
                                      Colors.lightBlue.withOpacity(0.8),
                                      Colors.lightBlue.withOpacity(0.9),
                                    ]),
                                  ),
                                  child: ListTile(
                                    leading: Text(
                                      snapshot.data[0]['Email'] ?? '',
                                      style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Card(
                                elevation: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.lightBlue.withOpacity(0.7),
                                      Colors.lightBlue.withOpacity(0.8),
                                      Colors.lightBlue.withOpacity(0.8),
                                      Colors.lightBlue.withOpacity(0.9),
                                    ]),
                                  ),
                                  child: ListTile(
                                    leading: Text(
                                      snapshot.data[0]['SubscriptionEndDate'] ??
                                          '',
                                      style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                width: 120,
                                margin: EdgeInsets.all(25),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.deepOrangeAccent.withOpacity(0.4),
                                    Colors.deepOrangeAccent.withOpacity(0.6),
                                    Colors.deepOrangeAccent.withOpacity(0.8),
                                  ]),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(70),
                                    topLeft: Radius.circular(70),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Logout'.tr(),
                                      style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                    Icon(Icons.exit_to_app, color: Colors.white)
                                  ],
                                ),
                              ),
                              onTap: () {
                                // Navigate to registerLogin Page
                                Navigator.of(context).pushNamed('regLog_page');
                              },
                            ),
                          ],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
