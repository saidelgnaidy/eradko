import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/const.dart';
import 'package:flutter/material.dart';

class SectionTile extends StatelessWidget {
  final String img, name;
  const SectionTile({Key? key, required this.img, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: AspectRatio(
        aspectRatio: 2.15,
        child: Stack(
          alignment:Alignment.center,
          children: [
            SizedBox(
              width: size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: img,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(microseconds: 200),
                  placeholder: (context, img) => categoryPlaceholder(context),
                ),
              ),
            ),
            Positioned(
              right: size.width*.04,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name.split(' ').first.trim() ,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height/size.width*11,
                      ),
                    ),
                    const SizedBox(height:15 ),
                    Text(name.replaceAll(name.split(' ').first, '').trim(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height/size.width*11,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
