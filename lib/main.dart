import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ytvideos/api.dart';
import 'package:flutter_ytvideos/blocs/favorite_bloc.dart';
import 'package:flutter_ytvideos/blocs/videos_bloc.dart';
import 'package:flutter_ytvideos/screens/home_screen.dart';

void main() {
  Api api = Api();
  api.search("abcd");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get dependencies => null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: MaterialApp(
          title: 'Flutter YtVideos',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Home(),
        ),
        blocs: [
          Bloc((i) => VideosBloc()),
          Bloc((i) => FavoriteBloc()),
        ],
        dependencies: [
          Dependency((i) => VideosBloc()),
          Dependency((i) => FavoriteBloc()),
        ]);
  }
}
