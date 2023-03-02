// import 'dart:convert';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:remaat/model/user.dart';
// import 'package:remaat/repository/data_controller.dart';
// import 'package:remaat/util/share_const.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final GetDataFromAPI _getDataFromAPI;
//   AuthBloc(this._getDataFromAPI) : super(LoginInState()) {
//     on<AuthEvent>((event, emit) async {
//       var pref = await SharedPreferences.getInstance();
//       emit(LoginInState());
//       if (event is LogiButtonPressed) {
//         try {
//           var data = await _getDataFromAPI.login(event.email, event.password);
//           final respo = UserModel.fromJson(jsonDecode(data.body));
//           // ignore: unrelated_type_equality_checks
//           if (respo.token != null) {
//             pref.setString(ShareConst.token, respo.token!);
//             pref.setString(ShareConst.name, respo.user!.name!);
//             pref.setString(ShareConst.email, respo.user!.email!);
//             pref.setInt(ShareConst.driverId, respo.driverId!);
//             emit(AuthAdminLoginSuccessState());
//           } else if (respo.driverId == respo.driverId) {
//             emit(AuthAdminLoginSuccessState());
//           }
//         } catch (e) {
//           emit(AuthErrorState(error: e.toString()));
//         }
//       }
//     });
//   }
// }
