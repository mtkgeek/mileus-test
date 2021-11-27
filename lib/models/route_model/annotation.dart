import 'package:flutter/foundation.dart';

@immutable
class Annotation {
  final List<dynamic>? duration;

  const Annotation({this.duration});

  factory Annotation.fromJson(Map<String, dynamic> json) => Annotation(
        duration: (json['duration'] as List<dynamic>?)?.map((e) => e).toList(),
      );

  Map<String, dynamic> toJson() => {
        'duration': duration,
      };

  Annotation copyWith({
    List<dynamic>? duration,
  }) {
    return Annotation(
      duration: duration ?? this.duration,
    );
  }
}
