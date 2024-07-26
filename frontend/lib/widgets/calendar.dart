import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Carousel Example'),
        ),
        body: CarouselDemo(),
      ),
    );
  }
}

class CarouselDemo extends StatelessWidget {
  final List<String> imgList = [
    'https://via.placeholder.com/600x400',
    'https://via.placeholder.com/600x400',
    'https://via.placeholder.com/600x400',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 400.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16/9,
          viewportFraction: 0.8,
        ),
        items: imgList.map((item) => Container(
          child: Center(
            child: Image.network(item, fit: BoxFit.cover, width: 1000),
          ),
        )).toList(),
      ),
    );
  }
}
