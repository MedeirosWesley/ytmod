import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ytvideos/blocs/favorite_bloc.dart';
import 'package:flutter_ytvideos/blocs/videos_bloc.dart';
import 'package:flutter_ytvideos/delegate/data_search.dart';
import 'package:flutter_ytvideos/models/video.dart';
import 'package:flutter_ytvideos/screens/favorites_screen.dart';
import 'package:flutter_ytvideos/widgets/video_tile.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/YouTube_Logo.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Align(
              alignment: Alignment.center,
              child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.length}",
                      style: TextStyle(color: Colors.black),
                    );
                  } else {
                    return Container();
                  }
                },
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Favorites(),
                ));
              },
              icon: Icon(
                Icons.star,
                color: Colors.grey[900],
              )),
          IconButton(
              onPressed: () async {
                String? result =
                    await showSearch(context: context, delegate: DataSearch());
                if (result != null) {
                  BlocProvider.getBloc<VideosBloc>().inSearch.add(result);
                }
              },
              icon: Icon(Icons.search, color: Colors.grey[900])),
        ],
      ),
      body: StreamBuilder(
        stream: BlocProvider.getBloc<VideosBloc>().outVideos,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(
                    video: snapshot.data[index],
                  );
                } else if (index > 1) {
                  BlocProvider.getBloc<VideosBloc>().inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else
            return Container();
        },
      ),
    );
  }
}
