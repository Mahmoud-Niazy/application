import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/profile/domain/use%20cases/get_profile_use_case.dart';
import 'package:test/features/profile/presentation/manager/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final GetProfileUsecase getProfileUsecase;

  ProfileCubit(this.getProfileUsecase) : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of<ProfileCubit>(context);

  UserModel? profileData;

  Future<void> getProfile() async {
    emit(GetProfileLoadingState());
    var res = await getProfileUsecase.execute();
    res.fold(
      (failure) {
        emit(ProfileErrorState(failure.error));
      },
      (profile) async {
        profileData = profile;
        emit(GetProfileSuccessState());
      },
    );
  }
}
