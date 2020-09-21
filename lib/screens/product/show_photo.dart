import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ShowPhoto extends StatefulWidget {
  final List galleryItems;
  final int initialPhoto;
  ShowPhoto(this.galleryItems, this.initialPhoto);
  @override
  _ShowPhotoState createState() => _ShowPhotoState();
}

class _ShowPhotoState extends State<ShowPhoto> {
  @override
  Widget build(BuildContext context) {
    PageController _controller =
        PageController(initialPage: widget.initialPhoto);
    return Dismissible(
      direction: DismissDirection.down,
      resizeDuration: Duration(milliseconds: 1),
      movementDuration: Duration(milliseconds: 1),
      key: UniqueKey(),
      onDismissed: (_) {
        Navigator.pop(context);
      },
      child: Container(
        child: Scaffold(
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                pageController: _controller,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider:
                        CachedNetworkImageProvider(widget.galleryItems[index]),
                    initialScale: PhotoViewComputedScale.contained * 1.0,
                    minScale: PhotoViewComputedScale.contained * 1.0,
                    maxScale: PhotoViewComputedScale.contained * 3.0,
                  );
                },
                itemCount: widget.galleryItems.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes,
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 5.0, top: MediaQuery.of(context).padding.top),
                child: IconButton(
                    icon: Icon(Icons.close, size: 35),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
