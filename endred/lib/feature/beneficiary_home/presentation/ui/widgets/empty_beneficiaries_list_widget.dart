import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyBeneficiaryWidget extends StatelessWidget {
  const EmptyBeneficiaryWidget({super.key, this.action});
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'home.add_your_first_beneficiary',
            ).tr(),
            action ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
