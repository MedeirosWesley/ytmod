import 'dart:async';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ytvideos/models/video.dart';

import '../api.dart';

class VideosBloc implements BlocBase {
  Api? api;
  List<Video>? videos;

  final _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;
  final _searchController = StreamController<String?>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();

    _searchController.stream.listen((String? search) async {
      if (search != null) {
        _videosController.sink.add([]);
        videos = await api!.search(search);
      } else {
        videos = videos! + await api!.nextPage();
      }
      _videosController.sink.add(videos!);
    });
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(VoidCallback listener) {}
}
