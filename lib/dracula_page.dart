import 'package:firebase_database/firebase_database.dart';
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
  late bool _isBuzzerOn = false;
  late bool _isSmokeOn = false;
  late bool _isFireOn = false;
  late bool _isPIROn = false;
  late bool _isLDROn = false;
  late bool _isCamOn = false;
  late String _message = '';

  void updateFirebase(String path, bool value) {
    FirebaseDatabase.instance.ref('devices/$path').set(value);
  }

  void _toggleBuzzer() {
    updateFirebase('buzzer', !_isBuzzerOn);
    setState(() {
      _isBuzzerOn = !_isBuzzerOn;
    });
  }

  void _toggleSmoke() {
    updateFirebase('gas', !_isSmokeOn);
    setState(() {
      _isSmokeOn = !_isSmokeOn;
    });
  }

  void _toggleFire() {
    updateFirebase('flame', !_isFireOn);
    setState(() {
      _isFireOn = !_isFireOn;
    });
  }

  void _togglePIR() {
    updateFirebase('pir', !_isPIROn);
    setState(() {
      _isPIROn = !_isPIROn;
    });
  }

  void _toggleLDR() {
    updateFirebase('ldr', !_isLDROn);
    setState(() {
      _isLDROn = !_isLDROn;
    });
  }

  void _toggleCAM() {
    updateFirebase('cam', !_isCamOn);
    setState(() {
      _isCamOn = !_isCamOn;
    });
  }

  void firebaseRealtime() {
    FirebaseDatabase.instance.ref('devices').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final value = event.snapshot.value as Map<dynamic, dynamic>;
        if (value.isNotEmpty) {
          setState(() {
            _isBuzzerOn = value['buzzer'] ?? false;
            _isSmokeOn = value['gas'] ?? false;
            _isFireOn = value['flame'] ?? false;
            _isPIROn = value['pir'] ?? false;
            _isLDROn = value['ldr'] ?? false;
            _isCamOn = value['cam'] ?? false;
            _message = value['message'] ?? '';
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
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 255, 0, 0),
        title: Row(
          children: [
            Image.asset(
              'assets/images/laor.png',
              height: 35,
            ),
            const SizedBox(width: 25),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 25),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                _isCamOn ? Icons.camera : Icons.camera_outlined,
              ),
              color: _isCamOn
                  ? Colors.redAccent.shade700
                  : Colors.redAccent.shade700,
              onPressed: _toggleCAM,
            ),
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
                        tooltip: 'Gas',
                        onPressed: _toggleSmoke),
                    Text(
                      'Gas',
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
                        icon: Icon(_isFireOn
                            ? Icons.fire_extinguisher
                            : Icons.fire_extinguisher),
                        color:
                            _isFireOn ? Colors.lightGreenAccent : Colors.white,
                        iconSize: size.width * 0.1,
                        tooltip: 'Flame',
                        onPressed: _toggleFire),
                    Text(
                      'Flame',
                      style: TextStyle(
                        color:
                            _isFireOn ? Colors.lightGreenAccent : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(_isLDROn
                          ? Icons.settings_display_rounded
                          : Icons.settings_display_outlined),
                      color: _isLDROn ? Colors.purple : Colors.white,
                      iconSize: size.width * 0.1,
                      tooltip: 'LDR',
                      onPressed: _toggleLDR,
                    ),
                    Text(
                      'LDR',
                      style: TextStyle(
                          color: _isLDROn ? Colors.purple : Colors.white),
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
