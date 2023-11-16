import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Data/system.dart';

class Chooser extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RESSC Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true
      ),
      home: const RESSCPortal(title: 'RESSC Portal'),
    );
  }
}

class RESSCPortal extends StatefulWidget {
  const RESSCPortal({super.key, required this.title});

  final String title;

  @override
  State<RESSCPortal> createState() => _RESSCPortal();
}

class _RESSCPortal extends State<RESSCPortal> {



  @override
  Widget build(BuildContext context) {
    List<System> systemList = [];
    var directory = new System("Directory");
    systemList.add(directory);

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
                childAspectRatio: 1.0,
              ),
              itemCount: systemList.length,
              itemBuilder: (BuildContext, index) {
                return Card(
                  // clipBehavior is necessary because, without it, the InkWell's animation
                  // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
                  // This comes with a small performance cost, and you should not set [clipBehavior]
                  // unless you need it.
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card tapped.');
                    },
                    child: SizedBox.expand(
                      // width: double.infinity,
                      // height: double.infinity,
                      child: AutoSizeText(systemList[index].systemName),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

