import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Contacts extends StatelessWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Contacts WebView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWebView(title: 'Google Contacts'),
    );
  }
}

class MyWebView extends StatefulWidget {
  const MyWebView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late WebViewController _controller;
  bool _isLoading = true;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  @override
  void initState() {
    super.initState();
    _handleAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://contacts.google.com/',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              _controller = controller;
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
              debugPrint('Page finished loading: $url');
            },
            navigationDelegate: (NavigationRequest request) {
              // Handle navigation requests if needed
              return NavigationDecision.navigate;
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _handleAuthentication() async {
    try {
      // Sign in silently without showing any UI
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

      if (googleUser != null) {
        // Get the authentication details
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Retrieve the access token
        String accessToken = googleAuth.accessToken ?? '';

        // Load the Google Contacts URL with authentication headers
        await _controller.loadUrl(
          'https://contacts.google.com/',
          headers: {'Authorization': 'Bearer $accessToken'},
        );
      } else {
        // If user is not signed in, consider signing in automatically (add your logic)
        await _googleSignIn.signIn(); // Note: This might prompt the user for permission
      }
    } catch (e) {
      debugPrint('Error during authentication: $e');
      // Handle the error as needed (e.g., show an error message)
    }
  }
}
