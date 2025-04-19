import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:salon_user/app/env.dart';

class ImageGalleryScreen extends StatelessWidget {
  final List<String> gallery;
  final int initialIndex;

  const ImageGalleryScreen(
      {Key? key, required this.gallery, this.initialIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        itemCount: gallery.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                NetworkImage('${Environments.imageURL}${gallery[index]}'),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}

class GridGallery extends StatelessWidget {
  final List<String> gallery;

  const GridGallery({Key? key, required this.gallery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      childAspectRatio: 100 / 100,
      padding: EdgeInsets.zero,
      children: List.generate(
        gallery.length,
        (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageGalleryScreen(
                    gallery: gallery,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FadeInImage(
                  image:
                      NetworkImage('${Environments.imageURL}${gallery[index]}'),
                  placeholder:
                      const AssetImage("assets/images/placeholder.jpeg"),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/notfound.png',
                        fit: BoxFit.cover);
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
