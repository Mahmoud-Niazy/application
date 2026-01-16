import 'package:flutter/material.dart';
import 'package:test/core/cache/cache_helper.dart';
import 'package:test/core/router/app_routes_names.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<void> navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      CacheHelper.token != null ? AppRoutesNames.layout :
       AppRoutesNames.login,
      (_) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
