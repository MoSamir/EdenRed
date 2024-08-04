import 'dart:convert';

import 'package:endred/feature/beneficiary_home/data/data_sources/mapper/beneficiary_response_mapper.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BeneficiaryResponseMapperImpl mapper;

  setUp(() {
    mapper = BeneficiaryResponseMapperImpl();
  });

  group('BeneficiaryResponseMapperImpl', () {
    test('should map valid JSON response to UserData', () {
      // Arrange
      const jsonString =
          '{"balance": 1300, "numbers": [{"id": "1", "nickname": "nickname1", "phoneNumber": "+201013615170", "availableBalance": 1000}, {"id": "2", "nickname": "nickname2", "phoneNumber": "+201013615171", "availableBalance": 50}], "availableBalance": 800, "maxNumberOfBeneficiariesAllowed": 5}';
      final jsonResponse = jsonDecode(jsonString);

      const expectedUserData = UserData(
        balance: 1300,
        beneficiaries: [
          BeneficiaryModel(
            id: '1',
            nickname: 'nickname1',
            phoneNumber: '+201013615170',
            availableBalance: 1000,
          ),
          BeneficiaryModel(
            id: '2',
            nickname: 'nickname2',
            phoneNumber: '+201013615171',
            availableBalance: 50,
          ),
        ],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );

      // Act
      final result = mapper.map(jsonResponse);

      // Assert
      expect(result, equals(expectedUserData));
    });

    test('should handle missing optional fields gracefully', () {
      // Arrange
      const jsonString =
          '{"balance": 1300, "numbers": [{"id": "1", "nickname": "nickname1", "phoneNumber": "+201013615170"}]}';
      final jsonResponse = jsonDecode(jsonString);

      const expectedUserData = UserData(
        balance: 1300,
        beneficiaries: [
          BeneficiaryModel(
            id: '1',
            nickname: 'nickname1',
            phoneNumber: '+201013615170',
            availableBalance: 0.0,
          ),
        ],
        availableBalance: 0.0, // Default value
        maxNumberOfBeneficiariesAllowed: 5,
      );

      // Act
      final result = mapper.map(jsonResponse);

      // Assert
      expect(result, equals(expectedUserData));
    });

    test('should handle missing "numbers" field', () {
      // Arrange
      const jsonString = '{"balance": 1300, "availableBalance": 800}';
      final jsonResponse = jsonDecode(jsonString);

      const expectedUserData = UserData(
        balance: 1300,
        beneficiaries: [],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );

      // Act
      final result = mapper.map(jsonResponse);

      // Assert
      expect(result, equals(expectedUserData));
    });

    test('should handle missing "balance" and "availableBalance"', () {
      // Arrange
      const jsonString =
          '{"numbers": [{"id": "1", "nickname": "nickname1", "phoneNumber": "+201013615170", "availableBalance": 1000}]}';
      final jsonResponse = jsonDecode(jsonString);

      const expectedUserData = UserData(
        balance: 0.0,
        beneficiaries: [
          BeneficiaryModel(
            id: '1',
            nickname: 'nickname1',
            phoneNumber: '+201013615170',
            availableBalance: 1000,
          ),
        ],
        availableBalance: 0.0,
        maxNumberOfBeneficiariesAllowed: 5,
      );

      // Act
      final result = mapper.map(jsonResponse);

      // Assert
      expect(result, equals(expectedUserData));
    });

    test('should handle invalid data types in "numbers" field', () {
      // Arrange
      const jsonString =
          '{"balance": 1300, "numbers": [{"id": "1", "nickname": "nickname1", "phoneNumber": "+201013615170", "availableBalance": "invalid"}], "availableBalance": 800}';
      final jsonResponse = jsonDecode(jsonString);

      const expectedUserData = UserData(
        balance: 1300,
        beneficiaries: [
          BeneficiaryModel(
            id: '1',
            nickname: 'nickname1',
            phoneNumber: '+201013615170',
            availableBalance: 0.0,
          ),
        ],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );

      // Act
      final result = mapper.map(jsonResponse);

      // Assert
      expect(result, equals(expectedUserData));
    });

    test('should handle empty beneficiaries list', () {
      // Arrange
      const jsonString =
          '{"balance": 1300, "numbers": [], "availableBalance": 800}';
      final jsonResponse = jsonDecode(jsonString);

      const expectedUserData = UserData(
        balance: 1300,
        beneficiaries: [],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );

      // Act
      final result = mapper.map(jsonResponse);

      // Assert
      expect(result, equals(expectedUserData));
    });
  });
}
