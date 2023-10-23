part of 'album_bloc.dart';

sealed class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

final class AlbumFetched extends AlbumEvent {}
