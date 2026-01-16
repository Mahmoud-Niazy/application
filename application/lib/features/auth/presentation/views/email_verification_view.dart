import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/router/app_routes_names.dart';
import 'package:test/core/service%20locator/service_locator.dart';
import 'package:test/core/utils/app_colors.dart';
import 'package:test/core/utils/app_styles.dart';
import 'package:test/core/widgets/custom_button.dart';
import 'package:test/core/widgets/custom_loading_widget.dart';
import 'package:test/core/widgets/show_snack_bar.dart';
import 'package:test/features/auth/presentation/manager/auth_cubit.dart';
import 'package:test/features/auth/presentation/manager/auth_states.dart';

class EmailVerificationView extends StatelessWidget {
  final String email;
  const EmailVerificationView({super.key, required this.email});

  static var formKey = GlobalKey<FormState>();
  static var code1Controller = TextEditingController();
  static var code2Controller = TextEditingController();
  static var code3Controller = TextEditingController();
  static var code4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<AuthCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Please enter verification code",
                    style: AppStyles.style20,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: code1Controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(counterText: ''),
                          validator: (value) => value!.isEmpty ? '' : null,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: code2Controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(counterText: ''),
                          validator: (value) => value!.isEmpty ? '' : null,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: code3Controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(counterText: ''),
                          validator: (value) => value!.isEmpty ? '' : null,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: code4Controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(counterText: ''),
                          validator: (value) => value!.isEmpty ? '' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) async {
                      if (state is VerifyEmailSuccessfullyState) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutesNames.layout,
                          (_) => false,
                        );
                        CustomSnackBar.show(
                          context: context,
                          label: "Email verified successfully",
                          status: SnackBarStatus.success,
                        );
                      }
                      if (state is AuthErrorState) {
                        CustomSnackBar.show(
                          context: context,
                          label: state.error,
                          status: SnackBarStatus.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      var cubit = AuthCubit.get(context);
                      if (state is VerifyEmailLoadingState) {
                        return CustomLoadingWidget();
                      }
                      return CustomButton(
                        backgroundColor: AppColors.primaryColor,
                        title: "Confirm",
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            String code =
                                code1Controller.text +
                                code2Controller.text +
                                code3Controller.text +
                                code4Controller.text;
                            await cubit.verifyEmail(email: email, code: code);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
