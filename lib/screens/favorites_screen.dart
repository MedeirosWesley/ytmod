import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ytvideos/blocs/favorite_bloc.dart';
import 'package:flutter_ytvideos/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Favorites extends StatelessWidget {
  Favorites({Key? key}) : super(key: key);

  final bloc = BlocProvider.getBloc<FavoriteBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(1),
          child: Image.asset(
            "images/youtube-shortLogo.png",
            fit: BoxFit.contain,
            scale: 0.1,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Favoritos",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        initialData: {},
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data!.values.map((v) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: InkWell(
                  onTap: () {
                    String videoId;
                    videoId = YoutubePlayer.convertUrlToId(v.id)!;
                    YoutubePlayerController _controller =
                        YoutubePlayerController(
                      initialVideoId: videoId,
                      flags: const YoutubePlayerFlags(
                        autoPlay: true,
                        mute: true,
                      ),
                    );

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _controller,
                        ),
                        builder: (context, player) {
                          return Container(
                            child: player,
                          );
                        },
                      ),
                    ));
                  },
                  onLongPress: () {
                    bloc.toggleFavorite(v);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 100.0,
                        height: 50.0,
                        child: Image.network(v.thumb),
                      ),
                      Expanded(
                          child: Text(
                        v.title,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ))
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
