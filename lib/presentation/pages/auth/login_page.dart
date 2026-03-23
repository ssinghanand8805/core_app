import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/gym_button.dart';
import '../../widgets/gym_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = AuthController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const teal   = Color(0xFF00C9B1);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 60),

              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C9B1), Color(0xFF00A896)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: teal.withOpacity(0.35),
                      blurRadius: 24, offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),

              Text(TKeys.appName.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0D1F1C),
                    fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1,
                  )),
              const SizedBox(height: 4),
              Text(TKeys.tagline.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 13,
                  )),
              const SizedBox(height: 48),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(TKeys.welcomeBack.tr,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0D1F1C),
                      fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5,
                    )),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'admin@gym.com / trainer@gym.com / user@gym.com  |  any password',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Form(
                key: ctrl.loginFormKey,
                child: Column(
                  children: [
                    GymTextField(
                      controller:   ctrl.emailCtrl,
                      hintText:     TKeys.email.tr,
                      prefixIcon:   Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator:    ctrl.validateEmail,
                    ),
                    const SizedBox(height: 14),
                    Obx(() => GymTextField(
                      controller:  ctrl.passwordCtrl,
                      hintText:    TKeys.password.tr,
                      prefixIcon:  Icons.lock_outline_rounded,
                      obscureText: !ctrl.showPassword.value,
                      validator:   ctrl.validatePassword,
                      suffixIcon: IconButton(
                        onPressed: ctrl.toggleShowPassword,
                        icon: Icon(
                          ctrl.showPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey, size: 20,
                        ),
                      ),
                    )),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Obx(() => GestureDetector(
                          onTap: ctrl.toggleRememberMe,
                          child: Row(children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 20, height: 20,
                              decoration: BoxDecoration(
                                color: ctrl.rememberMe.value ? teal : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: ctrl.rememberMe.value ? teal : Colors.grey.shade400,
                                ),
                              ),
                              child: ctrl.rememberMe.value
                                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(TKeys.rememberMe.tr,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black54,
                                  fontSize: 13,
                                )),
                          ]),
                        )),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(TKeys.forgotPassword.tr,
                              style: const TextStyle(color: teal, fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    Obx(() => GymButton(
                      label:     TKeys.login.tr,
                      onPressed: ctrl.login,
                      isLoading: ctrl.isLoading.value,
                      icon:      Icons.login_rounded,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}