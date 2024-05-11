import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:unicons/unicons.dart';
import 'package:titan_talk/resources/jitsi_meet_methods.dart';
import 'package:titan_talk/widgets/home_meeting_button.dart';

class MeetingScreen extends StatelessWidget {
  MeetingScreen({Key? key}) : super(key: key);

  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  void createNewMeeting(BuildContext context) async {
    var random = Random();
    String roomName = (random.nextInt(100000000) + 100000000).toString();
    _jitsiMeetMethods.createMeeting(
      roomName: roomName,
      isAudioMuted: true,
      isVideoMuted: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeMeetingButton(
              onPressed: () => createNewMeeting(context),
              text: 'New Meeting',
              icon: UniconsLine.video,
            ),
            HomeMeetingButton(
              onPressed: () {
                Navigator.pushNamed(context, "/video-call");
              },
              text: 'Join Meeting',
              icon: UniconsLine.plus_square,
            ),
          ],
        ),
        SizedBox(height: 70),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeMeetingButton(
              onPressed: () {},
              text: 'Schedule',
              icon: UniconsLine.calendar_alt,
            ),
            HomeMeetingButton(
              onPressed: () {},
              text: 'Share Screen',
              icon: UniconsLine.export,
            ),
          ],
        ),
        Expanded(
          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "Create or Join Meetings with just a click!",
                  speed: Duration(milliseconds: 200),
                  cursor: "_",
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
