import 'package:flutter/material.dart';
import 'package:podcast_overhaul/ui/custom-widgets/custom-app-bar.dart';

class TopImageHeader extends StatelessWidget {
  final String title;
  TopImageHeader({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage("assets/static_assets/discover-extended-header.png"),
        ),
      ),
      child: Column(
        children: [
          CustomAppBar(title: title ?? ""),
        ],
      ),
    );
  }
}
