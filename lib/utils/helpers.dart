import 'package:crypt/crypt.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/medias/media_model.dart';
import '../models/medias/media_response_model.dart';
import 'constants.dart';

String getFirstLetter(String data) {
  return data[0].toUpperCase();
}

String formatMediaSize(int fileSize) {
  return FileSize.getMegaBytes(
    fileSize,
    value: PrecisionValue.None,
  );
}

DateTime currentTime() {
  return DateTime.now();
}

int dateDifference(
  String date, {
  DateDifference type = DateDifference.days,
}) {
  final DateTime now = currentTime().toUtc();
  final DateTime dateTime = DateTime.parse(date);

  final DateTime first = DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
  );

  final DateTime other = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
  ).toUtc();

  if (type == DateDifference.seconds) {
    return first.difference(other).inSeconds;
  }

  if (type == DateDifference.minutes) {
    return first.difference(other).inMinutes;
  }

  return first.difference(other).inDays;
}

String uuid({
  bool isTimeBased = true,
}) {
  const Uuid uuid = Uuid();

  if (isTimeBased) {
    return uuid.v1();
  }

  return uuid.v4();
}

String cryptPassword(String password) {
  final Crypt crypt = Crypt.sha256(password);
  return crypt.toString();
}

bool passwordIsValid({
  required String cryptPassword,
  required String enterPassword,
}) {
  final Crypt crypt = Crypt(cryptPassword);
  return crypt.match(enterPassword);
}

String utcToLocal(
  String date, {
  DateFormat? format,
}) {
  final DateTime localDate = DateTime.parse(date).toLocal();

  final DateFormat dateFormat = format ?? DateFormat('HH:mm');
  final String formattedDate = dateFormat.format(localDate);

  return formattedDate;
}

String localToUtc(
  DateTime date, {
  bool onlyUtcFormat = false,
}) {
  if (onlyUtcFormat) {
    return date.add(date.timeZoneOffset).toUtc().toIso8601String();
  }

  return date.toUtc().toIso8601String();
}

int parseString(String data) {
  final String formatValue = data.replaceAll(RegExp(r'[^0-9]'), '');
  return int.parse(formatValue);
}

List<MediaModel> getSavedMedia({
  required List<MediaModel>? media,
  required List<MediaResponseModel> localMedia,
}) {
  final List<MediaModel> savedMedia = [];

  if (media != null) {
    for (int i = 0; i < media.length; i++) {
      final int index = localMedia.indexWhere((e) => e.id == media[i].id);

      if (index != -1) {
        savedMedia.add(media[i]);
      }
    }
  }

  return savedMedia;
}

List<MediaResponseModel> getAddedMedia({
  required List<MediaModel>? media,
  required List<MediaResponseModel> localMedia,
}) {
  final List<MediaResponseModel> addedMedia = [];

  if (media != null) {
    for (int i = 0; i < localMedia.length; i++) {
      final int index = media.indexWhere((e) => e.id == localMedia[i].id);

      if (index == -1) {
        addedMedia.add(localMedia[i]);
      }
    }
  } else {
    addedMedia.addAll(localMedia);
  }

  return addedMedia;
}

List<MediaModel> getRemovedMedia({
  required List<MediaModel>? media,
  required List<MediaResponseModel> localMedia,
}) {
  final List<MediaModel> removedMedia = [];

  if (media != null) {
    for (int i = 0; i < media.length; i++) {
      final int index = localMedia.indexWhere((e) => e.id == media[i].id);

      if (index == -1) {
        removedMedia.add(media[i]);
      }
    }
  }

  return removedMedia;
}

Future<void> requestDelay({
  Duration? duration,
}) async {
  await Future.delayed(
    duration ?? (kDebugMode ? kDebugRequestDuration : kProdRequestDuration),
  );
}
