import 'package:equatable/equatable.dart';

class AlbumModel extends Equatable {
  final int? albumId;
  final int? id;
  final String? title;
  final String? url;
  final String? thumbnailUrl;

  const AlbumModel(
      {required this.albumId,
      required this.id,
      required this.title,
      required this.url,
      required this.thumbnailUrl});

  @override
  List<Object?> get props => [albumId, id, title, url, thumbnailUrl];

  @override
  String toString() {
    return 'Album id: $albumId, id: $id title: $title, url: $url, thumbnailUrl: $thumbnailUrl';
  }
}
