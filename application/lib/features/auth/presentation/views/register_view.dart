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
import 'package:test/features/auth/data/models/user_registration_request_model.dart';
import 'package:test/features/auth/presentation/manager/auth_cubit.dart';
import 'package:test/features/auth/presentation/manager/auth_states.dart';

class RegisterView extends StatelessWidget {
  static var emailController = TextEditingController();
  static var passwordController = TextEditingController();
  static var confirmPasswordController = TextEditingController();
  static var phoneController = TextEditingController();
  static var nameController = TextEditingController();
  static var formKey = GlobalKey<FormState>();

  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<AuthCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppLogo(),
                      SizedBox(height: 40),
                      Text("Register now", style: AppStyles.style25),
                      SizedBox(height: 30),
                      CustomTextFormField(
                        title: "Name",
                        pIcon: Icons.person,
                        controller: nameController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        title: "Email",
                        keyboardType: TextInputType.emailAddress,
                        pIcon: Icons.email_outlined,
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        title: "Password",
                        pIcon: Icons.lock_open,
                        isSuffixIconShown: true,
                        isPassword: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        title: "Confirm Password",
                        pIcon: Icons.lock_open,
                        isSuffixIconShown: true,
                        isPassword: true,
                        controller: confirmPasswordController,
                      ),

                      SizedBox(height: 30),
                      BlocConsumer<AuthCubit, AuthStates>(
                        listener: (context, state) async {
                          if (state is SignUpSuccessfullyState) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutesNames.emailVerify,
                              arguments: emailController.text.trim(),
                              (_) => false,
                            );
                            CustomSnackBar.show(
                              context: context,
                              label: "Register successfully",
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
                          if (state is SignUpLoadingState) {
                            return CustomLoadingWidget();
                          }
                          return CustomButton(
                            backgroundColor: AppColors.primaryColor,
                            title: "Sign up",
                            onPressed: () {
                              if (passwordController.text.trim() !=
                                  confirmPasswordController.text.trim()) {
                                CustomSnackBar.show(
                                  context: context,
                                  label: "2-Password must be identical",
                                  status: SnackBarStatus.warning,
                                );
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                cubit.signUp(
                                  UserRegistrationRequestModel(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text.trim(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
