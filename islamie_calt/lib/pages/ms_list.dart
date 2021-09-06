import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/globals.dart';

class MSList extends StatefulWidget {
  @override
  _MSListState createState() => _MSListState();
}

class _MSListState extends State<MSList> {
  Future getMSData() async {
    var url = Uri.parse(
        '${Globals.apiKey}GetMSData?GenID=${Globals.genreID}'); // Globals.genreID instead of 1
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Genre List'.tr(),
          style: GoogleFonts.cairo(
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('home_page');
          },
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 30,
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(0, 43, 139, 0.6),
      ),
      body: buildHomeContainer(),
    );
  }

  Container buildHomeContainer() {
    return Container(
      color: Colors.black,
      child: SafeArea(
          child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            margin: EdgeInsets.symmetric(vertical: 20),
            child: FutureBuilder(
              future: getMSData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Card(
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.lightBlue.withOpacity(0.3),
                                Colors.lightBlue.withOpacity(0.5),
                                Colors.lightBlue.withOpacity(0.7),
                                Colors.lightBlue.withOpacity(0.85),
                              ])),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.lightBlueAccent.withOpacity(0.4),
                                    Colors.lightBlueAccent.withOpacity(0.6),
                                    Colors.lightBlueAccent.withOpacity(0.8),
                                  ]),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.elliptical(40, 40),
                                    topRight: Radius.elliptical(40, 40),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(snapshot.data[index]['MovName'],
                                      style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blueGrey[546]))),
                                  subtitle: Text('Movie',
                                      style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blueGrey[546]))),
                                  onTap: () {
                                    Globals.mvUrl = snapshot.data[index]
                                            ['MovURL']
                                        .toString();
                                    Navigator.of(context)
                                        .pushNamed('genre_vedio_player');
                                  },
                                ),
                              ),
                            ),
                          ),
                          /* Card(
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.lightBlue.withOpacity(0.3),
                                  Colors.lightBlue.withOpacity(0.5),
                                  Colors.lightBlue.withOpacity(0.7),
                                  Colors.lightBlue.withOpacity(0.85),
                                ]),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.elliptical(40, 40),
                                  topRight: Radius.elliptical(40, 40),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                    snapshot.data[index][
                                        'MovName'], // change it to series name if exists
                                    style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blueGrey[546]))),
                                subtitle: Text('Series',
                                    style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blueGrey[546]))),
                                onTap: () {
                                  Globals.svUrl =
                                      snapshot.data[index]['SerURL'];
                                  Navigator.of(context)
                                      .pushNamed('vedio_player_extra');
                                },
                              ),
                            ),
                          ),*/
                        ],
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
