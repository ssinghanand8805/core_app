import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserEntity u = Get.arguments as UserEntity;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? Colors.white : const Color(0xFF0D1F1C);
    final sub = isDark ? Colors.white54 : Colors.black45;
    final bg = isDark ? const Color(0xFF0A0F0E) : const Color(0xFFF4F7F6);
    const teal = Color(0xFF00C9B1);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: bg,
            surfaceTintColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: isDark ? Colors.white : const Color(0xFF0D1F1C),
                    size: 16),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [teal.withOpacity(0.80), const Color(0xFF00A896)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.40),
                                width: 2),
                          ),
                          child: Center(
                              child: Text(u.name[0],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800))),
                        ),
                        const SizedBox(height: 14),
                        Text(u.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('@${u.username}',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 13)),
                      ]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                _InfoCard(isDark: isDark, text: text, sub: sub, items: [
                  _InfoItem(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: u.email),
                  _InfoItem(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: u.phone),
                  _InfoItem(
                      icon: Icons.language_rounded,
                      label: 'Website',
                      value: u.website),
                ]),
                const SizedBox(height: 12),
                _InfoCard(isDark: isDark, text: text, sub: sub, items: [
                  _InfoItem(
                      icon: Icons.badge_outlined,
                      label: 'Username',
                      value: u.username),
                  _InfoItem(
                      icon: Icons.tag_rounded,
                      label: 'User ID',
                      value: '#${u.id}'),
                ]),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final bool isDark;
  final Color text, sub;
  final List<_InfoItem> items;
  const _InfoCard(
      {required this.isDark,
      required this.text,
      required this.sub,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141A19) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00C9B1).withOpacity(0.08)),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final last = e.key == items.length - 1;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C9B1).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(item.icon, color: const Color(0xFF00C9B1), size: 16),
                ),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.label,
                      style: TextStyle(
                          color: sub,
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                  Text(item.value,
                      style: TextStyle(
                          color: text,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ]),
              ]),
            ),
            if (!last)
              Divider(
                  height: 1,
                  indent: 56,
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05)),
          ]);
        }).toList(),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label, value;
  const _InfoItem(
      {required this.icon, required this.label, required this.value});
}
