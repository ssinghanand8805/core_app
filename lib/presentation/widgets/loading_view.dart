import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../l10n/translation_keys.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(TKeys.loading.tr, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}