import 'package:flutter/material.dart';
import 'package:titan_talk/screens/about.dart';
import 'package:titan_talk/screens/note/screens/home_screen.dart';
import 'package:titan_talk/screens/user_account.dart';
import 'package:titan_talk/screens/whiteboard.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:titan_talk/screens/contacts.dart';

// Import your Whiteboard screen file
Widget _buildGlassContainer({required Widget child, double blur = 15}) {
  return GlassmorphicContainer(
    width: 380,
    height: 90,
    borderRadius: 20,
    blur: blur,
    alignment: Alignment.center,
    border: 2,
    linearGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: [
        Color(0xFFffffff).withOpacity(0.1),
        Color.fromRGBO(255, 255, 255, 1).withOpacity(0.05),
      ],
    ),
    borderGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFffffff).withOpacity(0.5),
        Color((0xFFFFFFFF)).withOpacity(0.5),
      ],
    ),
    child: child,
  );
}

class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                color: Color.fromRGBO(13, 33, 54, 1), // Adjust width as needed
                height: 180, // Adjust height as needed
                child: const UserProfiles(),
              ),
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Added Features",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: Colors.white,
                  thickness: 0.3,
                  // Adjust the width as needed
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to the Whiteboard screen when the row is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Whiteboards()),
                  );
                },
                child: _buildGlassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text: Go to Whiteboard
                        Text(
                          'Go to Whiteboard',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                        // Arrow Icon
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Note()),
                  );
                },
                child: _buildGlassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text: Go to Whiteboard
                        Text(
                          'Go to Notes',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                        // Arrow Icon
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Contacts()),
                  );
                },
                child: _buildGlassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text: Go to Whiteboard
                        Text(
                          'Contacts',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                        // Arrow Icon
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilesScreen()),
                  );
                },
                child: _buildGlassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text: Go to Whiteboard
                        Text(
                          'About us',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                        // Arrow Icon
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
