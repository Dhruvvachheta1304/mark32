// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mark2/app/enum.dart';
// import 'package:mark2/model/list_model.dart';
// import 'package:mark2/repository/home_repo.dart';
//
// part 'hobbies_event.dart';
//
// part 'hobbies_state.dart';
//
// class HobbiesBloc extends Bloc<HobbiesEvent, HobbiesState> {
//   HobbiesBloc({required IHobbiesRepo iHobbiesRepo})
//       : _iHobbiesRepo = iHobbiesRepo,
//         super(const HobbiesListingState.initial()) {
//     on<GetHobbiesDataEvent>(getHobbiesData);
//   }
//
//   final IHobbiesRepo _iHobbiesRepo;
//
//   Future<void> getHobbiesData(GetHobbiesDataEvent event, Emitter<HobbiesState> emit) async {
//     try {
//       emit(const HobbiesListingState.loading());
//       final res = await _iHobbiesRepo.getData();
//       if (res?.isNotEmpty ?? true) {
//         emit(HobbiesListingState.success(listHobbies: res));
//       } else {
//         emit(const HobbiesListingState.failed(errorMsg: '.'));
//       }
//     } catch (e) {
//       emit(HobbiesListingState.error(errorMsg: e.toString()));
//     }
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark2/app/enum.dart';
import 'package:mark2/home/model/list_model.dart';
import 'package:mark2/home/repository/home_repo.dart';

part 'hobbies_event.dart';
part 'hobbies_state.dart';

class AllHobbiesBloc extends Bloc<HobbiesEvent, AllHobbiesState> {
  AllHobbiesBloc({required IHobbiesRepo hobbiesRepo})
      : _allHobbiesRepo = hobbiesRepo,
        super(const HobbyListingState.initial()) {
    on<GetHobbiesEvent>(getData);
  }

  final IHobbiesRepo _allHobbiesRepo;

  Future<void> getData(GetHobbiesEvent event, Emitter<AllHobbiesState> emit) async {
    try {
      emit(const HobbyListingState.loading());
      final response = await _allHobbiesRepo.getHobbies();
      if (response?.isNotEmpty ?? true) {
        emit(HobbyListingState.loaded(listHobbies: response));
      } else {
        emit(const HobbyListingState.isFailed(errorMessage: 'could you please provide valid message!'));
      }
    } catch (e) {
      emit(HobbyListingState.isError(errorMessage: e.toString()));
    }
  }
}
