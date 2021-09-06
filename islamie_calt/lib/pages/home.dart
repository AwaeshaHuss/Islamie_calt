import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:islamic_calt/helpers/globals.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _localeCode = 1;
  var result;

  Future getHomeData() async {
    var url = Uri.parse('${Globals.apiKey}GetChannels');
    // print('the api key for home is ${Globals.apiKey}GetChannels');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future getGenare() async {
    var url = Uri.parse('${Globals.apiKey}GetGenre');
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
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Islamic Culture'.tr(),
          style: GoogleFonts.cairo(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
        leading: IconButton(
            onPressed: () {
              saveLocale();
            },
            icon: Icon(Icons.language)),
        actions: [
          // user profile start
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('user_profile_page');
              },
              icon: Icon(Icons.person)), // user profile end
        ],
        elevation: 30,
        brightness: Brightness.dark,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(0, 43, 139, 0.6),
      ),
      body: WillPopScope(
        // this's an alternative for the onBackPressed in Android
        onWillPop: () async {
          buildShowDialog(context);
          return true;
        },
        child: buildSafeArea(),
      ),
    );
  }

  Widget buildSafeArea() {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: ListView(
          children: [
            // Genare Statrt
            Container(
              height: 100,
              margin: EdgeInsets.only(top: 20),
              child: FutureBuilder(
                future: getGenare(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 70,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.lightBlue.withOpacity(0.3),
                                  Colors.lightBlue.withOpacity(0.5),
                                  Colors.lightBlue.withOpacity(0.7),
                                  Colors.lightBlue.withOpacity(0.8),
                                ]),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                snapshot.data[index]['Name'],
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('ms_page');
                            Globals.genreID =
                                snapshot.data[index]['ID'].toString();
                          },
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueGrey.withOpacity(0.54),
                      backgroundColor: Colors.black,
                      strokeWidth: 5,
                    ),
                  );
                },
              ),
            ),
            // Genare End
            Container(
                child: FutureBuilder(
                    future: getHomeData(),
                    builder: (BuildContext context, AsyncSnapshot snapShot) {
                      if (snapShot.hasData) {
                        return buildChanelsContainer(context, snapShot);
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                          backgroundColor: Colors.black45,
                          strokeWidth: 5,
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  Container buildChanelsContainer(
      BuildContext context, AsyncSnapshot<dynamic> snapShot) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        physics: ScrollPhysics().parent,
        itemCount: snapShot.data.length,
        itemBuilder: (BuildContext context, int index) {
          // print(Globals.imageUrl + snapShot.data[index]['ImageID']);
          return Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(top: 20, left: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                gradient: LinearGradient(colors: [
                  Colors.lightBlue.withOpacity(0.2),
                  Colors.lightBlue.withOpacity(0.4),
                  Colors.lightBlue.withOpacity(0.6),
                  Colors.blue.withOpacity(0.4),
                  Colors.blue.withOpacity(0.6),
                ])),
            child: ListTile(
              trailing: CachedNetworkImage(
                imageUrl: Globals.imageUrl + snapShot.data[index]['ImageID'],
                placeholder: (snapShot.data[index]['ImageID'] != null)
                    ? (context, url) => Image.asset('assets/imgs/logo.png')
                    : null,
                errorWidget: (context, url, error) =>
                    Icon(Icons.image_not_supported),
              ),
              title: (snapShot.data[index]['Name'] != null)
                  ? Text(
                      snapShot.data[index]['Name'],
                      style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey)),
                    )
                  : Text(
                      'Name',
                      style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey)),
                    ),
              subtitle: (snapShot.data[index]['Language'] != null)
                  ? Text(
                      snapShot.data[index]['Language'],
                      style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey)),
                    )
                  : Text(
                      'Language',
                      style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey)),
                    ),
              onTap: () {
                Globals.ch_id = snapShot.data[index]['ID'].toString();
                Navigator.of(context).pushNamed('movies_page');
              },
              dense: true,
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blue.withOpacity(0.2),
              Colors.blue.withOpacity(0.3),
              Colors.blue.withOpacity(0.4),
              Colors.blue.withOpacity(0.5),
            ])),
            child: AlertDialog(
              backgroundColor: Colors.blue.withOpacity(0.3),
              title: Text(
                'Do you want to exit app'.tr(),
                style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              actions: [
                FlatButton(
                  child: Row(
                    children: [
                      Text(
                        'return to home'.tr(),
                        style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Expanded(
                          flex: 2, child: Icon(Icons.home, color: Colors.white))
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                // Opacity(opacity: 0.0, child: Container()),
                FlatButton(
                  child: Row(
                    children: [
                      Text(
                        'exit app!!'.tr(),
                        style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Expanded(
                          flex: 2,
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
              actionsPadding: EdgeInsets.all(10),
            ),
          );
        });
  }

  saveLocale() async {
    if (_localeCode == 1) {
      try {
        await EasyLocalization.of(context)?.setLocale(Locale('en', 'US'));
        _localeCode = 2;
      } catch (err) {}
    } else {
      try {
        await EasyLocalization.of(context)?.setLocale(Locale('ar', 'JO'));
        _localeCode = 1;
      } catch (err) {}
    }
  }

  checkConnection() async {
    try {
      result = await InternetAddress.lookup('https://google.com/');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // show the home page
      }
    } on SocketException catch (_) {}
  }
}
