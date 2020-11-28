import 'package:flutter/material.dart';
import 'package:mattendance/Pages/main_menu.dart';

class LoginScreen extends StatelessWidget{
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
                decoration: InputDecoration(hintText: "Email"),
              )
            ),
            BoxFieldContainer(
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: "Password")
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
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context){return MainMenu();},
                        ),
                    );
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
