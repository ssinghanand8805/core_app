import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/constants.dart';
import '../../l10n/translation_keys.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final subColor = isDark ? Colors.white54 : Colors.black45;
    final cardColor = isDark ? const Color(0xFF141A19) : Colors.white;

    return Scaffold(
      appBar: AppBar(title: Text(TKeys.settings.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader(label: TKeys.theme.tr, textColor: subColor),
          const SizedBox(height: 8),
          Card(
            color: cardColor,
            child: Column(
              children: [
                _ThemeTile(label: TKeys.light.tr,  mode: ThemeMode.light,  textColor: textColor, subColor: subColor),
                const Divider(height: 1, indent: 56),
                _ThemeTile(label: TKeys.dark.tr,   mode: ThemeMode.dark,   textColor: textColor, subColor: subColor),
                const Divider(height: 1, indent: 56),
                _ThemeTile(label: TKeys.system.tr, mode: ThemeMode.system, textColor: textColor, subColor: subColor),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _SectionHeader(label: TKeys.selectLanguage.tr, textColor: subColor),
          const SizedBox(height: 8),
          Card(
            color: cardColor,
            child: Column(
              children: [
                _LangTile(label: 'English',  locale: const Locale('en', 'US'), textColor: textColor),
                const Divider(height: 1, indent: 56),
                _LangTile(label: 'हिंदी',     locale: const Locale('hi', 'IN'), textColor: textColor),
                const Divider(height: 1, indent: 56),
                _LangTile(label: 'العربية',  locale: const Locale('ar', 'SA'), textColor: textColor),
                const Divider(height: 1, indent: 56),
                _LangTile(label: 'اردو',      locale: const Locale('ur', 'PK'), textColor: textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color textColor;
  const _SectionHeader({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 4),
    child: Text(label.toUpperCase(),
        style: TextStyle(fontSize: 11, letterSpacing: 1.2,
            fontWeight: FontWeight.w600, color: textColor)),
  );
}

class _ThemeTile extends StatelessWidget {
  final String label;
  final ThemeMode mode;
  final Color textColor;
  final Color subColor;
  const _ThemeTile({required this.label, required this.mode, required this.textColor, required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = ThemeService.to.themeMode;
      final selected = current == mode;
      return ListTile(
        leading: Icon(
          mode == ThemeMode.light ? Icons.light_mode_rounded
              : mode == ThemeMode.dark ? Icons.dark_mode_rounded
              : Icons.brightness_auto_rounded,
          color: selected ? const Color(0xFF00C9B1) : subColor,
        ),
        title: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        trailing: selected
            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF00C9B1))
            : null,
        onTap: () => ThemeService.to.setTheme(mode),
      );
    });
  }
}

class _LangTile extends StatelessWidget {
  final String label;
  final Locale locale;
  final Color textColor;
  const _LangTile({required this.label, required this.locale, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final current = Get.locale;
    final selected = current?.languageCode == locale.languageCode;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: selected
            ? const Color(0xFF00C9B1).withOpacity(0.15)
            : Colors.transparent,
        child: Text(locale.languageCode.toUpperCase(),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? const Color(0xFF00C9B1) : textColor)),
      ),
      title: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: Color(0xFF00C9B1))
          : null,
      onTap: () {
        Get.updateLocale(locale);
        StorageService.to.setString(key: AppConstants.localeKey, value: locale.languageCode);
      },
    );
  }
}