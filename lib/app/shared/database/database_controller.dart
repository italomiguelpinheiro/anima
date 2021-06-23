import 'package:anima/app/shared/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:usage_stats/usage_stats.dart';

import 'events_repository/events_database_repository_interface.dart';
import 'usage_reposiroty/usage_database_repository_interface.dart';

part 'database_controller.g.dart';

class DatabaseController = _DatabaseControllerBase with _$DatabaseController;

abstract class _DatabaseControllerBase with Store {
  final IEventsDatabaseRepository _eventsDatabaseRepository = Modular.get();
  final IUsageDatabaseRepository _usageDatabaseRepository = Modular.get();

  @observable
  SyncStatus status = SyncStatus.loading;

  @action
  CollectionReference<EventModel> getEvents() {
    return _eventsDatabaseRepository.getEvents();
  }

  @action
  Future<void> addEvents(List<EventUsageInfo> usageInfoList) async {
    usageInfoList.forEach((element) async {
      await _eventsDatabaseRepository.addEvent(element.eventType,
          element.timeStamp, element.packageName, element.className);
    });
  }

  @action
  Future<void> addUsage(List<UsageInfo> usageInfoList) async {
    usageInfoList.forEach((element) async {
      await _usageDatabaseRepository.addUsage(
          element.firstTimeStamp,
          element.lastTimeStamp,
          element.packageName,
          element.lastTimeUsed,
          element.totalTimeInForeground);
    });
  }
}

enum SyncStatus { loading, off, complete }