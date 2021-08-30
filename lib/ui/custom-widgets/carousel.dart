import 'package:flutter/material.dart';

class MyCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: 187,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF707070))),
      ),
      child: Column(
        children: [
          //Slider
          Container(
            height: 153,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.42),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: Text(
                "CARAOUSEL",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF969696),
                  fontFamily: 'Product Sans',
                ),
              ),
            ),
          ),

          //ADD Dotted
        ],
      ),
    );
  }
}
