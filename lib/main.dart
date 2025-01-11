import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

main(){
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DrawingApp(),
  ));
}

class DrawingApp extends StatefulWidget{
  const DrawingApp ({super.key});

  @override
  State<DrawingApp> createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp>{

  @override
  void initState(){
    super.initState();
    _controller=DrawingController();
  }

  late DrawingController _controller;

  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text("Drawing App",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
      ),
      body: DrawingBoard(

       controller:_controller,
        background: Container(
          color: Colors.white,
          height: 600,
          width: 600,
        ),

        showDefaultActions: true,
        showDefaultTools: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: saveDrawing,
        backgroundColor: Colors.blue,
      child: const Icon(Icons.save_alt, color: Colors.white),
      ),
    );
  }

  Future <void> saveDrawing() async{
    try{
      final imageData=await _controller.getImageData();
      if(imageData==null){
        print("No image to save");
        return;
      }

      String path;
      final directory= Directory("/storage/emulated/0/Pictures");
      if(!directory.existsSync()){
        directory.createSync(recursive: true);
      }
      path="${directory.path}/drawings.png";

      final file = File(path);
      await file.writeAsBytes(imageData.buffer.asInt8List());
      print("Drawing saved at $path");
    }
    catch(error){
      print("Error saving Drawing $error");
    }
  }
}