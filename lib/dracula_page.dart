import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
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
  late bool _isDoorLockOn = false;
  late bool _isGasOn = false;
  late bool _isFlameOn = false;
  late bool _isExhaustOn = false;
  late bool _isCurrentOn = false;
  late String _message = '';

  void updateFirebase(String path, bool value) {
    FirebaseDatabase.instance.ref('devices/$path').set(value);
  }

  void _toggleDoorLock() async {
    // Unlock the door
    updateFirebase('Door Lock', true);
    setState(() {
      _isDoorLockOn = true;
    });

    // Wait for 8 seconds
    await Future.delayed(const Duration(seconds: 8));

    // Lock the door
    updateFirebase('Door Lock', false);
    setState(() {
      _isDoorLockOn = false;
    });
  } // Door Lock

  void _toggleGas() {
    updateFirebase('Gas', !_isGasOn);
    setState(() {
      _isGasOn = !_isGasOn;
    });
  } // Gas

  void _toggleFlame() {
    updateFirebase('Flame', !_isFlameOn);
    setState(() {
      _isFlameOn = !_isFlameOn;
    });
  } // Flame

  void _toggleExhaust() {
    updateFirebase('Exhaust', !_isExhaustOn);
    setState(() {
      _isExhaustOn = !_isExhaustOn;
    });
  } // Exhaust

  void _toggleCurrent() {
    updateFirebase('Current', !_isCurrentOn);
    setState(() {
      _isCurrentOn = !_isCurrentOn;
    });
  } // Current

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
            _isCurrentOn = value['Current'] ?? false;
            _message = value['message'] ?? '';
          });
        }
      }
    });
  } // FirebaseRealtime Database States

  @override
  void initState() {
    super.initState();
    firebaseRealtime();
  } // Firebase Realtime Database initialize

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
          color: Color.fromARGB(255, 0, 0, 0),
          image: DecorationImage(
            image: AssetImage("assets/images/Black_image.jpg"),
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
                          iconSize: size.width * 0.23,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.4,
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
                      'Unlock Door',
                      style: TextStyle(
                        fontSize: 20,
                        color: _isDoorLockOn ? Colors.tealAccent : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/pngas.png'),
                          iconSize: size.width * 0.23,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.4,
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
            // Gas button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/pnfire.png'),
                          iconSize: size.width * 0.23,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.4,
                            child: CupertinoSwitch(
                              value: _isFlameOn,
                              onChanged: (_) {
                                _toggleFlame();
                              },
                              activeColor: Colors.redAccent[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Flame',
                      style: TextStyle(
                        fontSize: 20,
                        color:
                            _isFlameOn ? Colors.redAccent[700] : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/pex.png'),
                          iconSize: size.width * 0.23,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.4,
                            child: CupertinoSwitch(
                              value: _isExhaustOn,
                              onChanged: (_) {
                                _toggleExhaust();
                              },
                              activeColor: const Color(0xFFDAFF64),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Exhaust',
                      style: TextStyle(
                        fontSize: 20,
                        color: _isExhaustOn
                            ? const Color(0xFFDAFF64)
                            : Colors.white,
                      ),
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
                          icon: Image.asset('assets/images/pncurrent.png'),
                          color:
                              _isCurrentOn ? Colors.cyanAccent : Colors.white,
                          iconSize: size.width * 0.23,
                          onPressed: () {},
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Transform.scale(
                            scale: 1.4,
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
                        color: _isCurrentOn ? Colors.deepOrange : Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              _message,
              style: const TextStyle(
                color: Color.fromARGB(255, 234, 0, 255),
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
