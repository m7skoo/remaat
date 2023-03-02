part of 'accept_bloc.dart';

@immutable
abstract class AcceptEvent extends Equatable {
  const AcceptEvent();
}

class LoadAccetpt extends AcceptEvent {
  @override
  List<Object> get props => [];
}
