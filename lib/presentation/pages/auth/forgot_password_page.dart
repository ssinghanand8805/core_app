import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/translation_keys.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/gym_button.dart';
import '../../widgets/gym_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ctrl         = AuthController.to;
  final _otpCtrl     = TextEditingController();
  final _emailFpCtrl = TextEditingController();
  int   _resendTimer = 0;
  Timer? _timer;

  @override
  void dispose() {
    _otpCtrl.dispose();
    _emailFpCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer <= 0) { t.cancel(); return; }
      setState(() => _resendTimer--);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const teal   = Color(0xFF00C9B1);
    final bg     = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          onPressed: () { ctrl.resetFpFlow(); Get.back(); },
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : const Color(0xFF0D1F1C), size: 18),
        ),
        title: Text(TKeys.forgotPassword.tr,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0D1F1C),
              fontWeight: FontWeight.w700, fontSize: 17,
            )),
      ),
      body: Obx(() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                .animate(anim),
            child: child,
          ),
        ),
        child: _buildStep(ctrl.fpStep.value, isDark, teal),
      )),
    );
  }

  Widget _buildStep(int step, bool isDark, Color teal) {
    switch (step) {
      case 0: return _StepEmail(ctrl: ctrl, emailCtrl: _emailFpCtrl, isDark: isDark, teal: teal, onSend: _startResendTimer);
      case 1: return _StepOtp(ctrl: ctrl, otpCtrl: _otpCtrl, isDark: isDark, teal: teal, resendTimer: _resendTimer, onResend: _startResendTimer);
      default: return _StepNewPass(ctrl: ctrl, isDark: isDark, teal: teal);
    }
  }
}

class _StepEmail extends StatelessWidget {
  final AuthController ctrl;
  final TextEditingController emailCtrl;
  final bool isDark;
  final Color teal;
  final VoidCallback onSend;
  const _StepEmail({required this.ctrl, required this.emailCtrl, required this.isDark, required this.teal, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(28),
      child: Form(
        key: ctrl.fpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(TKeys.email.tr,
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0D1F1C),
                    fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(TKeys.enterOtp.tr,
                style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13)),
            const SizedBox(height: 28),
            GymTextField(
              controller:   emailCtrl,
              hintText:     TKeys.email.tr,
              prefixIcon:   Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator:    ctrl.validateEmail,
            ),
            const SizedBox(height: 24),
            Obx(() => GymButton(
              label:     TKeys.sendOtp.tr,
              isLoading: ctrl.isLoading.value,
              onPressed: () {
                ctrl.fpEmail.value = emailCtrl.text.trim();
                ctrl.sendForgotOtp();
                onSend();
              },
            )),
          ],
        ),
      ),
    );
  }
}

class _StepOtp extends StatelessWidget {
  final AuthController ctrl;
  final TextEditingController otpCtrl;
  final bool isDark;
  final Color teal;
  final int resendTimer;
  final VoidCallback onResend;
  const _StepOtp({required this.ctrl, required this.otpCtrl, required this.isDark,
    required this.teal, required this.resendTimer, required this.onResend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(TKeys.verifyOtp.tr,
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0D1F1C),
                  fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(TKeys.enterOtp.tr,
              style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13)),
          const SizedBox(height: 32),
          _OtpRow(otpCtrl: otpCtrl, isDark: isDark, teal: teal, onChanged: (v) => ctrl.fpOtp.value = v),
          const SizedBox(height: 12),
          Center(
            child: resendTimer > 0
                ? Text('Resend in ${resendTimer}s',
                style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13))
                : TextButton(
              onPressed: () { ctrl.sendForgotOtp(); onResend(); },
              child: Text(TKeys.resendOtp.tr,
                  style: const TextStyle(color: Color(0xFF00C9B1), fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
          Obx(() => GymButton(
            label:     TKeys.verifyOtp.tr,
            isLoading: ctrl.isLoading.value,
            onPressed: ctrl.verifyForgotOtp,
          )),
        ],
      ),
    );
  }
}

class _OtpRow extends StatelessWidget {
  final TextEditingController otpCtrl;
  final bool isDark;
  final Color teal;
  final ValueChanged<String> onChanged;
  const _OtpRow({required this.otpCtrl, required this.isDark, required this.teal, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:  otpCtrl,
      keyboardType: TextInputType.number,
      maxLength:   6,
      textAlign:   TextAlign.center,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF0D1F1C),
        fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 16,
      ),
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: isDark ? const Color(0xFF1C2523) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: teal, width: 1.5),
        ),
        hintText: '------',
        hintStyle: TextStyle(color: isDark ? Colors.white12 : Colors.black12,
            fontSize: 28, letterSpacing: 16),
      ),
      onChanged: onChanged,
    );
  }
}

class _StepNewPass extends StatelessWidget {
  final AuthController ctrl;
  final bool isDark;
  final Color teal;
  const _StepNewPass({required this.ctrl, required this.isDark, required this.teal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(TKeys.resetPassword.tr,
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0D1F1C),
                  fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 28),
          GymTextField(
            controller: ctrl.newPassCtrl,
            hintText:   TKeys.newPassword.tr,
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 14),
          GymTextField(
            controller: ctrl.confirmPassCtrl,
            hintText:   TKeys.confirmPassword.tr,
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 28),
          Obx(() => GymButton(
            label:     TKeys.resetPassword.tr,
            isLoading: ctrl.isLoading.value,
            onPressed: ctrl.doResetPassword,
          )),
        ],
      ),
    );
  }
}