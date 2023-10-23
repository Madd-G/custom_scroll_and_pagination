import 'package:equatable/equatable.dart';

class PhotoModel extends Equatable {
  final String? id;
  final String? title;
  final String? link;

  const PhotoModel({
    required this.id,
    required this.title,
    required this.link,
  });

  @override
  List<Object?> get props => [id, title, link];

  @override
  String toString() {
    return 'Photo id: $id title: $title, url: $link';
  }
}
