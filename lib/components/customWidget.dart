import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final String title;
  final Widget subtitle;

  CustomWidget({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Container(
      width: queryData.size.width / 5.5,
      height: 160,
      child: Card(
        color: Colors.deepPurple,
        child: Column(
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Align(alignment: Alignment.topCenter, child: subtitle),
          ],
        ),
      ),
    );
  }
}
