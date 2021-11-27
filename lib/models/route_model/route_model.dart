import 'package:flutter/foundation.dart';

import 'route.dart';
import 'waypoint.dart';

@immutable
class RouteModel {
  final String? code;
  final List<ApiWaypoint>? waypoints;
  final List<Route>? routes;

  const RouteModel({this.code, this.waypoints, this.routes});

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
        code: json['code'] as String?,
        waypoints: (json['waypoints'] as List<dynamic>?)
            ?.map((e) => ApiWaypoint.fromJson(e as Map<String, dynamic>))
            .toList(),
        routes: (json['routes'] as List<dynamic>?)
            ?.map((e) => Route.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'waypoints': waypoints?.map((e) => e.toJson()).toList(),
        'routes': routes?.map((e) => e.toJson()).toList(),
      };

  RouteModel copyWith({
    String? code,
    List<ApiWaypoint>? waypoints,
    List<Route>? routes,
  }) {
    return RouteModel(
      code: code ?? this.code,
      waypoints: waypoints ?? this.waypoints,
      routes: routes ?? this.routes,
    );
  }
}
