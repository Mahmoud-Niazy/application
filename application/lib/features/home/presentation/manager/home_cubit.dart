import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/home/domain/usecases/get_all_users_use_case.dart';
import 'package:test/features/home/presentation/manager/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetAllUsersUsecase getAllUsersUsecase;

  HomeCubit(this.getAllUsersUsecase) : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

List<UserModel> users = [];
  Future<void> getAllUsers() async {
    emit(GetAllUsersLoadingState());
    var res = await getAllUsersUsecase.execute();
    res.fold(
      (failure) {
        emit(HomeErrorState(failure.error));
      },
      (data) async {
        users = data;
        emit(GetAllUsersSuccessState());
      },
    );
  }
}
