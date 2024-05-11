import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:titan_talk/resources/auth_methods.dart';
import 'package:titan_talk/resources/firestore_methods.dart';
import 'package:titan_talk/resources/jitsi_meet_methods.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class MockAuthMethods extends Mock implements AuthMethods {}

class MockUser extends Mock implements User {
  @override
  String get uid => 'mock_uid'; 

  @override
  String get email =>
      'mock_user@example.com'; 

  @override
  String get displayName => 'Mock User';

  @override
  String get photoURL =>
      'https://example.com/avatar.jpg'; 

}

class MockFirestoreMethods extends Mock implements FirestoreMethods {}

void main() {
  Firebase.initializeApp();
  group('JitsiMeetMethods Integration Test', () {
    late JitsiMeetMethods jitsiMeetMethods;
    late MockAuthMethods mockAuthMethods;
    late MockFirestoreMethods mockFirestoreMethods;

    setUp(() {
      mockAuthMethods = MockAuthMethods();
      mockFirestoreMethods = MockFirestoreMethods();
      jitsiMeetMethods = JitsiMeetMethods();
    });

    test('createMeeting Integration Test', () async {
      when(mockAuthMethods.user).thenReturn(MockUser() as User);

      jitsiMeetMethods.createMeeting(
        roomName: 'testRoom',
        isAudioMuted: true,
        isVideoMuted: true,
        username: 'John Doe',
      );
      verify(mockFirestoreMethods.addToMeetingHistory('testRoom')).called(1);
      var expectedOptions = JitsiMeetConferenceOptions(
        room: 'testRoom',
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
          displayName: 'John Doe',
          avatar: 'https://example.com/avatar.jpg', // Mock avatar URL
          email: 'johndoe@example.com', // Mock email
        ),
      );

      verify(await JitsiMeet().join(expectedOptions)).called(1);
    });
  });
}
