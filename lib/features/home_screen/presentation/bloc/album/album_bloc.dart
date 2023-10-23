import 'dart:convert';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
import '../../../data/models/album.dart';

part 'album_event.dart';

part 'album_state.dart';

const int _albumLimit = 10;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  AlbumBloc({required this.httpClient}) : super(const AlbumState()) {
    on<AlbumFetched>(
      _onAlbumFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onAlbumFetched(
    AlbumFetched event,
    Emitter<AlbumState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == AlbumStatus.initial) {
        final albums = await _fetchAlbums();
        return emit(
          state.copyWith(
            status: AlbumStatus.success,
            albums: albums,
            hasReachedMax: false,
          ),
        );
      }
      final albums = await _fetchAlbums(state.albums.length);
      albums.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: AlbumStatus.success,
                albums: List.of(state.albums)..addAll(albums),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: AlbumStatus.failure));
    }
  }

  Future<List<AlbumModel>> _fetchAlbums([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/photos',
        <String, dynamic>{'_start': '$startIndex', '_limit': '$_albumLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final Map<String, dynamic> map = json as Map<String, dynamic>;
        return AlbumModel(
          albumId: map['albumId'] as int,
          id: map['id'] as int,
          title: map['title'] as String,
          url: map['url'] as String,
          thumbnailUrl: map['thumbnailUrl'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching albums');
  }

}
