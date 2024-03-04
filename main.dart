import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState(); 
}

class _MyAppState extends State<MyApp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitForm() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    //establishing connection to db
    final connection = PostgreSQLConnection(
      'localhost',//name of your host
      5432, //port number
      'loginForm',//name of database
      username: 'postgres',//username
      password: '1234',//password
    );

    await connection.open();

    //here you insert your query to record information
    await connection.query(
        'INSERT INTO users (email, password) VALUES (@email, @password)',
        substitutionValues: {'email': email, 'password': password});

    await connection.close();//closing connection

    _emailController.clear();//clearing the data you entered from box
    _passwordController.clear();//same

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Center(child: Text("CRIS")),
            leading: Container(
              child: Image.asset("assets/images/crislogo.jpeg"),
            ),
          ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome To CRIS Login Page',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: '@gmail.com', 
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {},
                      validator: (value) {
                        return value!.isEmpty ? 'Enter your email' : null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                        
                      ),obscureText: true,
                      onChanged: (String value) {},
                      validator: (value) {
                        return value!.isEmpty ? 'Enter your password' : null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                        onPressed: _submitForm,
                        child: Text('SUBMIT'),
                        color: Color.fromARGB(255, 233, 117, 34),
                        textColor: Color.fromARGB(255, 163, 245, 188)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
