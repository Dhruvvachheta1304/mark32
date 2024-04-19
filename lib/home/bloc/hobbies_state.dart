part of 'hobbies_bloc.dart';

@immutable
abstract class HobbiesState {
  const HobbiesState();
}

class HobbyListingState extends HobbiesState {
  final List<HobbiesModel>? listHobbies;
  final String? errorMessage;
  final Status status;

  const HobbyListingState._({
    this.errorMessage,
    required this.status,
    this.listHobbies,
  });

  const HobbyListingState.initial() : this._(status: Status.initial);

  const HobbyListingState.loaded({required List<HobbiesModel>? listHobbies})
      : this._(status: Status.loaded, listHobbies: listHobbies);

  const HobbyListingState.isFailed({required String? errorMessage})
      : this._(
          status: Status.isFailed,
          errorMessage: errorMessage,
        );

  const HobbyListingState.loading() : this._(status: Status.loading);

  const HobbyListingState.isError({required String? errorMsg})
      : this._(
          status: Status.error,
          errorMessage: errorMsg,
        );
}
