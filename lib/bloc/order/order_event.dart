part of 'order_bloc.dart';

@immutable
abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class LoadOrder extends OrderEvent {
  @override
  List<Object> get props => [];
}
