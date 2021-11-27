import 'package:flutter/foundation.dart';

@immutable
class Geometry {
  final List<dynamic>? coordinates;
  final String? type;

  const Geometry({this.coordinates, this.type});

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates:
            (json['coordinates'] as List<dynamic>?)?.map((e) => e).toList(),
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
        'type': type,
      };

  Geometry copyWith({
    List<dynamic>? coordinates,
    String? type,
  }) {
    return Geometry(
      coordinates: coordinates ?? this.coordinates,
      type: type ?? this.type,
    );
  }
}
