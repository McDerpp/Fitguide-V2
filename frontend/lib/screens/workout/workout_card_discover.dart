import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';

class WorkoutCardHome extends StatefulWidget {
  final String name;
  final String image;
  const WorkoutCardHome({super.key, required this.name, required this.image});

  @override
  State<WorkoutCardHome> createState() => _WorkoutCardHomeState();
}

class _WorkoutCardHomeState extends State<WorkoutCardHome> {
  @override
  Widget build(BuildContext context) {
    print("tem.imageUrl--->${widget.image}");
    return Container(
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.transparent, Colors.black],
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(widget.image,
                  fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),

                 

                  ),
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
