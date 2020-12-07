import 'package:flutter/material.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:mattendance/main.dart';

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Example',
//      // Routes
//      routes: <String, WidgetBuilder>{
//        '/': (_) => new Login(), // Login Page
//        '/home': (_) => new Home(), // Home Page
//        '/signUp': (_) => new SignUp(), // The SignUp page
//        '/forgotPassword': (_) => new ForgotPwd(), // Forgot Password Page
//        '/screen1':(_) => new Screen1(), // Any View to be navigated from home
//      },
//    );
//  }
//}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{
  String _status = 'no-action';

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
            ),
            BoxFieldContainer(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Email",
                    icon: Icon(
                      Icons.person,
                      color: Colors.blue[600],
                    )),
              )
            ),
            BoxFieldContainer(
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    icon: Icon(
                      Icons.lock_rounded,
                      color: Colors.blue[600]
                ))
              )
            ),
            Container(
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => this._status = 'loading');

                    appAuth.login().then((result) {
                      if (result) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        setState(() => this._status = 'rejected');
                      }
                    });
                  },
                  child: Text(
                      "LOGIN",
                    style: TextStyle(color:Colors.white),
                  ),),
              ),
            )
          ],
        )
      ),
    );
  }
}
class BoxFieldContainer extends StatelessWidget {
  final Widget child;
  const BoxFieldContainer({
    Key key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(29),
    ),
      child: child,
    );
  }
}
