part of 'accept_bloc.dart';

@immutable
abstract class AcceptState extends Equatable {
  const AcceptState();
}

class AcceptLoadingState extends AcceptState {
  @override
  List<Object> get props => [];
}

class AcceptLoadedState extends AcceptState {
  const AcceptLoadedState(this.data);
  final List<AcceptOrder> data;
  @override
  List<Object> get props => [data];
}

class AcceptErrorState extends AcceptState {
  const AcceptErrorState(this.error);
  final String error;
  @override
  List<Object> get props => [error];
}
