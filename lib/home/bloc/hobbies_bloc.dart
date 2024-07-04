import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hobbies/app/enum.dart';
import 'package:hobbies/home/model/list_model.dart';
import 'package:hobbies/home/repository/home_repo.dart';

part 'hobbies_event.dart';
part 'hobbies_state.dart';

class HobbiesBloc extends Bloc<HobbiesEvent, HobbiesState> {
  HobbiesBloc({required IHobbiesRepo hobbiesRepo})
      : _allHobbiesRepo = hobbiesRepo,
        super(const HobbyListingState.initial()) {
    on<GetHobbiesEvent>(getData);
  }

  final IHobbiesRepo _allHobbiesRepo;

  Future<void> getData(GetHobbiesEvent event, Emitter<HobbiesState> emit) async {
    try {
      emit(const HobbyListingState.loading());
      final response = await _allHobbiesRepo.getHobbies();
      if (response?.isNotEmpty ?? true) {
        emit(HobbyListingState.loaded(listHobbies: response));
      } else {
        emit(const HobbyListingState.isFailed(errorMessage: 'could you please provide valid message!'));
      }
    } catch (e) {
      emit(HobbyListingState.isError(errorMsg: e.toString()));
    }
  }
}
