import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../helpers/globals.dart';

class GenreVedioPlayer extends StatefulWidget {
  @override
  _GenreVedioPlayerState createState() => _GenreVedioPlayerState();
}

class _GenreVedioPlayerState extends State<GenreVedioPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VedioPlayer'.tr()),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('ms_page');
          },
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 30,
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(0, 43, 139, 0.6),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          Globals.videoUrl + Globals.mvUrl.substring(1).substring(1),
          betterPlayerConfiguration: BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }
}
