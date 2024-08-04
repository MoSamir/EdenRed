import 'package:flutter/material.dart';

class BeneficiaryErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  const BeneficiaryErrorWidget(
      {super.key, required this.errorMessage, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}
