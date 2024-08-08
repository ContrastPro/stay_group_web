part of 'calculations_bloc.dart';

@immutable
abstract class CalculationsEvent {
  const CalculationsEvent();
}

class GetCalculations extends CalculationsEvent {
  const GetCalculations();
}

class DeleteCalculation extends CalculationsEvent {
  const DeleteCalculation({
    required this.id,
  });

  final String id;
}
