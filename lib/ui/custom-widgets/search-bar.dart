import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final bool autoFocus;
  final Function onChanged;
  SearchBar({this.autoFocus = false, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 17.5),
      padding: EdgeInsets.only(left: 12, right: 12),
      height: 36,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: Color(0xFF8E8E93).withOpacity(0.12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Color(0xFF8F8E94),
          ),
          SizedBox(width: 6),
          Expanded(
            child: TextField(
              autofocus: autoFocus,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8F8E94),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          // Icon(
          //   Icons.mic,
          //   color: Color(0xFF8F8E94),
          // ),
        ],
      ),
    );
  }
}
