import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'dart:io' show Platform;
// import 'package:device_info_plus/device_info_plus.dart';

// Future<String?> getId() async {
//   var deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     // import 'dart:io'
//     var iosDeviceInfo = await deviceInfo.iosInfo;
//     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//   } else if (Platform.isAndroid) {
//     var androidDeviceInfo = await deviceInfo.androidInfo;
//     return androidDeviceInfo.androidId; // unique ID on Android
//   }
//   return null;
// }

class DraculaPage extends StatefulWidget {
  const DraculaPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DraculaPage> createState() {
    return _DraculaPageState();
  }
}

class _DraculaPageState extends State<DraculaPage> {
  late bool _isDoorLockOn = false;
  late bool _isGasOn = false;
  late bool _isFlameOn = false;
  late bool _isExhaustOn = false;
  late bool _isDoorLightOn = false;
  late bool _isCurrentOn = false;
  late String _message = '';

  void updateFirebase(String path, bool value) {
    FirebaseDatabase.instance.ref('devices/$path').set(value);
  }

  void _toggleDoorLock() {
    updateFirebase('Door Lock', !_isDoorLockOn);
    setState(() {
      _isDoorLockOn = !_isDoorLockOn;
    });
  }

  void _toggleGas() {
    updateFirebase('Gas', !_isGasOn);
    setState(() {
      _isGasOn = !_isGasOn;
    });
  }

  void _toggleFlame() {
    updateFirebase('Flame', !_isFlameOn);
    setState(() {
      _isFlameOn = !_isFlameOn;
    });
  }

  void _toggleExhaust() {
    updateFirebase('Exhaust', !_isExhaustOn);
    setState(() {
      _isExhaustOn = !_isExhaustOn;
    });
  }

  void _toggleDoorLight() {
    updateFirebase('Door Light', !_isDoorLightOn);
    setState(() {
      _isDoorLightOn = !_isDoorLightOn;
    });
  }

  void _toggleCurrent() {
    updateFirebase('Current', !_isCurrentOn);
    setState(() {
      _isCurrentOn = !_isCurrentOn;
    });
  }

  void firebaseRealtime() {
    FirebaseDatabase.instance.ref('devices').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final value = event.snapshot.value as Map<dynamic, dynamic>;
        if (value.isNotEmpty) {
          setState(() {
            _isDoorLockOn = value['Door Lock'] ?? false;
            _isGasOn = value['Gas'] ?? false;
            _isFlameOn = value['Flame'] ?? false;
            _isExhaustOn = value['Exhaust'] ?? false;
            _isDoorLightOn = value['Door Light'] ?? false;
            _isCurrentOn = value['Current'] ?? false;
            _message = value['Message'] ?? '';
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // getId().then((value) {
    //   setState(() {
    //     deviceId = value;
    //   });
    // });
    firebaseRealtime();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 111, 24, 224),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Row(
          children: [
            Image.asset(
              'assets/images/DSS.png',
              height: 45,
            ),
            const SizedBox(width: 25),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          image: DecorationImage(
            image: AssetImage("assets/images/blue.jpg"),
            fit: BoxFit.cover,
            opacity: 50,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/pnlock.png'),
                          iconSize: size.width * 0.2,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.5,
                            child: CupertinoSwitch(
                              value: _isDoorLockOn,
                              onChanged: (_) {
                                _toggleDoorLock();
                              },
                              activeColor: Colors.tealAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Door Lock',
                      style: TextStyle(
                        fontSize: 20,
                        color: _isDoorLockOn ? Colors.tealAccent : Colors.white,
                      ),
                    ),
                  ],
                ),
                // Smoke button
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: Image.asset('assets/images/pngas.png'),
                            iconSize: size.width * 0.2,
                            onPressed: () {}),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.5,
                            child: CupertinoSwitch(
                              value: _isGasOn,
                              onChanged: (_) {
                                _toggleGas();
                              },
                              activeColor: Colors.limeAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Gas',
                      style: TextStyle(
                        fontSize: 20,
                        color: _isGasOn ? Colors.limeAccent : Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Motion button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: Image.asset('assets/images/pnfire.png'),
                            iconSize: size.width * 0.2,
                            onPressed: () {}),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.5,
                            child: CupertinoSwitch(
                              value: _isFlameOn,
                              onChanged: (_) {
                                _toggleFlame();
                              },
                              activeColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Flame',
                      style: TextStyle(
                        fontSize: 20,
                        color: _isFlameOn ? Colors.red : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/pnlight.png'),
                          iconSize: size.width * 0.2,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 2.2,
                            child: Switch(
                              activeThumbImage:
                                  const AssetImage('assets/images/sun.png'),
                              inactiveThumbImage:
                                  const AssetImage('assets/images/moon.png'),
                              value: _isDoorLightOn,
                              onChanged: (_) {
                                _toggleDoorLight();
                              },
                              activeColor: Colors.cyanAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Door Light',
                      style: TextStyle(
                          fontSize: 20,
                          color: _isDoorLightOn
                              ? Colors.cyanAccent
                              : Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/pex.png'),
                          iconSize: size.width * 0.2,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.5,
                            child: CupertinoSwitch(
                              value: _isExhaustOn,
                              onChanged: (_) {
                                _toggleExhaust();
                              },
                              activeColor: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Exhaust',
                      style: TextStyle(
                          fontSize: 20,
                          color: _isExhaustOn ? Colors.purple : Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/pncurrent.png'),
                          color:
                              _isCurrentOn ? Colors.cyanAccent : Colors.white,
                          iconSize: size.width * 0.2,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.5,
                            child: CupertinoSwitch(
                              value: _isCurrentOn,
                              onChanged: (_) {
                                _toggleCurrent();
                              },
                              activeColor: Colors.deepOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Current',
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              _isCurrentOn ? Colors.deepOrange : Colors.white),
                    ),
                  ],
                )
              ],
            ),
            Text(
              _message,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
