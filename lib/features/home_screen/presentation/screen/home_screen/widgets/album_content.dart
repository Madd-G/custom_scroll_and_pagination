import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../bloc/album/album_bloc.dart';

class AlbumContent extends StatefulWidget {
  const AlbumContent({
    super.key,
  });

  @override
  State<AlbumContent> createState() => _AlbumContentState();
}

class _AlbumContentState extends State<AlbumContent> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        switch (state.status) {
          case AlbumStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case AlbumStatus.failure:
            return const Center(child: Text('failed to fetch albums'));
          case AlbumStatus.success:
            if (state.albums.isEmpty) {
              return const Center(child: Text('no albums'));
            }
            return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 12.0, right: 20.0),
              child: MasonryGridView.builder(
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.albums.length
                    : state.albums.length + 1,
                // physics:const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  Random random = Random();
                  return index >= state.albums.length
                      ? const BottomLoader()
                      : Container(
                          height: 100 + random.nextInt(200).toDouble(),
                          decoration: BoxDecoration(
                            color: Colors.grey[100]!,
                            borderRadius: BorderRadius.circular(7.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                state.albums[index].url!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                },
              ),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<AlbumBloc>().add(AlbumFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 1.5),
    );
  }
}
