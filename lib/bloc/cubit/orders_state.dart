part of 'orders_cubit.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoded extends OrdersState {
  final List<Orders> orders;
  const OrdersLoded(this.orders);
}
