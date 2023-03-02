// ignore: depend_on_referenced_packages
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:remaat/model/order_model.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/util/share_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetDataFromAPI _getDataFromAPI;
  final String token;
  OrderBloc(this._getDataFromAPI, this.token) : super(OrderLoadingState()) {
    on<LoadOrder>((event, emit) async {
      SharedPreferences sher = await SharedPreferences.getInstance();
      //  token = sher.getString(ShareConst.token);
      emit(OrderLoadingState());

      try {
        final result =
            await _getDataFromAPI.getData(sher.getString(ShareConst.token));
        emit(OrderLoadedState(result));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });
  }
  // Stream<List<Orders>> get data async* {
  //   SharedPreferences sher = await SharedPreferences.getInstance();
  //   yield* _getDataFromAPI.getData(token).asStream();
  // }
}
