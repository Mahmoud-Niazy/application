import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/router/app_routes_names.dart';
import 'package:test/core/service%20locator/service_locator.dart';
import 'package:test/core/utils/app_colors.dart';
import 'package:test/core/utils/app_styles.dart';
import 'package:test/core/widgets/custom_button.dart';
import 'package:test/core/widgets/custom_loading_widget.dart';
import 'package:test/core/widgets/custom_text_button.dart';
import 'package:test/core/widgets/custom_text_form_field.dart';
import 'package:test/core/widgets/show_snack_bar.dart';
import 'package:test/features/auth/presentation/manager/auth_cubit.dart';
import 'package:test/features/auth/presentation/manager/auth_states.dart';

class LoginView extends StatelessWidget {
  static var emailController = TextEditingController();
  static var passwordController = TextEditingController();
  static var formKey = GlobalKey<FormState>();

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AuthCubit>(),
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
                      Text("Login", style: AppStyles.style25),
                      SizedBox(height: 30),
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
                        isPassword: true,
                        isSuffixIconShown: true,
                        controller: passwordController,
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomTextButton(
                          title: "Forget password ?",
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutesNames.forgetPassword,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 50),
                      BlocConsumer<AuthCubit, AuthStates>(
                        listener: (context, state) async {
                          if (state is SignInSuccessfullyState) {
                              Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutesNames.layout,
                          (_) => false,
                        );
                            CustomSnackBar.show(
                              context: context,
                              label: "Login successfully",
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
                          if (state is SignInLoadingState) {
                            return CustomLoadingWidget();
                          }
                          return CustomButton(
                            backgroundColor: AppColors.primaryColor,
                            title: "Login",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: AppStyles.style13.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          CustomTextButton(
                            title: "Sign up now",
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutesNames.register,
                              );
                            },
                          ),
                        ],
                      ),
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
