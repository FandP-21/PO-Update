import 'package:flutter/material.dart';
import 'package:podcast_overhaul/core/constants.dart';

class CustomAppBar extends StatelessWidget {
  final bool showBackButton;
  final String title;
  CustomAppBar({this.title = "", this.showBackButton = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          showBackButton
              ? IconButton(
                  icon: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : Container(),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: "SEGOE UI",
              fontSize: 40,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
