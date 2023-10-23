part of 'photo_bloc.dart';

enum PhotoStatus { initial, success, failure }

final class PhotoState extends Equatable {
  const PhotoState({
    this.status = PhotoStatus.initial,
    this.photos = const <PhotoModel>[],
    this.hasReachedMax = false,
  });

  final PhotoStatus status;
  final List<PhotoModel> photos;
  final bool hasReachedMax;

  PhotoState copyWith({
    PhotoStatus? status,
    List<PhotoModel>? photos,
    bool? hasReachedMax,
  }) {
    return PhotoState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, photos: ${photos.length} }''';
  }

  @override
  List<Object?> get props => [status, photos, hasReachedMax];
}

