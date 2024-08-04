import 'package:easy_localization/easy_localization.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:flutter/material.dart';

class BeneficiaryCard extends StatelessWidget {
  final colorBlue = const Color(0xFF6d81c6);
  final subTitleColor = const Color(0xFFc0c1c2);
  final nameColor = const Color(0xFF818bb0);

  final BeneficiaryModel beneficiary;
  final Function(BeneficiaryModel) onTopUpClick;

  const BeneficiaryCard({
    super.key,
    required this.beneficiary,
    required this.onTopUpClick,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = (MediaQuery.of(context).size.width * 0.4);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        width: cardWidth,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              beneficiary.nickname,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: nameColor),
            ),
            Text(beneficiary.phoneNumber,
                style: TextStyle(color: subTitleColor)),
            InkWell(
              onTap: () {
                onTopUpClick(beneficiary);
              },
              child: Container(
                width: cardWidth - 32,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: colorBlue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                    child: const Text(
                  'home.top_up_label',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ).tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
