part of 'calculations_bloc.dart';

@immutable
abstract class CalculationsEvent {
  const CalculationsEvent();
}

class Init extends CalculationsEvent {
  const Init();
}

class DeleteCalculation extends CalculationsEvent {
  const DeleteCalculation({
    required this.id,
  });

  final String id;
}
