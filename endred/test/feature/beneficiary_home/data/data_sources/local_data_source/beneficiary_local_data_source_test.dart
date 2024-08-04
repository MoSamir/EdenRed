import 'dart:convert';

import 'package:endred/feature/beneficiary_home/data/data_sources/local_data_source/beneficiary_local_data_source.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/mapper/beneficiary_response_mapper.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockBeneficiaryResponseMapper extends Mock
    implements BeneficiaryResponseMapper {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late MockBeneficiaryResponseMapper mockBeneficiaryResponseMapper;
  late BeneficiaryLocalDataSource dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockBeneficiaryResponseMapper = MockBeneficiaryResponseMapper();
    dataSource = BeneficiaryLocalDataSource(
      sharedPreferences: Future.value(mockSharedPreferences),
      beneficiaryResponseMapper: mockBeneficiaryResponseMapper,
    );
  });

  group('saveBeneficiaries', () {
    final tUserData = UserData(
      balance: 1000,
      beneficiaries: [
        const BeneficiaryModel(
          id: '1',
          nickname: 'John Doe',
          phoneNumber: '123456789',
          availableBalance: 200,
        ),
      ],
      availableBalance: 800,
    );

    test('should call SharedPreferences to cache the data', () async {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      await dataSource.saveBeneficiaries(response: tUserData);

      final expectedJsonString = json.encode(tUserData.toJson());
      verify(() => mockSharedPreferences.setString(
            BeneficiaryLocalDataSource.CACHED_BENEFICIARY,
            expectedJsonString,
          ));
    });
  });

  group('getBeneficiaries', () {
    final tUserData = UserData(
      balance: 1000,
      beneficiaries: [
        const BeneficiaryModel(
          id: '1',
          nickname: 'John Doe',
          phoneNumber: '123456789',
          availableBalance: 200,
        ),
      ],
      availableBalance: 800,
    );

    setUp(() {
      // Mock the reload method
      when(() => mockSharedPreferences.reload()).thenAnswer((_) async => {});
    });

    test(
        'should return UserData from SharedPreferences when there is one in cache',
        () async {
      final jsonString = json.encode(tUserData.toJson());
      when(() => mockSharedPreferences.getString(any())).thenReturn(jsonString);
      when(() => mockBeneficiaryResponseMapper.map(any()))
          .thenReturn(tUserData);

      final result = await dataSource.getBeneficiaries();

      verify(() => mockSharedPreferences.reload());
      verify(() => mockSharedPreferences
          .getString(BeneficiaryLocalDataSource.CACHED_BENEFICIARY));
      expect(result, equals(tUserData));
    });

    test('should return null when there is not a cached value', () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final result = await dataSource.getBeneficiaries();

      verify(() => mockSharedPreferences.reload());
      verify(() => mockSharedPreferences
          .getString(BeneficiaryLocalDataSource.CACHED_BENEFICIARY));
      expect(result, equals(null));
    });
  });

  group('addNewBeneficiary', () {
    final tUserData = UserData(
      balance: 1000,
      beneficiaries: [
        const BeneficiaryModel(
          id: '2',
          nickname: 'John Doe',
          phoneNumber: '123456789',
          availableBalance: 200,
        ),
      ],
      availableBalance: 800,
    );

    setUp(() {
      // Mock the reload method
      when(() => mockSharedPreferences.reload()).thenAnswer((_) async => {});
    });

    test('should add new beneficiary and update cache', () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(json.encode(tUserData.toJson()));
      when(() => mockBeneficiaryResponseMapper.map(any()))
          .thenReturn(tUserData);
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      final result = await dataSource.addNewBeneficiary(
        beneficiaryName: 'Jane Doe',
        phoneNumber: '987654321',
      );

      final expectedUserData = UserData(
        balance: 1000,
        beneficiaries: [
          const BeneficiaryModel(
            id: '2',
            nickname: 'John Doe',
            phoneNumber: '123456789',
            availableBalance: 200,
          ),
          const BeneficiaryModel(
            id: '1',
            nickname: 'Jane Doe',
            phoneNumber: '987654321',
            availableBalance: 200,
          ),
        ],
        availableBalance: 800,
      );

      verify(() => mockSharedPreferences
          .getString(BeneficiaryLocalDataSource.CACHED_BENEFICIARY));
      verify(() => mockBeneficiaryResponseMapper.map(any()));
      verify(() => mockSharedPreferences.setString(
            BeneficiaryLocalDataSource.CACHED_BENEFICIARY,
            json.encode(expectedUserData.toJson()),
          ));

      expect(result!.beneficiaries, expectedUserData.beneficiaries);
      expect(result.availableBalance, expectedUserData.availableBalance);
      expect(result.balance, expectedUserData.balance);
    });
  });
}
