import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ytvideos/blocs/favorite_bloc.dart';
import 'package:flutter_ytvideos/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTile extends StatelessWidget {
  const VideoTile({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String videoId;
        videoId = YoutubePlayer.convertUrlToId(video.id)!;
        YoutubePlayerController _controller = YoutubePlayerController(
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                      child: Text(
                        video.title,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(video.channel,
                          style: const TextStyle(
                            fontSize: 16.0,
                          )),
                    ),
                  ],
                )),
                StreamBuilder<Map<String, Video>>(
                  initialData: {},
                  stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                          onPressed: () {
                            BlocProvider.getBloc<FavoriteBloc>()
                                .toggleFavorite(video);
                          },
                          icon: Icon(snapshot.data!.containsKey(video.id)
                              ? Icons.star
                              : Icons.star_border_outlined));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
