import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BeneficiaryModel', () {
    test('should correctly compare two instances for equality', () {
      const beneficiary1 = BeneficiaryModel(
        id: '1',
        nickname: 'nickname1',
        phoneNumber: '+201234567890',
        availableBalance: 100.0,
      );

      const beneficiary2 = BeneficiaryModel(
        id: '1',
        nickname: 'nickname1',
        phoneNumber: '+201234567890',
        availableBalance: 100.0,
      );

      expect(beneficiary1, equals(beneficiary2));
    });

    test('should convert to JSON correctly', () {
      const beneficiary = BeneficiaryModel(
        id: '1',
        nickname: 'nickname1',
        phoneNumber: '+201234567890',
        availableBalance: 100.0,
      );

      final json = beneficiary.toJson();
      expect(json, {
        'id': '1',
        'nickname': 'nickname1',
        'phoneNumber': '+201234567890',
        'availableBalance': 100.0,
      });
    });
  });

  group('UserData', () {
    test('should correctly compare two instances for equality', () {
      const userData1 = UserData(
        balance: 500.0,
        beneficiaries: [
          BeneficiaryModel(
            id: '1',
            nickname: 'nickname1',
            phoneNumber: '+201234567890',
            availableBalance: 100.0,
          ),
        ],
        availableBalance: 300.0,
        maxNumberOfBeneficiariesAllowed: 5,
      );

      const userData2 = UserData(
        balance: 500.0,
        beneficiaries: [
          BeneficiaryModel(
            id: '1',
            nickname: 'nickname1',
            phoneNumber: '+201234567890',
            availableBalance: 100.0,
          ),
        ],
        availableBalance: 300.0,
        maxNumberOfBeneficiariesAllowed: 5,
      );

      expect(userData1, equals(userData2));
    });

    test('should convert to JSON correctly', () {
      const userData = UserData(
        balance: 500.0,
        beneficiaries: [
          BeneficiaryModel(
            id: '1',
            nickname: 'nickname1',
            phoneNumber: '+201234567890',
            availableBalance: 100.0,
          ),
        ],
        availableBalance: 300.0,
        maxNumberOfBeneficiariesAllowed: 5,
      );

      final json = userData.toJson();
      expect(json, {
        'numbers': [
          {
            'id': '1',
            'nickname': 'nickname1',
            'phoneNumber': '+201234567890',
            'availableBalance': 100.0,
          },
        ],
        'balance': 500.0,
        'availableBalance': 300.0,
        'maxNumberOfBeneficiariesAllowed': 5,
      });
    });
  });
}
