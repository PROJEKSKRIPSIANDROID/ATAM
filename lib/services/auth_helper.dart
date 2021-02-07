import 'package:flutter/material.dart';
import 'package:mattendance/Pages/home_page.dart';
import 'package:mattendance/Pages/login_page.dart';
import 'package:mattendance/Pages/main_menu.dart';
import 'package:mattendance/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mattendance/services/auth_helper.dart';
import 'package:flutter/services.dart';
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

class _LoginScreen extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
      String email,
      String password,
      String username,
      bool isLogin,
      BuildContext ctx,
      ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
          'position':'employee',
          'user_id': authResult.user.uid,
          'office': 'AdIns',
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
