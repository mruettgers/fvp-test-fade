import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fvp/fvp.dart';
import 'package:fvp_test_fade/widgets/video_player_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    // Register video decoder
    print('Registering video decoder VAAPI');
    registerWith(
      options: {
        'video.decoders': ['vaapi'],
        'global': {'log': 'off'},
      },
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int counter = 0;

  @override
  void initState() {
    super.initState();
    // Recreate state every 3 secs
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        counter = (counter + 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Center(key: UniqueKey(), child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if ((counter % 2 == 0) || counter > 4) {
      if (counter == 0) {
        return Text('Text() widgets between videos are working...');
      }
      if (counter == 4) {
        return Text('Next round will be only video widgets and crash on X11...');
      } 
      return VideoPlayerWidget(
        key: UniqueKey(),
        src: 'assets/videos/Big_Buck_Bunny_1080_10s_1MB.mp4',
        onCompleted: () {
        },
      );
    } else {
      return Text('$counter');
    }

  }
}

