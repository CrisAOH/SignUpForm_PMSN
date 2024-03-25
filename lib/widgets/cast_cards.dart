import 'package:flutter/material.dart';

class CastList extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? character;

  CastList({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.0,
      child: Card(
        child: Wrap(
          children: [
            imageUrl != null
                ? Image.network("https://image.tmdb.org/t/p/w500/$imageUrl")
                : Image.asset(
                    "images/profileicon.png",
                    fit: BoxFit.fill,
                  ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 5),
              title: Text(
                name!,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: SingleChildScrollView(
                child: Text(
                  character!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
