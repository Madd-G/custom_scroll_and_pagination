import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_scroll_and_pagination/features/home_screen/presentation/bloc/album/album_bloc.dart';
import 'package:custom_scroll_and_pagination/features/home_screen/presentation/screen/home_screen/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          // controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              stretch: true,
              backgroundColor: Colors.white,
              expandedHeight: 300.0,
              flexibleSpace: FlexibleSpaceBar(background: Header()),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(160.0), child: Carousel()),
            ),
            SliverFillRemaining(
              child: AlbumContent(),
            ),
            // AlbumSliverGrid(
            //   state: state,
            // )
            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 1000,
            //     child: AlbumContent(
            //       albumList: state.albums,
            //       state: state,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      floatingActionButton: ActionButton(),
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

class AlbumSliverGrid extends StatefulWidget {
  const AlbumSliverGrid({
    super.key,
    required this.state,
  });

  final AlbumState state;

  @override
  State<AlbumSliverGrid> createState() => _AlbumSliverGridState();
}

class _AlbumSliverGridState extends State<AlbumSliverGrid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _scrollController,
      child: SliverGrid(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        delegate: SliverChildBuilderDelegate(
          childCount: widget.state.hasReachedMax
              ? widget.state.albums.length
              : widget.state.albums.length + 1,
          (context, index) {
            // context.read<AlbumBloc>().add(AlbumFetched());
            return index >= widget.state.albums.length
                ? const BottomLoader()
                : Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      // height: 150 + random.nextInt(200).toDouble(),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[100]!,
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.state.albums[index].url!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(widget.state.albums[index].id.toString()),
                    ),
                  );
          },
        ),
      ),
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
