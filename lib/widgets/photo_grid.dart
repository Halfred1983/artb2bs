import 'package:database_service/database.dart';
import 'package:flutter/material.dart';

class PhotoGridWidget extends StatelessWidget {
  final List<Artwork> artworks;
  final int moreCount;

  PhotoGridWidget({required this.artworks, required this.moreCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true, // Set to true to ensure the GridView only takes the space it needs
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0, // Adjust the aspect ratio as needed
      ),
      itemCount: 2, // We want to divide the grid into 2 cells: one large, one small with 4 items
      itemBuilder: (context, index) {
        if (index == 0) {
          // The first image should take up the entire left side
          return ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              artworks[0].url!,
              fit: BoxFit.cover,
            ),
          );
        } else {
          // The right side is divided into four smaller images
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside the nested GridView
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            itemCount: artworks.length > 4 ? 4 : artworks.length - 1,
            itemBuilder: (context, smallIndex) {
              // Handle the last small image with the +X overlay
              if (smallIndex == 3 && moreCount > 0) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        artworks[smallIndex + 1].url!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      child: Center(
                        child: Text(
                          '+$moreCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    artworks[smallIndex + 1].url!,
                    fit: BoxFit.cover,
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}