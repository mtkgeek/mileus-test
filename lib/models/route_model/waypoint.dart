import 'package:flutter/foundation.dart';

@immutable
class ApiWaypoint {
  final String? hint;
  final double? distance;
  final List<dynamic>? location;
  final String? name;

  const ApiWaypoint({this.hint, this.distance, this.location, this.name});

  factory ApiWaypoint.fromJson(Map<String, dynamic> json) => ApiWaypoint(
        hint: json['hint'] as String?,
        distance: (json['distance'] as num?)?.toDouble(),
        location: (json['location'] as List<dynamic>?)?.map((e) => e).toList(),
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'hint': hint,
        'distance': distance,
        'location': location,
        'name': name,
      };

  ApiWaypoint copyWith({
    String? hint,
    double? distance,
    List<dynamic>? location,
    String? name,
  }) {
    return ApiWaypoint(
      hint: hint ?? this.hint,
      distance: distance ?? this.distance,
      location: location ?? this.location,
      name: name ?? this.name,
    );
  }
}
