import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ressc_profiler/chooser.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // add firebase options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // firebase Auth
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const Login());
    } else {
      runApp(
          MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Chooser(title: "RESSC Portal")
          )
      );
    }
  });
}

class Login extends StatelessWidget {
  const Login({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RESSC Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'RESSC Portal'),
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
    String? userEmail;
    String? userPassword;
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
            width: MediaQuery.of(context).size.width / 3,
            height:
                Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 +
                    MediaQuery.of(context).size.height / 2,
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
                    fontSize: MediaQuery.of(context).size.height / 35),
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
                onChanged: (String? valueUsername) {
                  userEmail = valueUsername;
                },
                //validator adds validation function
                validator: (String? value) {
                  return (value != null && value.contains('@'))
                      ? 'Do not use the @ char.'
                      : null;
                },
              ),
              TextFormField(
                obscureText: !_passwordVisibility,
                decoration: InputDecoration(
                  icon: const Icon(Icons.password),
                  hintText: 'Please enter your password',
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _passwordVisibility = !_passwordVisibility;
                      userPassword = TextEditingValue as String?;
                    }),
                    icon: Icon(_passwordVisibility
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                onChanged: (String? valueUserpassword) {
                  userPassword = valueUserpassword;
                },
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: FilledButton(
                          onPressed: () {
                            _requestAccountDialog();
                          },
                          child: const Text("Sign Up!"))),
                  const Padding(padding: EdgeInsets.all(5)),
                  Expanded(
                      flex: 5,
                      child: FilledButton(
                          onPressed: () async {
                            try {
                              _loginToast(context);
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: userEmail!,
                                      password: userPassword!);
                                        debugPrint("Logging in");
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "user-not-found") {
                                _userNotFoundToast(context);
                                debugPrint("User not found");
                              } else if (e.code == "wrong-password") {
                                _wrongPasswordToast(context);
                                debugPrint("Wrong password");
                              }
                            } finally {
                              if (FirebaseAuth.instance.currentUser != null) {
                                _navigateToChooser(context);
                              }
                            }
                          },
                          child: const Text("Login")))
                ],
              )
            ],
          ),
        )));
  }

  Future<void> _requestAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No account yet?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Only authorized personnel are given access to this system'),
                Text(
                    'Please ask Ms. Victoria L. Malicdan for permission to utilize this system'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToChooser(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Chooser(title: "RESSC Portal")));
  }

  void _loginToast(BuildContext context) {
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Logging In, please wait...'),
        action: SnackBarAction(
            label: 'Dismiss', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _wrongPasswordToast(BuildContext context) {
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Wrong Password!'),
        action: SnackBarAction(
            label: 'Dismiss', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _userNotFoundToast(BuildContext context) {
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('User NOT found!'),
        action: SnackBarAction(
            label: 'Dismiss', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
