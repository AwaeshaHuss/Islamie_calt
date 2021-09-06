import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_calt/helpers/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowPage extends StatefulWidget {
  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  PageController _controller = PageController();

  Future getMList() async {
    var id = Globals.ch_id;
    var url = (id != '')
        ? Uri.parse('${Globals.apiKey}GetVideoDetails?chid=${id}')
        : Uri.parse('${Globals.apiKey}GetVideoDetails?chid=1');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future getDetails() async {
    var ch_id = Globals.ch_id;
    var m_id = Globals.m_id;
    String url = (ch_id != '' && m_id != '')
        ? ('${Globals.apiKey}GetVideoDetailswhereid?chid=${Globals.ch_id}&&movieid=${Globals.m_id}')
        : ('${Globals.apiKey}GetVideoDetailswhereid?chid=1&&movieid=1');
    var response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Future getSList() async {
    var id = Globals.sID;
    var url = (id != '')
        ? Uri.parse('${Globals.apiKey}GetSeriesEpisodList?serid=${id}')
        : Uri.parse('${Globals.apiKey}GetSeriesEpisodList?serid=1');
    var response = await http.get(url);
    var response_body = jsonDecode(response.body);
    // Globals.evUrl = response_body[0]['VideoURL'];
    return response_body;
  }

  @override
  void initState() {
    // print('the selected channel id ' + Globals.ch_id);
    // print('the selected movie id' + Globals.m_id);
    if (Globals.msID == 'm') {
      // if the parent route (pre page)
      _controller = PageController(initialPage: 0);
      Globals.msID = '';
    } else if (Globals.msID == 's') {
      _controller = PageController(initialPage: 1);
      Globals.msID = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: (Platform.isAndroid)
          ? null
          : AppBar(
              title: Text(
                'ShowPage'.tr(),
                style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pushNamed('movies_page'),
                icon: Icon(Icons.arrow_back),
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Color.fromRGBO(0, 43, 139, 0.6),
            ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, 'movies_page');
          return true;
        },
        child: Container(
          color: Colors.black,
          child: PageView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            children: [
              ListView(
                // Page 0 is The Movies Page
                children: [
                  buildMContainerTitle(),
                  buildMImgContainer(),
                  buildMDiscreptionContainer(),
                  buildMListBuilderContainer()
                ],
              ), // Create Page 1 For The Series
              ListView(
                children: [
                  buildSContainerTitle(),
                  buildSImgContainer(),
                  buildSDiscriptionContainer(),
                  buildSListBuilderContainer()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildSContainerTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      // child: InkWell( // for testing purposes
      child: Text(
        'Series'.tr(),
        style: GoogleFonts.cairo(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600])),
        textAlign: TextAlign.center,
      ),
      // onTap: () => Navigator.of(context).pushNamed('vedio_player'),
      //  ),
    );
  }

  Container buildMContainerTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        'Movies'.tr(),
        style: GoogleFonts.cairo(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600])),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container buildMListBuilderContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: FutureBuilder(
        future: getMList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 5,
                  child: Container(
                    color: Colors.black87,
                    child: ListTile(
                      trailing: CachedNetworkImage(
                        imageUrl: Globals.imageUrl +
                            snapshot.data[index]['Image_Name'],
                        placeholder: (context, url) =>
                            Image.asset('assets/imgs/logo.png'),
                        errorWidget: (context, url, error) => Icon(Icons.image),
                      ),
                      title: Text(
                        snapshot.data[index]['Name'] ?? '',
                        style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey)),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('vedio_player');
                        Globals.msID = 'm';
                        Globals.mvName = snapshot.data[index]['Name'];
                        // Globals.mvDiscreption = snapshot.data[index]['Details'];
                        // Globals.mvUrl = snapshot.data[index]['VideoURL'];
                      },
                      dense: true,
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey[600],
              backgroundColor: Colors.black54,
              strokeWidth: 5,
            ),
          );
        },
      ),
    );
  }

  Container buildMDiscreptionContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: FutureBuilder(
        future: getDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    snapshot.data[0]['Name'] ?? '',
                    style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    snapshot.data[0]['Details'] ?? '',
                    style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey[600],
              backgroundColor: Colors.black54,
              strokeWidth: 5,
            ),
          );
        },
      ),
    );
  }

  Container buildMImgContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: FutureBuilder(
        future: getDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              child: CachedNetworkImage(
                imageUrl: Globals.imageUrl + snapshot.data[0]['Image_Name'],
                placeholder: (context, url) =>
                    Image.asset('assets/imgs/logo.png'),
                errorWidget: (context, url, error) => Icon(Icons.image),
                fit: BoxFit.cover,
              ),
              onTap: () {
                // Navigator.of(context).pushNamed('vedio_player');
                // Globals.msID = 'm';
                // Globals.mvUrl = snapshot.data[0]['VideoURL'];
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey[600],
              backgroundColor: Colors.black54,
              strokeWidth: 5,
            ),
          );
        },
      ),
    );
  }

  Container buildSImgContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: CachedNetworkImage(
        imageUrl: Globals.svImgUrl,
        placeholder: (context, url) => Image.asset('assets/imgs/logo.png'),
        errorWidget: (context, url, error) => Icon(Icons.image),
        fit: BoxFit.cover,
      ),
    );
  }

  Container buildSDiscriptionContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              Globals.svTitleUrl.toString(),
              style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey)),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              Globals.svDiscreptionUrl.toString(),
              style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Container buildSListBuilderContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: FutureBuilder(
        future: getSList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 5,
                  child: Container(
                    color: Colors.black87,
                    child: ListTile(
                      trailing: CachedNetworkImage(
                        imageUrl: Globals.imageUrl +
                            snapshot.data[index]['ImagrName'],
                        placeholder: (context, url) =>
                            Image.asset('assets/imgs/logo.png'),
                        errorWidget: (context, url, error) => Icon(Icons.image),
                      ),
                      title: Text(
                        snapshot.data[index]['Name'] ?? '',
                        style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey)),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('vedio_player');
                        Globals.msID = 's';
                        Globals.svName = snapshot.data[index]['Name'];
                        // Globals.evUrl = snapshot.data[index]['VideoURL'];
                        Globals.sID = snapshot.data[index]['ID'].toString();
                      },
                      dense: true,
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey[600],
              backgroundColor: Colors.black54,
              strokeWidth: 5,
            ),
          );
        },
      ),
    );
  }
}

/*

(snapShot.data[index]['ImagrName'] !=
                              null) // change 2 to 0 if 2 is not working
                          ? Image.network(Globals.imageUrl +
                              snapShot.data[index]['ImagrName'])
                          : Image.asset('assets/imgs/logo.png'),

 */
