import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DraculaPage extends StatefulWidget {
  const DraculaPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DraculaPage> createState() {
    return _DraculaPageState();
  }
}

class _DraculaPageState extends State<DraculaPage> {
  bool _isBuzzerOn = false;
  bool _isSmokeOn = false;
  bool _isMotionOn = false;
  bool _isLockOn = false;

  void _toggleBuzzer() {
    setState(() {
      _isBuzzerOn = !_isBuzzerOn;
      FirebaseDatabase.instance.ref().child('devices/buzzer').set(_isBuzzerOn);
    });
  }

  void _toggleSmoke() {
    setState(() {
      _isSmokeOn = !_isSmokeOn;
    });
  }

  void _toggleMotion() {
    setState(() {
      _isMotionOn = !_isMotionOn;
    });
  }

  void _toggleLock() {
    setState(() {
      _isLockOn = !_isLockOn;
    });
  }

  @override
  void initState() {
    super.initState();

    // Set up listeners for button states
    FirebaseDatabase.instance.ref().child('devices/buzzer').onValue.listen((event) {
      setState(() {
        _isBuzzerOn = event.snapshot.value as bool;
      });
    });
    // Repeat this for other buttons
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
                        icon: Icon(
                            _isLockOn ? Icons.lock : Icons.lock_open_sharp),
                        color: _isLockOn ? Colors.tealAccent : Colors.white,
                        iconSize: size.width * 0.1,
                        tooltip: 'Lock',
                        onPressed: _toggleLock),
                    Text(
                      'Lock',
                      style: TextStyle(
                          color: _isLockOn ? Colors.tealAccent : Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
