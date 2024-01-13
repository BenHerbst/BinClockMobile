import 'package:binclockmobile/painter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'BinClock',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF57c5ab),
          primary: Color(0xFF57c5ab),
          background: Color(0xFF11192e)
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BinClock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _repaint = ValueNotifier<int>(0);
  BinaryPainter? _binaryPainter;

  @override
  void initState() {
    _binaryPainter = BinaryPainter(repaint: _repaint);
    Timer.periodic( const Duration(seconds: 1), (Timer timer) {
      _repaint.value++;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Color(0xFFFFFFFF),
        title: Text(widget.title),

        actions: <Widget>[ PopupMenuButton(
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 32.0,
          ),
          // Callback that sets the selected popup menu item.
          onSelected: (String item) {
            if(item == 'web' || item == 'desktop' || item == 'gh') {
              // Open in browser
              final Uri url = Uri.parse(item == 'web' ? 'https://clock.benherbst.net/' : item == 'gh' ? 'https://github.com/BenHerbst/BinClockMobile' : 'https://github.com/AmirAli-AZ/BinaryClock');
              launchUrl(url);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: "web",
              child: Text('Web Version'),
            ),
            const PopupMenuItem(
              value: "desktop",
              child: Text('Desktop Version'),
            ),
            const PopupMenuItem(
              value: "gh",
              child: Text('GitHub'),
            ),
          ],
        ),
      ]),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(child: LayoutBuilder(
          builder: (_, constraints) {
            print(constraints.heightConstraints().maxHeight);
            print(450 / 1.5);
            final maxWidth = constraints.heightConstraints().maxHeight - 100 < 450 / 1.5 ? constraints.heightConstraints().maxHeight / 1.2 : 450;
            final width = constraints.widthConstraints().maxWidth < maxWidth ? constraints.widthConstraints().maxWidth - 60 : maxWidth;
            return Container(
              width: width.toDouble(),
              height: width / 1.5 ,
              child: CustomPaint(painter: _binaryPainter),
            );
          }
        ),),
      ),
    );
  }
}

