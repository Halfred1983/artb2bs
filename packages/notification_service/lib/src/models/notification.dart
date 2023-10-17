import 'package:equatable/equatable.dart';

/// {@template notification}
/// Model representing a Notification.
/// {@endtemplate}
class Notification extends Equatable {
  /// {@macro notification}
  const Notification({
    required this.title,
    required this.body,
    required this.screen
  });

  /// The notification title.
  final String title;

  /// The notification body.
  final String body;

  // The screen to navigate to
  final String screen;

  @override
  List<Object> get props => [title, body, screen];
}