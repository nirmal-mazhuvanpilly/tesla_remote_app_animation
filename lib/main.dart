import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';
import 'package:tesla_animation/screens/battery_screen/battery_screen.dart';
import 'package:tesla_animation/widgets/car_view.dart';
import 'package:tesla_animation/screens/door_lock_screen/door_lock_screen.dart';
import 'package:tesla_animation/screens/temperature_screen/temperature_screen.dart';
import 'package:tesla_animation/screens/tyre_screen/type_screen.dart';
import 'package:tesla_animation/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TeslaProvider>(create: (_) => TeslaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tesla Home',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TeslaHome(),
      ),
    );
  }
}

class TeslaHome extends StatefulWidget {
  const TeslaHome({Key? key}) : super(key: key);

  @override
  State<TeslaHome> createState() => _TeslaHomeState();
}

class _TeslaHomeState extends State<TeslaHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: const [
            CarView(),
            DoorLockScreen(),
            BatteryScreen(),
            TemperatureScreen(),
            TyreScreen(),
            BottomNavBar(),
          ],
        ),
      ),
    );
  }
}
