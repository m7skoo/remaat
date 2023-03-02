import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:remaat/model/order_model.dart';
import 'package:remaat/repository/data_controller.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetDataFromAPI _getDataFromAPI;
  List<Orders> orders = [];
  OrdersCubit(this._getDataFromAPI) : super(OrdersInitial());

  List<Orders> getallOrders(token) {
    _getDataFromAPI.getData(token).then((value) => {
          emit(OrdersLoded(orders)),
          orders = value,
        });
    return orders;
  }
}
