import 'package:flutter/material.dart';
import 'package:test/core/router/app_routes_names.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/presentation/views/email_verification_view.dart';
import 'package:test/features/auth/presentation/views/forget_password_view.dart';
import 'package:test/features/auth/presentation/views/login_view.dart';
import 'package:test/features/auth/presentation/views/register_view.dart';
import 'package:test/features/auth/presentation/views/reset_password_view.dart';
import 'package:test/features/home/presentation/views/users_management_view.dart';
import 'package:test/features/layout/presentation/view/layout_view.dart';
import 'package:test/features/splash/presentation/views/splash_view.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutesNames.login:
        return MaterialPageRoute(builder: (_) => LoginView());
      case AppRoutesNames.register:
        return MaterialPageRoute(builder: (_) => RegisterView());
      case AppRoutesNames.forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordView());
      case AppRoutesNames.resetPassword:
        return MaterialPageRoute(
          builder: (_) {
            final email = settings.arguments as String;

            return ResetPasswordView(email: email);
          },
        );
      case AppRoutesNames.emailVerify:
        return MaterialPageRoute(
          builder: (_) {
            final email = settings.arguments as String;

            return EmailVerificationView(email: email);
          },
        );
      case AppRoutesNames.layout:
        return MaterialPageRoute(builder: (_) {
          return LayoutView();
        });
        case AppRoutesNames.usersManagement:
        return MaterialPageRoute(
          builder: (_) {
            final users = settings.arguments as List<UserModel>;
            return UsersManagementView(users: users,);
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
