import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chooser extends StatelessWidget{
  const Chooser({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RESSC Directory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true
      ),
      home: const RESSCDirectory(title: 'RESSC Directory'),
    );
  }
}

class RESSCDirectory extends StatefulWidget {
  const RESSCDirectory({super.key, required this.title});

  final String title;

  @override
  State<RESSCDirectory> createState() => _RESSCDirectory();
}

class _RESSCDirectory extends State<RESSCDirectory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.greenAccent,
          ),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.5,
              ),
              itemBuilder: itemBuilder),
        ),
      ),
    );
  }
}