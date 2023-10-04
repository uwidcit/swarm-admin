import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageGrid extends StatefulWidget {
  const ImageGrid({Key? key, required this.images}) : super(key: key);
  final List<String> images; // Replace with your list of image URLs

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  bool showCarousel = false;

  @override
  Widget build(BuildContext context) {
    if (widget.images.length <= 4) {
      // Display images in the grid
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of images in a row
        ),
        itemCount: widget.images.length,
        itemBuilder: (BuildContext context, int index) {
          String imageUrl = widget.images[index];
          return GestureDetector(
            onTap: () {
              // Handle tapping on individual images if needed
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    } else {
      // Display a "show more" button and a fullscreen carousel
      return Column(
        children: [
          CarouselSlider.builder(
            itemCount: widget.images.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              String imageUrl = widget.images[index];
              return GestureDetector(
                onTap: () {
                  // Handle tapping on individual images in the carousel if needed
                },
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              );
            },
            options: CarouselOptions(
              aspectRatio: 16 / 9, // Adjust as needed
              enlargeCenterPage: true,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showCarousel = !showCarousel;
              });
            },
            child: Text(showCarousel ? 'Show Less' : 'Show More'),
          ),
        ],
      );
    }
  }
}
