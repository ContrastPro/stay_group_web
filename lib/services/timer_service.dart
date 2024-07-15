import 'dart:async';

class TimerService {
  const TimerService._();

  static const TimerService instance = TimerService._();

  Timer startTimer({
    bool addInitialTick = false,
    Duration tick = const Duration(
      milliseconds: 30000,
    ),
    required void Function() onTick,
  }) {
    if (addInitialTick) onTick();

    return Timer.periodic(tick, (_) {
      onTick();
    });
  }
}
