import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:islamic_calt/helpers/globals.dart';

class SearchedList extends StatefulWidget {
  @override
  _SearchedListState createState() => _SearchedListState();
}

class _SearchedListState extends State<SearchedList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Searched data'.tr(),
          style: GoogleFonts.cairo(
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('movies_page');
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
              margin: EdgeInsets.only(top: 30),
              color: Colors.indigo.withOpacity(0.3),
              child: ListTile(
                title: Text(
                  (Globals.msID == 'm') ? Globals.mvName : Globals.svName,
                  style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pushNamed('vedio_player');
                    setState(() {
                      Globals.searchID = (Globals.msID == 'm') ? 'mID' : 'sID';
                      Globals.m_id = Globals.movieID;
                      Globals.sID = Globals.seriesID;
                    });
                  });
                  // show the vedio url depend on the url passed by the search api's
                },
              ),
            ),
          ],
        )));
  }
}
