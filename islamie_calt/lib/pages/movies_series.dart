import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:islamic_calt/helpers/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  PageController _controller = PageController();
  TextEditingController _msearchController = TextEditingController();
  TextEditingController _ssearchController = TextEditingController();
  Future getSeriesData() async {
    var id = Globals.ch_id;
    var url = Uri.parse('${Globals.apiKey}GetSeries?chid=${id}');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future getMoviesData() async {
    var id = Globals.ch_id;
    var url = Uri.parse('${Globals.apiKey}GetVideoDetails?chid=${id}');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future getMovieSearched(String title) async {
    var id = Globals.ch_id;
    var url =
        Uri.parse('${Globals.apiKey}GetMovieBySearch?chid=$id&&title=$title');
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    if (responseBody != null) {
      // Fill The Movie Globals With The ResponseBody & Navigate To SearchedList
      setState(() {
        Globals.mvName = responseBody[0]['Name'];
        Globals.movieID = responseBody[0]['ID'];
      });
    }
    return responseBody;
  }

  Future getSeriesSearched(String title) async {
    var id = Globals.ch_id;
    var url =
        Uri.parse('${Globals.apiKey}GetSeriesBySearch?chid=$id&&title=$title');
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    if (responseBody != null) {
      // Fill The Movie Globals With The ResponseBody & Navigate To SearchedList
      setState(() {
        Globals.svName = responseBody[0]['Name'];
        Globals.seriesID = responseBody[0]['ID'];
      });
    }
    return responseBody;
  }

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _msearchController.dispose();
    _ssearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, 'home_page');
          return true;
        },
        child: Container(
          color: Colors.black,
          child: PageView(
            controller: _controller,
            children: [
              ListView(
                children: [
                  buildMtitleContainer(),
                  buildMdataContainer(),
                ],
              ),
              ListView(
                children: [
                  buildStitleContainer(),
                  buildSdataContainer(),
                ],
              )
            ],
          ),
        ));
  }

  Container buildSdataContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      child: FutureBuilder(
          future: getSeriesData(),
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            if (snapShot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.27,
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.all(8),
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: snapShot.data.length,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                          child: Card(
                            child: Container(
                              color: Colors.black,
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: (snapShot.data[index]
                                                  ['ImageName'] !=
                                              null)
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.23,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: Globals.imageUrl +
                                                    snapShot.data[index]
                                                        ['ImageName'],
                                                placeholder: (snapShot
                                                                .data[index]
                                                            ['ImageName'] !=
                                                        null)
                                                    ? (context, url) =>
                                                        Image.asset(
                                                            'assets/imgs/logo.png')
                                                    : null,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            )
                                          : Image.asset(
                                              'assets/imgs/logo.png')),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    snapShot.data[index]["Name"],
                                    style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blueGrey)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('show_page');
                            Globals.msID = 's';
                            //Connect the series globals
                            Globals.svImgUrl = Globals.imageUrl +
                                snapShot.data[index]['ImageName'];
                            Globals.svTitleUrl = snapShot.data[index]['Name'];
                            Globals.svDiscreptionUrl =
                                snapShot.data[index]['Details'];
                            Globals.sID = snapShot.data[index]['ID'].toString();
                          });
                    }),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
                backgroundColor: Colors.black45,
              ),
            );
          }),
    );
  }

  Container buildStitleContainer() {
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // search dialog start
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('search'.tr()),
                          content: Form(
                              child: TextFormField(
                            controller: _ssearchController,
                            decoration: InputDecoration(
                              labelText: 'search'.tr(),
                              hintText: 'Enter the Title'.tr(),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.title),
                            ),
                          )),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  // perform the search action api Navigate to page filled with the movie title or series title
                                  if (!_ssearchController.text.isEmpty) {
                                    getSeriesSearched(
                                        _ssearchController.text.trim());
                                    Future.delayed(Duration(milliseconds: 1500),
                                        () {
                                      setState(() {
                                        Navigator.of(context)
                                            .pushNamed('searched_list');
                                        Globals.msID = 's';
                                      });
                                    });
                                  }
                                },
                                child: Text('search'.tr())),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Series'.tr()))
                          ],
                        );
                      });
                },
                icon: Icon(Icons.search,
                    color: Colors.blueGrey)), // search Dialog end
            Text(
              'Series'.tr(),
              style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueGrey)),
              textAlign: TextAlign.center,
            ),
            IconButton(
                onPressed: () {
                  if (_controller.hasClients) {
                    _controller.animateToPage(0,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut);
                  }
                },
                icon: Icon(Icons.arrow_left, color: Colors.blueGrey))
          ],
        ));
  }

  Container buildMdataContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      child: FutureBuilder(
          future: getMoviesData(),
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            if (snapShot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.27,
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.all(8),
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: snapShot.data.length,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                          child: Card(
                            child: Container(
                              color: Colors.black,
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: (snapShot.data[index]
                                                  ['Image_Name'] !=
                                              null)
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.23,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: Globals.imageUrl +
                                                    snapShot.data[index]
                                                        ['Image_Name'],
                                                placeholder: (snapShot
                                                                .data[index]
                                                            ['Image_Name'] !=
                                                        null)
                                                    ? (context, url) =>
                                                        Image.asset(
                                                            'assets/imgs/logo.png')
                                                    : null,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            )
                                          : Image.asset(
                                              'assets/imgs/logo.png')),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    snapShot.data[index]["Name"],
                                    style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blueGrey)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('show_page');
                            Globals.msID = 'm';
                            Globals.m_id =
                                snapShot.data[index]['ID'].toString();
                            // Globals.mvTitleUrl = snapShot.data[index]['Name'];
                            // Globals.mvDiscreptionUrl =
                            //     snapShot.data[index]['Details'];
                            // Globals.mvDurationUrl =
                            //     snapShot.data[index]['MovieTime'];
                            // Globals.mvImgUrl = Globals.imageUrl +
                            //     snapShot.data[index]['Image_Name'];
                            // Globals.cachedImg =
                            //     snapShot.data[index]['Image_Name'];
                            // Globals.mvUrl = snapShot.data[index]['VideoURL'];
                          });
                    }),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
                backgroundColor: Colors.black45,
              ),
            );
          }),
    );
  }

  Container buildMtitleContainer() {
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // search dialog start
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('search'.tr()),
                          content: Form(
                              child: TextFormField(
                            controller: _msearchController,
                            decoration: InputDecoration(
                              labelText: 'search'.tr(),
                              hintText: 'Enter the Title'.tr(),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.title),
                            ),
                          )),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  // perform the search action api Navigate to page filled with the movie title or series title
                                  if (!_msearchController.text.isEmpty) {
                                    getMovieSearched(
                                        _msearchController.text.trim());
                                    Future.delayed(Duration(milliseconds: 1500),
                                        () {
                                      setState(() {
                                        Navigator.of(context)
                                            .pushNamed('searched_list');
                                        Globals.msID = 'm';
                                      });
                                    });
                                  }
                                },
                                child: Text('search'.tr())),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Movies'.tr()))
                          ],
                        );
                      });
                },
                icon: Icon(Icons.search,
                    color: Colors.blueGrey)), // search Dialog end
            Text(
              'Movies'.tr(),
              style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueGrey)),
              textAlign: TextAlign.center,
            ),
            IconButton(
                onPressed: () {
                  if (_controller.hasClients) {
                    _controller.animateToPage(1,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut);
                  }
                },
                icon: Icon(Icons.arrow_right, color: Colors.blueGrey))
          ],
        ));
  }
}
