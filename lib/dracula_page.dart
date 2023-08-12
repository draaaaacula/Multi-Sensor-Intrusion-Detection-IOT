import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
  return null;
}

class DraculaPage extends StatefulWidget {
  const DraculaPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DraculaPage> createState() {
    return _DraculaPageState();
  }
}

class _DraculaPageState extends State<DraculaPage> {
  late String? deviceId = '';
  late bool _isBuzzerOn = false;
  late bool _isSmokeOn = false;
  late bool _isMotionOn = false;
  late bool _isLockOn = false;
  late String _message = '';

  void updateFirebase(String path, bool value) {
    if (deviceId == null) {
      return;
    }
    FirebaseDatabase.instance.ref('devices/$deviceId/$path').set(value);
  }

  void _toggleBuzzer() {
    updateFirebase('buzzer', !_isBuzzerOn);
    setState(() {
      _isBuzzerOn = !_isBuzzerOn;
    });
  }

  void _toggleSmoke() {
    updateFirebase('smoke', !_isSmokeOn);
    setState(() {
      _isSmokeOn = !_isSmokeOn;
    });
  }

  void _toggleMotion() {
    updateFirebase('motion', !_isMotionOn);
    setState(() {
      _isMotionOn = !_isMotionOn;
    });
  }

  void _toggleLock() {
    updateFirebase('lock', !_isLockOn);
    setState(() {
      _isLockOn = !_isLockOn;
    });
  }

  void firebaseRealtime() {
    if (deviceId == null) {
      return;
    }
    FirebaseDatabase.instance.ref('devices/$deviceId').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final value = data[deviceId];
        if (value != null) {
          setState(() {
            _isBuzzerOn = value['buzzer'] ?? false;
            _isSmokeOn = value['smoke'] ?? false;
            _isMotionOn = value['motion'] ?? false;
            _isLockOn = value['lock'] ?? false;
            _message = value['message'] ?? '';
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getId().then((value) {
      setState(() {
        deviceId = value;
      });
    });
    firebaseRealtime();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 255, 196, 0),
        title: Row(
          children: [
            Image.asset(
              'assets/images/laor.png',
              height: 35,
            ),
            const SizedBox(width: 25),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 20),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF000000),
          image: DecorationImage(
            image: AssetImage("assets/images/316867.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(_isBuzzerOn
                          ? Icons.notifications_active
                          : Icons.notifications_off),
                      color:
                          _isBuzzerOn ? Colors.yellow.shade700 : Colors.white,
                      iconSize: size.width * 0.1,
                      tooltip: 'Buzzer',
                      onPressed: _toggleBuzzer,
                    ),
                    Text(
                      'Buzzer',
                      style: TextStyle(
                        color:
                            _isBuzzerOn ? Colors.yellow.shade700 : Colors.white,
                      ),
                    ),
                  ],
                ),
                // Smoke button
                Column(
                  children: [
                    IconButton(
                        icon: Icon(_isSmokeOn
                            ? Icons.smoking_rooms
                            : Icons.smoke_free),
                        color: _isSmokeOn ? Colors.red.shade700 : Colors.white,
                        iconSize: size.width * 0.1,
                        tooltip: 'Smoke',
                        onPressed: _toggleSmoke),
                    Text(
                      'Smoke',
                      style: TextStyle(
                        color: _isSmokeOn ? Colors.red.shade700 : Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Motion button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                        icon: Icon(_isMotionOn
                            ? Icons.sensors
                            : Icons.sensors_off_sharp),
                        color: _isMotionOn
                            ? Colors.lightGreenAccent
                            : Colors.white,
                        iconSize: size.width * 0.1,
                        tooltip: 'Motion',
                        onPressed: _toggleMotion),
                    Text(
                      'Motion',
                      style: TextStyle(
                        color: _isMotionOn
                            ? Colors.lightGreenAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon:
                          Icon(_isLockOn ? Icons.lock : Icons.lock_open_sharp),
                      color: _isLockOn ? Colors.tealAccent : Colors.white,
                      iconSize: size.width * 0.1,
                      tooltip: 'Lock',
                      onPressed: _toggleLock,
                    ),
                    Text(
                      'Lock',
                      style: TextStyle(
                          color: _isLockOn ? Colors.tealAccent : Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              _message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
