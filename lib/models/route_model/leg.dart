import 'package:flutter/foundation.dart';

import 'annotation.dart';

@immutable
class Leg {
  final List<dynamic>? steps;
  final dynamic weight;
  final dynamic distance;
  final Annotation? annotation;
  final String? summary;
  final dynamic duration;

  const Leg({
    this.steps,
    this.weight,
    this.distance,
    this.annotation,
    this.summary,
    this.duration,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        steps: json['steps'] as List<dynamic>?,
        weight: json['weight'] as dynamic,
        distance: json['distance'] as dynamic,
        annotation: json['annotation'] == null
            ? null
            : Annotation.fromJson(json['annotation'] as Map<String, dynamic>),
        summary: json['summary'] as String?,
        duration: json['duration'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'steps': steps,
        'weight': weight,
        'distance': distance,
        'annotation': annotation?.toJson(),
        'summary': summary,
        'duration': duration,
      };

  Leg copyWith({
    List<dynamic>? steps,
    dynamic weight,
    dynamic distance,
    Annotation? annotation,
    String? summary,
    dynamic duration,
  }) {
    return Leg(
      steps: steps ?? this.steps,
      weight: weight ?? this.weight,
      distance: distance ?? this.distance,
      annotation: annotation ?? this.annotation,
      summary: summary ?? this.summary,
      duration: duration ?? this.duration,
    );
  }
}
