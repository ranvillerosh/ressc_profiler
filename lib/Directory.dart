import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RESSCDirectory extends StatefulWidget {
  const RESSCDirectory({super.key, required this.title});

  final String title;

  @override
  State<RESSCDirectory> createState() => _RESSCDirectory();
}

class _RESSCDirectory extends State<RESSCDirectory> {
  bool shadowColor = false;
  double? scrolledUnderElevation;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('RESSC Directory'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
          ),
          itemCount: systemList.length,
          itemBuilder: (BuildContext, index) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(18)
              ),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  systemList[index].systemName,
                  textWidthBasis: TextWidthBasis.parent,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height/35
                  ),
                ),
              ),
            );
          }),
    );
  }


}