import 'package:events_app_exam/data/models/event.dart';

class User {
  final String id;
  final String uid;
  final String userFCMToken;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final List<String> favoriteEventsId;
  final List<String> registeredEventsId;

  const User({
    required this.id,
    required this.uid,
    required this.userFCMToken,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    required this.favoriteEventsId,
    required this.registeredEventsId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uid: json['uid'],
      userFCMToken: json['user-FCM-token'],
      firstName: json['first-name'],
      lastName: json['last-name'],
      email: json['email'],
      imageUrl: json['image-url'],
      favoriteEventsId: (json['favorite-events'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      registeredEventsId: (json['registered-events'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  List<Event> getUserEvents(List<Event> events) {
    return events.where((element) => element.id == id).toList();
  }
}
