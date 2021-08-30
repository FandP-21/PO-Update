import 'package:flutter/material.dart';

class SponseredAdSection extends StatelessWidget {
  final String podcastImage;
  final Function onTap;

  SponseredAdSection({this.onTap, this.podcastImage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(19),
        padding: EdgeInsets.only(left: 5,right: 5,bottom: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF707070).withOpacity(0.7)),
            top: BorderSide(color: Color(0xFF707070).withOpacity(0.7)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Row

            //Ad Area
            Container(
              width: MediaQuery.of(context).size.width,
              height: 136,
              margin: EdgeInsets.only(bottom: 11, top: 27),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.42),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Color(0xFFDDDDDD), width: 1),
                image: DecorationImage(
                  image: NetworkImage(podcastImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Color(0xFFDDDDDD), width: 1),
              ),
              child: Text(
                "FEATURED",
                style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontSize: 10,
                  color: Color(0xFFF6F6F6).withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
