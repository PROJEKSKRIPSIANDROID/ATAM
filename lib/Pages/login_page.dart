import 'package:flutter/material.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:mattendance/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String _email = '';
  String _password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
          key: _formKey,
          //width: double.infinity,
          //height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //key: _formKey,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                //child: TextField(
                validator: (input){
                  if (input.isEmpty){
                    return 'Please type an email';
                  }
                  return null;
                } ,
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                    hintText: "Email",
                    icon: Icon(
                      Icons.person,
                      color: Colors.blue[600],
                    )),
                // )
              ),
              TextFormField(
                //child: TextField(
                  validator: (input){
                    if(input.length < 8){
                      return 'Your password less than 8 characters';
                    }
                    return null;
                  },
                  onSaved: (input) => _password = input,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      icon: Icon(
                          Icons.lock_rounded,
                          color: Colors.blue[600]
                      ))
                // )
              ),
              Container(
                width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                    color: Colors.blue,
                    onPressed: signIn /*() {
                    setState(() => this._status = 'loading');

                    appAuth.login().then((result) {
                      if (result) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        setState(() => this._status = 'rejected');
                      }
                    });
                  }*/,
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

  Future<void> signIn() async{
    // Validate fields
    final formState = _formKey.currentState;
    if(formState.validate()){
      // Login to firebase
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage() ));
        Navigator.of(context).pushReplacementNamed('/home');
      }catch(e){
        print(e.message);
      }
    }

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
