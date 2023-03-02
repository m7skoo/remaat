// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:remaat/model/accept_model.dart';
import 'package:remaat/repository/data_controller.dart';
import 'package:remaat/util/share_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'accept_event.dart';
part 'accept_state.dart';

class AcceptBloc extends Bloc<AcceptEvent, AcceptState> {
  final GetDataFromAPI _getDataFromAPI;
  final String token;
  final int driverId;
  AcceptBloc(this._getDataFromAPI, this.token, this.driverId)
      : super(AcceptLoadingState()) {
    on<LoadAccetpt>((event, emit) async {
      SharedPreferences sher = await SharedPreferences.getInstance();
      emit(AcceptLoadingState());

      try {
        final result = await _getDataFromAPI.getDataAccept(
            sher.getString(ShareConst.token), sher.getInt(ShareConst.driverId));
        emit(AcceptLoadedState(result));
      } catch (e) {
        emit(AcceptErrorState(e.toString()));
      }
    });
  }
}
