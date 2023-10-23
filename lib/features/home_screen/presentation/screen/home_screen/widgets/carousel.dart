import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_scroll_and_pagination/features/home_screen/presentation/bloc/album/album_bloc.dart';

class Carousel extends StatefulWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;
  final int _initialContent = 1;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _initialContent, viewportFraction: 0.5);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  var _selectedIndex = 1;

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
              padding: const EdgeInsets.only(top: 30.0, bottom: 24.0),
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: 160.0,
                    child: PageView.builder(
                      onPageChanged: (index) {
                        setState(
                          () {
                            _selectedIndex = index;
                          },
                        );
                      },
                      itemCount: 10,
                      physics: const ClampingScrollPhysics(),
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        var carouselItem = state.albums[index];
                        var scale = _selectedIndex == index ? 1.0 : 0.73;
                        return TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 350),
                          tween: Tween(begin: scale, end: scale),
                          child: _selectedIndex == index
                              ? CarouselItemActive(carouselItem: carouselItem)
                              : CarouselItem(carouselItem: carouselItem),
                          builder: (BuildContext context, double value,
                              Widget? child) {
                            return Transform.scale(scale: value, child: child);
                          },
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 50.0,
                    child: Text(
                      '${_selectedIndex + 1} of 10',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF969696),
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.carouselItem,
  });

  final dynamic carouselItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      // child: CachedNetworkImage(
      //   imageUrl: carouselItem!.thumbnailUrl,
      //   progressIndicatorBuilder: (context, url, downloadProgress) =>
      //       CircularProgressIndicator(value: downloadProgress.progress),
      //   errorWidget: (context, url, error) => const Icon(Icons.error),
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(
            carouselItem!.thumbnailUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CarouselItemActive extends StatelessWidget {
  const CarouselItemActive({
    super.key,
    required this.carouselItem,
  });

  final dynamic carouselItem;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0XFFF89F1E),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110.0,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    carouselItem!.thumbnailUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              // child: CachedNetworkImage(
              //   imageUrl: carouselItem!.url,
              //   progressIndicatorBuilder: (context, url, downloadProgress) =>
              //       CircularProgressIndicator(value: downloadProgress.progress),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              // ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                carouselItem.title,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 11.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
