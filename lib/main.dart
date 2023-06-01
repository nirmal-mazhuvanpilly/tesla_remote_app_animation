import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesla_animation/generated/assets.dart';
import 'package:tesla_animation/provider/tesla_provider.dart';
import 'package:tesla_animation/screens/door_lock_screen.dart';
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
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  height: constraints.maxHeight * .80,
                  width: constraints.maxWidth * .80,
                  child: SvgPicture.asset(Assets.iconsCar),
                ),
              );
            }),
            const DoorLockScreen(),
            const BottomNavBar(),
          ],
        ),
      ),
    );
  }
}
