import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_login_page.dart';
import 'area_officer_login_page.dart';
import 'about_page.dart';
import 'mission_vision_page.dart';
import 'contact_us_page.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import your Firebase options file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAKSHYA VIDHEE SECURITY FORCE',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(), // Set SplashScreen as the home page
      routes: {
        '/about': (context) => AboutPage(),
        '/mission_vision': (context) => MissionVisionPage(),
        '/contact_us': (context) => ContactUsPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller and start animation
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _textAnimation = IntTween(begin: 0, end: _text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Listen to animation status
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkCurrentUser();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? email = user.email; // Get the email of the current user
      print('Current user email: $email');
      if (email != null) {
        // Fetch the role from Firestore
        var userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (userQuery.docs.isNotEmpty) {
          String role = userQuery.docs.first.get('role');
          print('Role from Firestore: $role');

          // Retrieve the stored role from SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? storedRole = prefs.getString('role');
          print('Stored role: $storedRole');

          if (storedRole != null && storedRole == role) {
            _navigateToRolePage(role, email);
          } else {
            _navigateToHomePage();
          }
        } else {
          print('No user document found in Firestore');
          _navigateToHomePage();
        }
      } else {
        print('Email is null');
        _navigateToHomePage();
      }
    } else {
      print('No current user');
      _navigateToHomePage();
    }
  }

  void _navigateToRolePage(String role, String email) {
    if (role == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminLoginPage()),
      );
    } else if (role == 'Area Officer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AreaOfficerLoginPage(email: email, role: role),
        ),
      );
    } else {
      _navigateToHomePage();
    }
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  final String _text = "Welcome to Lakshya Group";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            int currentLength = _textAnimation.value;
            return Text(
              _text.substring(0, currentLength),
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 24,
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        flexibleSpace: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.red, // Setting the app bar background color to red
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'LAKSHYA VIDHEE SECURITY FORCE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              title: const Text('Mission & Vision'),
              onTap: () {
                Navigator.pushNamed(context, '/mission_vision');
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pushNamed(context, '/contact_us');
              },
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: TypewriterAnimatedText(),
      ),
    );
  }
}

class TypewriterAnimatedText extends StatefulWidget {
  const TypewriterAnimatedText({Key? key}) : super(key: key);

  @override
  _TypewriterAnimatedTextState createState() => _TypewriterAnimatedTextState();
}

class _TypewriterAnimatedTextState extends State<TypewriterAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;

  final String _text = "Welcome to Lakshya Group";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _textAnimation = IntTween(begin: 0, end: _text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        int currentLength = _textAnimation.value;
        return Text(
          _text.substring(0, currentLength),
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 24,
          ),
        );
      },
    );
  }
}
