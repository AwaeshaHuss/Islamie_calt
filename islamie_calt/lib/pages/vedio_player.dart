import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:better_player/better_player.dart';
import '../helpers/globals.dart';
/* import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/util/theme.util.dart';
import 'package:videos_player/videos_player.dart';
import 'package:videos_player/model/control.model.dart'; */

class VedioPlayer extends StatefulWidget {
  @override
  _VedioPlayerState createState() => _VedioPlayerState();
}

class _VedioPlayerState extends State<VedioPlayer> {
  // var _vUrl;
  String title = '';
  Future getVideo() async {
    var url;
    if (Globals.msID == 'm' && Globals.m_id != '') {
      url = Uri.parse(
          'http://moviesiptv.islamicott.com/GetVideoFile?typeid=1&&movieid=${Globals.m_id}');
      Globals.msID = '';
    } else if (Globals.msID == 's' && Globals.sID != '') {
      url = Uri.parse(
          'http://moviesiptv.islamicott.com/GetVideoFile?typeid=2&&movieid=${Globals.sID}');
      Globals.msID = '';
    }
    var response = await http.get(url);
    var response_body = jsonDecode(response.body);
    return response_body;
  }

  @override
  void initState() {
    setState(() {
      (Globals.msID == 'm') ? title = Globals.mvName : title = Globals.svName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Movie Player'.tr(),
            style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          leading: IconButton(
            onPressed: (Globals.searchID.isEmpty)
                ? () {
                    Navigator.of(context).pushNamed('show_page');
                  }
                : () {
                    Navigator.of(context).pushNamed('searched_list');
                    setState(() {
                      Globals.searchID = '';
                    });
                  },
            /*print('the video url assa' + Globals.mvUrl)*/
            icon: Icon(Icons.arrow_back),
          ),
          automaticallyImplyLeading: false,
          elevation: 30,
          brightness: Brightness.dark,
          backgroundColor: Color.fromRGBO(0, 43, 139, 0.6),
        ),
        body: ListView(
          children: [
            FutureBuilder(
              future: getVideo(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.error == null) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer.network(
                      Globals.videoUrl +
                          snapshot.data[0]['FilePath'].substring(1),
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                        aspectRatio: 16 / 9,
                      ),
                    ),
                  );
                }
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.blueGrey[600],
                  backgroundColor: Colors.black54,
                  strokeWidth: 5,
                ));
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 100),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey)),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
