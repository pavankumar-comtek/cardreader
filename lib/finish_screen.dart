import 'package:easy_separator/easy_separator.dart';
import 'package:flutter/material.dart';

class Finish extends StatefulWidget {
  
  const Finish({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FinishState();
  }
}

class FinishState extends State<Finish> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Finish',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                  // padding: UIParameters.contentPadding,
                  child: SafeArea(
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Padding(
                              padding: EdgeInsets.all(15),
                              child: IntrinsicHeight(
                                  child: Form(
                                      // key: formKey,
                                      child: EasySeparatedColumn(
                                        separatorBuilder: (_, __) {
                                          return const SizedBox(height: 20);
                                        },
                                        children: [
                                          Row(
                                            children: const [
                                              // Align(
                                              //   alignment: Alignment.centerLeft,
                                              //   child: IconButton(
                                              //     icon: const Icon(
                                              //         Icons.arrow_back),
                                              //     onPressed: () {
                                              //       Navigator.pop(context);
                                              //     },
                                              //   ),
                                              // ),
                                              Expanded(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Finish Screen",
                                                        // overflow: TextOverflow.ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 1.00,
                                                        ),
                                                      ))),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          
                                        ],
                                      )))))));
            })));
  }

  
  
}
