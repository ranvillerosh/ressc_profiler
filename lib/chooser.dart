import 'package:flutter/material.dart';
import 'Data/system.dart';

class Chooser extends StatefulWidget {
  const Chooser({super.key, required this.title});

  final String title;

  @override
  State<Chooser> createState() => _Chooser();
}

class _Chooser extends State<Chooser> {

  @override
  Widget build(BuildContext context) {
    List<System> systemList = [];
    var directory = System(context, "Directory");
    systemList.add(directory);

    //adaptive layout
    if (MediaQuery.of(context).size.width > 500) {
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
              // borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.greenAccent,
            ),
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: systemList.length,
                  itemBuilder: (BuildContext, index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            systemList[index].navigateToSystem(context);
                            debugPrint('Card tapped.');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                systemList[index].systemName,
                                // style: TextStyle(
                                //   fontSize: MediaQuery.of(context).size.height/35
                              ),
                            ),
                          )
                      ),
                    );
                  }),
            ),
          ),
        ),
      );
    } else {
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
              // borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          systemList[index].navigateToSystem(context);
                          debugPrint('Card tapped.');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              systemList[index].systemName,
                              // style: TextStyle(
                              //   fontSize: MediaQuery.of(context).size.height/35
                            ),
                          ),
                        )
                    ),
                  );
                }),
          ),
        ),
      );
    }


  }
}

