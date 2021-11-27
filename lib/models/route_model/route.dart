import 'package:flutter/foundation.dart';

import 'geometry.dart';
import 'leg.dart';

@immutable
class Route {
  final List<Leg>? legs;
  final String? weightName;
  final Geometry? geometry;
  final dynamic weight;
  final dynamic distance;
  final dynamic duration;

  const Route({
    this.legs,
    this.weightName,
    this.geometry,
    this.weight,
    this.distance,
    this.duration,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        legs: (json['legs'] as List<dynamic>?)
            ?.map((e) => Leg.fromJson(e as Map<String, dynamic>))
            .toList(),
        weightName: json['weight_name'] as String?,
        geometry: json['geometry'] == null
            ? null
            : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
        weight: json['weight'] as dynamic,
        distance: json['distance'] as dynamic,
        duration: json['duration'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'legs': legs?.map((e) => e.toJson()).toList(),
        'weight_name': weightName,
        'geometry': geometry?.toJson(),
        'weight': weight,
        'distance': distance,
        'duration': duration,
      };

  Route copyWith({
    List<Leg>? legs,
    String? weightName,
    Geometry? geometry,
    dynamic weight,
    dynamic distance,
    dynamic duration,
  }) {
    return Route(
      legs: legs ?? this.legs,
      weightName: weightName ?? this.weightName,
      geometry: geometry ?? this.geometry,
      weight: weight ?? this.weight,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
    );
  }
}
