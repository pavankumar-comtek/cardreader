import 'package:cardreader/utils/ui_parameters.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

void displaydialog(BuildContext context, String tittle, String infocontent,
    String imagename, String buttonname, int pageclose) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          backgroundColor: Theme.of(context).cardColor,
          // child: Expanded(
          child: SingleChildScrollView(
              child: Stack(children: <Widget>[
            Container(
                // height: 500,
                padding: const EdgeInsets.all(20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 20),
                  Text(tittle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                        fontSize: 18,
                        color: Colors.grey.shade800,
                        height: 1.00,
                      )),
                  imagename.isEmpty
                      ? const SizedBox(height: 0)
                      : const SizedBox(height: 20),
                  imagename.isEmpty
                      ? const SizedBox(height: 0)
                      : Image.asset(imagename),
                  // Image.asset('assets/images/card_details.png'),
                  const SizedBox(height: 20),
                  Text(infocontent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        // fontFamily: 'Urbanist',
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        // height: 1.00,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      label: buttonname,
                      onTap: () {
                        if (pageclose == 2) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                ]))
          ])));
      // ));
    },
  );
}

Future<void> displayDialog(
    BuildContext context, String tittle, String infocontent) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(tittle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(infocontent),
              // Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void displayLoading(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          backgroundColor: Color(0xFFf0F2F5),
          child: ShowProgressLoading(
            message: message,
          ),
        );
      });
}

class ShowProgressLoading extends StatelessWidget {
  const ShowProgressLoading({Key? key, this.message}) : super(key: key);
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: UIParameters.contentPadding,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Colors.teal[800],
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                message ?? "Loading",
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ));
  }
}