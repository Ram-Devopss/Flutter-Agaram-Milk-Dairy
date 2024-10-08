import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'backbutton.dart';

class RestPassword extends StatefulWidget {
  const RestPassword({Key? key}) : super(key: key);

  @override
  State<RestPassword> createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff251f34),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
      elevation: 0,
      leading: backButton(context),
      backgroundColor:Colors.white,
      title: Text('Forgot Password',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center),),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Email',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: const Color(0xff3B324E),
                      filled: true,
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightGreen, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      )),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email)
                            .then((value) => Navigator.of(context).pop());
                      },
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.s,
                        children: [Icon(Icons.email)
                          ,Text('Send Request'),],
                      ) ,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 20),
                      )))
            ]),
      ),
    );
  }
}