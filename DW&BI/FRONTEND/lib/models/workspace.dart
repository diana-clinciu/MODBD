import 'package:mvvm_flutter/api/client_api.dart';

class Workspace {
  final int id;
  final String name;
  final String address;
  final List<String> tags;
  final List<int> tagIds;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final List<String> imageUrls;
  final int maxSeats;
  final Map<int, WorkspaceSchedule?> schedule;

  Workspace({
    required this.id,
    required this.name,
    required this.address,
    required this.tags,
    required this.tagIds,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.imageUrls,
    required this.maxSeats,
    required this.schedule,
  });

  static Workspace fromJson(JSON jsonBody) {
    return Workspace(
        id: jsonBody["id"],
        name: jsonBody["name"],
        address: jsonBody["address"],
        tags: (jsonBody["tags"] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        tagIds: (jsonBody["tagIds"] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [],
        latitude: (jsonBody["latitude"] as num).toDouble(),
        longitude: (jsonBody["longitude"] as num).toDouble(),
        imageUrl: jsonBody["imageUrl"] as String?,
        imageUrls: (jsonBody["imageUrls"] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        maxSeats: jsonBody["maxAvailableSeats"],
        schedule: _deserializeSchedule(jsonBody["schedule"] as List<dynamic>?));
  }

  static Map<int, WorkspaceSchedule?> _deserializeSchedule(
      List<dynamic>? json) {
    final Map<int, WorkspaceSchedule?> scheduleMap = {};
    for (int i = 1; i <= 7; i++) {
      if (json != null && json.length >= i && json[i - 1] != null) {
        scheduleMap[i] = WorkspaceSchedule.fromJson(json[i - 1]);
      } else {
        scheduleMap[i] = null;
      }
    }
    return scheduleMap;
  }
}

class WorkspaceSchedule {
  final String openHour;
  final String closeHour;

  WorkspaceSchedule({required this.openHour, required this.closeHour});

  factory WorkspaceSchedule.fromJson(JSON json) {
    return WorkspaceSchedule(
      openHour: json['openHour'] as String,
      closeHour: json['closeHour'] as String,
    );
  }
}
