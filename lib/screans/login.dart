import 'package:ez_orgnize/General/Sqe_Title.dart';
import 'package:ez_orgnize/General/Text_Filled.dart';
import 'package:ez_orgnize/General/buttons.dart';
import 'package:flutter/material.dart';

class log_in extends StatelessWidget{
   log_in({super.key});
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
//hhhhh
   // sign user in method
   void signUserIn() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column
                (children: [
                  const SizedBox(height: 100,),


                //Company logo
                const Icon(Icons.lock,size:100,
                ),const SizedBox(height: 25,),

                // login massage
                Text(
                    "Sign IN !",
                style: TextStyle(
                  color:Colors.black,
                  fontSize:36,
                  ),
                ),
                 const SizedBox(height: 50,),
                //usernam
               Text_Filled(
                 controller: usernameController,
                 hintText: 'Username',
                 obscureText: false,
               ),
                const SizedBox(height: 25,),
                //pass
                Text_Filled(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 12,),
                //forget pass
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
              //sign in button
                button(
                  onTap: signUserIn,
                ),
                const SizedBox(height: 25),
                //coninue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [

                    // apple button
                    Sqe_Title(imagePath: 'lib/photo/Apple.png'),
                    const SizedBox(width: 8),

                    // google button
                    Sqe_Title(imagePath: 'lib/photo/Google.png'),


                  ],//children
                ),
                const SizedBox(height: 20),
              //not member
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                'Not a member?',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(width: 4),
              const Text(
                  'Register now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    ),
                 ),
                  ],
                 )
                ],
              ),
            ),
          ),
        ),
    );
  }
}//..