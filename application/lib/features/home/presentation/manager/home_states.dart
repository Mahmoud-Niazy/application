abstract class HomeStates{}

class HomeInitialState extends HomeStates{}

class HomeErrorState extends HomeStates{
  final String error;
  HomeErrorState(this.error);
}

class GetAllUsersLoadingState extends HomeStates{}
class GetAllUsersSuccessState extends HomeStates{}
