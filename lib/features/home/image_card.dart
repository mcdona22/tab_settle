import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    required this.title,
    required this.imageName,
    this.description = '',
    this.imageHeight = 220.0,
    super.key,
  });

  final String title;
  final String description;
  final double imageHeight;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/graphics/$imageName';

    final theme = Theme.of(context);
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: theme.textTheme.headlineSmall,
            ),
            SizedBox(
              height: imageHeight,

              width: imageHeight,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
