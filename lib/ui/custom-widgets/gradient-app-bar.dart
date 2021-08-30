import 'package:flutter/material.dart';
import 'package:podcast_overhaul/core/constants.dart';

// ignore: must_be_immutable
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 100.0;

  final String title;
  final List<Color> gradientColors;

  Widget leading;

  GradientAppBar({
    this.title,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    if (canPop)
      leading = useCloseButton ? const CloseButton() : const BackButton();
    return Container(
      height: _preferredHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainColor,
            Colors.black,
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1, 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (canPop)
            leading = useCloseButton
                ? const CloseButton(
                    color: Colors.white,
                  )
                : const BackButton(
                    color: Colors.white,
                  ),
          if (!canPop)
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white.withOpacity(0),
              ),
              onPressed: () {},
            ),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 4,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white.withOpacity(0),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}
