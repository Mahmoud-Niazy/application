abstract class ProfileStates{}

class ProfileInitialState extends ProfileStates{}

class ProfileErrorState extends ProfileStates{
  final String error;
  ProfileErrorState(this.error);
}

class GetProfileLoadingState extends ProfileStates{}
class GetProfileSuccessState extends ProfileStates{}
