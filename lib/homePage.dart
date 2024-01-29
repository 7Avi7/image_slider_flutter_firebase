import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getImgFromFirestore() async {
    var firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await firebaseFirestore.collection("Carousel_images").get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getImgFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                width: 300,
                height: 300,
                child: const CircularProgressIndicator(),
              ),
            ); // Show loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data.isEmpty) {
            return const Text(
                'No data available'); // Handle case where data is null or empty
          } else {
            return RotatedBox(
              quarterTurns: 4,
              child: CarouselSlider.builder(
                // scrollDirection: Axis.vertical,
                viewportFraction: 1.0,
                autoSliderTransitionCurve: Curves.bounceOut,
                unlimitedMode: true,
                autoSliderDelay: const Duration(seconds: 4),
                enableAutoSlider: true,
                itemCount: snapshot.data.length,
                slideBuilder: (index) {
                  DocumentSnapshot sliderImage = snapshot.data[index];
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.network(
                      sliderImage['img'],
                      fit: BoxFit.cover,
                    ),
                  );
                },
                slideTransform: const CubeTransform(
                  rotationAngle: 0,
                ),
                slideIndicator: CircularSlideIndicator(
                  indicatorBackgroundColor: Colors.red,
                  currentIndicatorColor: Colors.green,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
