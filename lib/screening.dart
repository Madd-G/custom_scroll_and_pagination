import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'features/home_screen/presentation/bloc/album/album_bloc.dart';
import 'features/home_screen/presentation/screen/home_screen/widgets/widgets.dart';

class ScreeningScreen extends StatefulWidget {
  const ScreeningScreen({Key? key}) : super(key: key);

  @override
  State<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                elevation: 0.0,
                pinned: true,
                stretch: true,
                floating: true,
                snap: true,
                backgroundColor: Colors.white,
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(background: Header()),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(220.0),
                  child: Carousel(),
                ),
              ),
            ];
          },
          body: BlocBuilder<AlbumBloc, AlbumState>(
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
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 12.0,
                      right: 20.0,
                    ),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          if (notification.metrics.pixels ==
                              notification.metrics.maxScrollExtent) {
                            context.read<AlbumBloc>().add(AlbumFetched());
                            return true;
                          }
                        }
                        return true;
                      },
                      child: MasonryGridView.builder(
                        mainAxisSpacing: 15.0,
                        crossAxisSpacing: 15.0,
                        itemCount: state.hasReachedMax
                            ? state.albums.length
                            : state.albums.length + 1,
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
                    ),
                  );
              }
            },
          ),
        ),
      ),
      floatingActionButton: const ActionButton(),
    );
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
