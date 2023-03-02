part of 'order_bloc.dart';

@immutable
abstract class OrderState extends Equatable {
  const OrderState();
}

class OrderLoadingState extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderLoadedState extends OrderState {
  const OrderLoadedState(this.data);
  final List<Orders> data;
  @override
  List<Object> get props => [data];
}

class OrderErrorState extends OrderState {
  const OrderErrorState(this.error);
  final String error;
  @override
  List<Object> get props => [error];
}
