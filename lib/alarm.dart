import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:path_provider/path_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Player Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer audioPlugin = AudioPlayer();
  String mp3Uri;

  @override
  void initState() {
    _load();
  }

  Future<Null> _load() async {
    final ByteData data = await rootBundle.load('assets/sound.mp3');
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/demo.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3Uri = tempFile.uri.toString();
    print('finished loading, uri=$mp3Uri');
  }

  void _playSound() {
    if (mp3Uri != null) {
      audioPlugin.play(mp3Uri, isLocal: true);
    }
  }

  void _stopsound(){
    if (mp3Uri != null ){
      audioPlugin.stop();
    }
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesan'),
          content: const Text('Pesan'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                _stopsound();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player Demo Home Page'),
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _playSound();
          _ackAlert(context);
        },
        tooltip: 'Play',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
