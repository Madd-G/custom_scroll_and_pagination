import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:custom_scroll_and_pagination/features/home_screen/data/models/photo.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'photo_event.dart';

part 'photo_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc({required this.httpClient}) : super(const PhotoState()) {
    on<PhotoFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
    PhotoFetched event,
    Emitter<PhotoState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PhotoStatus.initial) {
        final photos = await _fetchPhotos();
        return emit(
          state.copyWith(
            status: PhotoStatus.success,
            photos: photos,
            hasReachedMax: false,
          ),
        );
      }
      final photos = await _fetchPhotos(state.photos.length);
      photos.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PhotoStatus.success,
                photos: List.of(state.photos)..addAll(photos),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: PhotoStatus.failure));
    }
  }

  Future<List<PhotoModel>> _fetchPhotos([int startIndex = 0]) async {
    var subreddit = 'EarthPorn';
    var headers = {'Authorization': 'Client-ID 2c58e7716198f00'};
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'https://api.imgur.com/3/gallery/r/$subreddit?_startIndex=1&_limit=$_postLimit'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await http.Response.fromStream(response)
          .then((value) => jsonDecode(value.body));
      var data = result["data"];
      return List.from(data.map(
          (e) => PhotoModel(id: e['id'], title: e['title'], link: e['link'])));
    }
    throw Exception('error fetching photos');
  }
}
