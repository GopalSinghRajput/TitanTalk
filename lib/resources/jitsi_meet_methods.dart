// import 'package:omni_jitsi_meet/jitsi_meet.dart';
import 'package:titan_talk/resources/auth_methods.dart';
import 'package:titan_talk/resources/firestore_methods.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final _jitsiMeetPlugin = JitsiMeet();

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
// Limit video resolution to 360p
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      } else {
        name = username;
      }

      var options = JitsiMeetConferenceOptions(
          room: roomName,
          featureFlags: {
            FeatureFlags.unsafeRoomWarningEnabled: true,
            FeatureFlags.kickOutEnabled: true,
            FeatureFlags.liveStreamingEnabled: true,
            FeatureFlags.lobbyModeEnabled: true,
            FeatureFlags.calenderEnabled: true,
            FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
            FeatureFlags.meetingPasswordEnabled: false,
            FeatureFlags.welcomePageEnabled: false,
            FeatureFlags.recordingEnabled: true,
            FeatureFlags.settingsEnabled: true,
            FeatureFlags.tileViewEnabled: true,
          },
          configOverrides: {
            "startWithAudioMuted": true,
            "startWithVideoMuted": true,
          },
          userInfo: JitsiMeetUserInfo(
            displayName: name,
            avatar: _authMethods.user.photoURL,
            email: _authMethods.user.email,
          ));
      _firestoreMethods.addToMeetingHistory(roomName);
      await _jitsiMeetPlugin.join(options);
    } catch (e) {
      print("error: $e");
    }
  }
}
