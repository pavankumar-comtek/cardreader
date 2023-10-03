import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  CommonScaffold(
      {super.key, required this.title, required this.body, this.onTap});
  final Widget body;
  final String title;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
             Navigator.pop(context);
              // onTap!();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF2B3951),
              size: 30
            )),
        elevation: 0,
        backgroundColor: Color.fromRGBO(240, 242, 245, 1),
        centerTitle: true,
        title: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2B3951),
              fontSize: 24,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w700,
              height: 1.00,
            )),
      ),
      body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(240, 242, 245, 1)),
          child: body),
    );
  }
}
