import 'package:detect_false_gps/detect_false_gps.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isFakeGps;

  Future<void> _checkFakeGps() async {
    setState(() => _isFakeGps = null);
    if (await Permission.locationWhenInUse.request().isGranted) {
      final isFake = await DetectFalseGps.isFakeGps();
      setState(() {
        _isFakeGps = isFake;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplo Fake GPS'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isFakeGps == null
                    ? 'Verificando...'
                    : _isFakeGps!
                        ? 'Fake GPS detectado!'
                        : 'GPS legítimo.',
                style: TextStyle(
                  fontSize: 20,
                  color: _isFakeGps == null ? Colors.black : (_isFakeGps! ? Colors.red : Colors.green),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkFakeGps,
                child: const Text('Verificar GPS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
