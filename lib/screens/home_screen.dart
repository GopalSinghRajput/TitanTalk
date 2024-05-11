import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:unicons/unicons.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:titan_talk/screens/history_meeting_screen.dart';
import 'package:titan_talk/screens/meeting_screen.dart';
import 'package:titan_talk/screens/more.dart';
import 'package:titan_talk/screens/chat.dart';
import 'package:titan_talk/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Meet & Chat',
              textStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              speed: Duration(milliseconds: 200),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          MeetingScreen(),
          HistoryMeetingScreen(),
          HomePage(),
          More(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home_max),
          mini: true,
          backgroundColor: Color.fromRGBO(28, 170, 96, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: () => MeetingScreen()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
          UniconsLine.meeting_board,
          UniconsLine.cloud_wifi,
          UniconsLine.search,
          UniconsLine.user,
        ],
        activeIndex: _pageIndex,
        notchMargin: 4,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        backgroundColor: const Color.fromRGBO(
            11, 20, 27, 1), // Set your desired background color
        activeColor: Color.fromRGBO(29, 170, 97, 1),
        inactiveColor: Colors.white,
      ),
    );
  }
}
