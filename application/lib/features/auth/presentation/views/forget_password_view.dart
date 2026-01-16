import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/router/app_routes_names.dart';
import 'package:test/core/service%20locator/service_locator.dart';
import 'package:test/core/utils/app_colors.dart';
import 'package:test/core/utils/app_styles.dart';
import 'package:test/core/widgets/custom_button.dart';
import 'package:test/core/widgets/custom_loading_widget.dart';
import 'package:test/core/widgets/custom_text_form_field.dart';
import 'package:test/core/widgets/show_snack_bar.dart';
import 'package:test/features/auth/presentation/manager/auth_cubit.dart';
import 'package:test/features/auth/presentation/manager/auth_states.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  static var emailController = TextEditingController();
  static var formKey = GlobalKey<FormState>();

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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // AppLogo(),
                  SizedBox(height: 30),
                  Text("Please enter your email", style: AppStyles.style20),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    pIcon: Icons.email_outlined,
                    title: "Email",
                    controller: emailController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "We will send you a code",
                    style: AppStyles.style13.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 40),
                  BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) async {
                      if (state is ForgetPasswordSuccessfullyState) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutesNames.resetPassword,
                          arguments: emailController.text.trim(),
                          (_) => false,
                        );
                        CustomSnackBar.show(
                          context: context,
                          label:
                              "If your email is exist you will receive an email immediately",
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
                      if (state is ForgetPasswordLoadingState) {
                        return CustomLoadingWidget();
                      }
                      return Positioned(
                        bottom: 20,
                        right: 0,
                        left: 0,
                        child: CustomButton(
                          backgroundColor: AppColors.primaryColor,
                          title: "Confirm",
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              cubit.forgetPassword(
                                email: emailController.text.trim(),
                              );
                            }
                            // await validate(context);
                          },
                        ),
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
