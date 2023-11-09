import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cardreader/api/API.dart';
import 'package:cardreader/models/cardtoken_response.dart';
import 'package:cardreader/payment_screen.dart';
import 'package:cardreader/screens/status_screen.dart';
import 'package:cardreader/utils/common_device_tile.dart';
import 'package:cardreader/utils/common_scaffold.dart';
import 'package:cardreader/utils/custom_button.dart';
import 'package:cardreader/utils/ui_parameters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:card_sdk/M6pBleBean.dart';
import 'package:card_sdk/M6pBleControl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_nVWvz0F2wXEf6pIjG0TSmIRW";
  //Stripe.publishableKey = "pk_live_vddmhz2nlIkrX4jjpEQ8bMyw";
  //Stripe.merchantIdentifier = "";
  await Stripe.instance.applySettings();
  return runApp(chooseWidget(window.defaultRouteName));
}

// Set up a MethodChannel
const platform = const MethodChannel('com.rydeum.partner/result');
Widget chooseWidget(String route) {
  // switch (route) {
  //   case '/route':
  //     return MyApp(authToken: route.split("/").last);

  //   default:
  //     return MyApp(authToken: "",);
  // }
  // route =
  //     "/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzI5ZDM2MDQyNDBiZTVkMGEzMWFiNGMiLCJrZXkiOiJhY2MiLCJhY2Nlc3NDb2RlIjo0ODQzLCJpYXQiOjE2OTk1MjE5MTYsImV4cCI6MTY5OTYwODMxNiwic3ViIjoicHJvdmlkZXIifQ.JNhF65Qv_XWskdwoFBetsOrbAPjURQ4S9cv--gk52R0";
  api.authToken = route.split("/").last == ""
      ? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IjIxbWFoZXNoZEBnbWFpbC5jb20iLCJzdWIiOiI2MjBhNTFkN2UxNzg1NjFkYWI1ZjM2ZTUiLCJpZCI6IjYyMGE1MWQ3ZTE3ODU2MWRhYjVmMzZlNSIsImdyYW50VHlwZSI6ImFjY2VzcyIsImlhdCI6MTY0NTIwMzc4NSwiZXhwIjoxNjQ2MDQzNzg1fQ.xYLSg6wJypAybSHhmqoAygV5xJJGR0UngJlv7F7Ooog"
      : route.split("/").last;
  print(
      "Flutter Module  -RAMAMMA Route from native is $route  and split is ${route.split("/").last}");
  return MyApp(authToken: route.split("/").last);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.authToken});
  final String authToken;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Card Payment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<M6pBleDevice> blueList = [];
  String bluetoothStatus =
      'Bluetooth is OFF,Please switch on Bluetooth to Continue';
  bool isBluetoothOn = false;
  BleControl bleControl = BleControl();
  FlutterBlue flutterBlue = FlutterBlue.instance;
  late StreamSubscription<BluetoothState> stateSubscription;
  CardEditController cardEditController = CardEditController(
    initialDetails: CardFieldInputDetails(
      complete: true,
      last4: "4242",
      number: "4242424242424242",
      expiryMonth: 12,
      expiryYear: 2025,
      brand: "Visa",
      cvc: '123',
      postalCode: '500084',
      validCVC: CardValidationState.Valid,
      validExpiryDate: CardValidationState.Valid,
      validNumber: CardValidationState.Valid,
    ),
  );
  CardFieldInputDetails? cardFieldInputDetails;
  String? token = '';

  @override
  void initState() {
    platform.setMethodCallHandler(_receiveFromHost);
    // TODO: implement initState
    super.initState();

    stateSubscription = flutterBlue.state.listen((BluetoothState state) {
      if (state == BluetoothState.on) {
        // Bluetooth is on, start scanning
        setState(() {
          bluetoothStatus = '';
          isBluetoothOn = true;
        });

        startSearch();
      } else {
        // Bluetooth is off or not available, handle it here
        // For now, we'll just print a message
        checkBluetoothPermissionAndAvailability();

        print('Flutter Module -BluetoothState is Off');

        setState(() {
          blueList.clear();
          bluetoothStatus =
              'Bluetooth is OFF, Please switch on Bluetooth to Continue';
          isBluetoothOn = false;
        });
      }
    });
  }

  Future<void> _receiveFromHost(MethodCall call) async {
    var jData;

    try {
      if (call.method == "getToken") {
        final String data = call.arguments;
        jData = await jsonDecode(data);
      }
    } on PlatformException catch (error) {
      print("Flutter Module -$error");
    }
    setState(() {
      token = jData['token'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Token :: $token  ${api.authToken}'),
      ),
    );
  }

  Future<void> requestBluetoothPermission() async {
    if (await Permission.bluetooth.request().isGranted) {
      // Permission is granted, proceed with Bluetooth operations
      checkBluetoothAvailability();
    } else {
      // Permission denied, handle it (show a dialog, ask user to enable it manually, etc.)
      // For now, we'll just print a message
      print('Flutter Module -Bluetooth permission denied.');
      PermissionStatus bluetoothPerm = await Permission.bluetooth.request();
      if (bluetoothPerm.isGranted) {
        checkBluetoothAvailability();
      } else {
        print('Flutter Module -Bluetooth permission denied.');
      }
    }
  }

  Future<void> checkBluetoothAvailability() async {
    bool isBluetoothAvailable = await flutterBlue.isOn;
    if (isBluetoothAvailable) {
      //   // Bluetooth is available, proceed with your operations
      //   startSearch();
      // } else {
      //   // Bluetooth is not available, handle it (show a dialog, ask user to enable it manually, etc.)
      //   // For now, we'll just print a message
      //   if (kDebugMode) {
      //     print('Flutter Module -Bluetooth is not available.');
      //   }
      // }

      //Check permission for bluetooth scan
      if (await Permission.bluetoothScan.request().isGranted) {
        // Permission is granted, proceed with Bluetooth operations
        // Bluetooth is available, proceed with your operations
        startSearch();
      } else {
        // Permission denied, handle it (show a dialog, ask user to enable it manually, etc.)
        // For now, we'll just print a message

        print('Flutter Module -BluetoothScan permission denied.');

        PermissionStatus bluetoothScanPerm =
            await Permission.bluetoothScan.request();
        if (bluetoothScanPerm.isGranted) {
          checkBluetoothAvailability();
        } else {
          print('Flutter Module -BluetoothScan permission denied.');
        }
      }
    } else {
      // Bluetooth is not available, handle it (show a dialog, ask user to enable it manually, etc.)
      // For now, we'll just print a message

      print('Flutter Module -Bluetooth is not available.');
    }
  }

  _blueConnect(M6pBleDevice device) async {
    //await device.connect();
    bool isConnect = await bleControl.connectDevice(device);

    //List<ItronBleDevice> services = await device.discoverServices();
    if (isConnect) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StatusScreen(deviceName: device.name ?? "Bluetooth Device");
      }));
    } else {
      Fluttertoast.showToast(msg: 'Device not Connected');
    }
  }

  Widget buildItem(BuildContext context, int index) {
    // return TextButton(
    //     onPressed: () {
    //       print(index);
    //       M6pBleDevice device = blueList[index];
    //       _blueConnect(device);
    //     },
    //     child: Text('${blueList[index].name}\n${blueList[index].UUID}'));

    return CustomDeviceTile(
      onTap: () async {
        print("Flutter Module - Bluetooth Device index::$index");
        M6pBleDevice device = blueList[index];
        bool isBluetoothAvailable = await flutterBlue.isOn;
        if (isBluetoothAvailable) {
          _blueConnect(device);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return Container(
                  child: Text("Switch on Bluetooth to Connect"),
                );
              });
        }
      },
      deviceName: '   ${blueList[index].name}',
      textStyle: TextStyle(
          color: Color.fromRGBO(170, 170, 170, 1),
          fontSize: RD(d: 16, t: 16, m: 16, s: 16).get(context)),
    );
  }

  void startSearch() async {
    print('Flutter Module -start search bluetooth');
    /*
                itronBle.startScan().listen((event) {
                  //print(event);
                });*/
    //scanBle();
    // setState(() {
    //   blueList = [];
    // });
    if (await Permission.bluetoothConnect.isGranted) {
      if (await Permission.bluetoothScan.isGranted) {
        bleControl.startScan().listen((device) {
          if (device != null) {
            setState(() {
              blueList.add(device);
            });
            print("Flutter Module -$device");
          }
        });
      } else {
        PermissionStatus bluetoothScanPerm =
            await Permission.bluetoothScan.request();
        if (bluetoothScanPerm.isGranted) {
          startSearch();
        } else {
          print('Flutter Module -BluetoothScan permission denied.');
        }
      }
    } else {
      PermissionStatus bluetoothConnectPerm =
          await Permission.bluetoothConnect.request();
      if (bluetoothConnectPerm.isGranted) {
        startSearch();
      } else {
        print('Flutter Module -Bluetooth permission denied.');
      }
    }
  }

  Future<void> checkBluetoothPermissionAndAvailability() async {
    await requestBluetoothPermission();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // startSearch();
    //generateStripeToken();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return CommonScaffold(
        title: 'Card Reader Check',
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visibility(
              //   child: CardField(
              //     controller: cardEditController,
              //     decoration: const InputDecoration(
              //       labelText: 'Card Number',
              //     ),
              //     onCardChanged: (CardFieldInputDetails? card) {
              //       setState(() {
              //         cardFieldInputDetails = card;
              //       });
              //     },
              //   ),
              //   visible: true,
              // ),
              // ElevatedButton(
              //     onPressed: () {
              //       generateStripeToken();
              //     },
              //     child: Text("Generate")),
              Text(
                "Card Reader Setup",
                style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: const RD(d: 16, t: 16, m: 16, s: 16).get(context),
                    color: Color.fromRGBO(69, 100, 130, 1),
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              if (isBluetoothOn)
                Text(
                  "Select the device that starts with I9-000XXX",
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontStyle: FontStyle.italic,
                      fontSize:
                          const RD(d: 13, t: 13, m: 13, s: 13).get(context),
                      color: Color.fromRGBO(167, 173, 185, 1),
                      fontWeight: FontWeight.w700),
                ),
              SizedBox(
                height: 10,
              ),
              if (isBluetoothOn)
                Expanded(
                  //child: Text('123'),
                  child: ListView.separated(
                    itemCount: blueList.length,
                    itemBuilder: buildItem,
                    separatorBuilder: (BuildContext context, int index) =>
                        new Divider(),
                  ),
                  // flex: 20,
                ),
              if (!isBluetoothOn)
                Text(
                  bluetoothStatus,
                  style: TextStyle(
                    color: Color(0xFF2b3951),
                    fontSize: const RD(d: 16, t: 16, m: 16, s: 16).get(context),
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              Spacer(),
              Center(
                // child: ElevatedButton(
                //   child: Text('search bluetooth'),
                //   onPressed: () {
                //     print('start search bluetooth');
                //     /*
                //     itronBle.startScan().listen((event) {
                //       //print(event);
                //     });*/
                //     //scanBle();
                //     setState(() {
                //       blueList = [];
                //     });
                //     bleControl.startScan().listen((device) {
                //       setState(() {
                //         blueList.add(device);
                //       });
                //       print(device);
                //     });
                //   },
                // ),

                child: CustomButton(
                  label: '(Or) Enter Card Details Manually',
                  onTap: () {
                    Get.to(() => Payment(
                        'https://pay.rydeum.info',
                        'RA4BR',
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MjBmMzQxYzNiMjZiNzVlNmE2MDdlY2UiLCJrZXkiOiJhY2MiLCJhY2Nlc3NDb2RlIjo4ODQ5LCJpYXQiOjE2NzM0MjAzNTksImV4cCI6MTY3MzUwNjc1OSwic3ViIjoicHJvdmlkZXIifQ.r6WFmK0kqfBJmMe50VgyDuuIuWDymPIsF2PzMlESIew',
                        "",
                        "",
                        ""));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
