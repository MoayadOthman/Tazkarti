import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class EventImageCarousel extends StatelessWidget {
  final List<String> eventImages;

  const EventImageCarousel({super.key, required this.eventImages});

  @override
  Widget build(BuildContext context) {
    return eventImages.isNotEmpty
        ? CarouselSlider(
      options: CarouselOptions(
        height: 250,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
      items: eventImages.map((imageUrl) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    )
        : ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        'https://via.placeholder.com/150',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}
