import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {

  // add firebase options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'RESSC Training Directory'),
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
  bool _passwordVisibility = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
          constraints: BoxConstraints.expand(
            width: MediaQuery.of(context).size.width/3,
            height: Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 + MediaQuery.of(context).size.height/2,
          ),
          // transform: Matrix4.rotationZ(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height/35
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                'Welcome to the RESSC Training Directory! Please login to continue.',
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Please enter your username',
                  labelText: 'Username',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                // validator adds validation function
                // validator: (String? value) {
                //   return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                // },
              ),
              TextFormField(
                obscureText: !_passwordVisibility,
                decoration: InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: 'Please enter your password',
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _passwordVisibility = !_passwordVisibility;
                    }),
                    icon: Icon(_passwordVisibility ? Icons.visibility_off : Icons.visibility),
                  ),
                  // validator adds validation function
                  // validator: (String? value) {
                  //   return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                  // },
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: FilledButton(
                        onPressed: () {  },
                        child: Text("Sign Up!"))
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  Expanded(
                      flex: 5,
                      child: FilledButton(
                          onPressed: () async {  },
                          child: Text("Login"))
                  )
                ],
              )
            ],
          ),
        )
      )
    );
  }
}
