import 'package:endred/feature/beneficiary_home/data/data_sources/local_data_source/beneficiary_local_data_source.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/remote_data_source/beneficiary_remote_data_source.dart';
import 'package:endred/feature/beneficiary_home/data/repository/beneficiary_repository.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockBeneficiaryLocalDataSource extends Mock
    implements BeneficiaryLocalDataSource {}

class MockBeneficiaryRemoteDataSource extends Mock
    implements BeneficiaryRemoteDataSource {}

void main() {
  late BeneficiaryRepositoryImpl repository;
  late MockBeneficiaryLocalDataSource mockLocalDataSource;
  late MockBeneficiaryRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockBeneficiaryLocalDataSource();
    mockRemoteDataSource = MockBeneficiaryRemoteDataSource();
    repository = BeneficiaryRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
    registerFallbackValue(
      const BeneficiaryModel(
        id: '1',
        nickname: 'nickname1',
        phoneNumber: '+201013615170',
        availableBalance: 1000,
      ),
    );
  });

  group('BeneficiaryRepositoryImpl', () {
    const beneficiary = BeneficiaryModel(
      id: '1',
      nickname: 'nickname1',
      phoneNumber: '+201013615170',
      availableBalance: 1000,
    );

    test(
        'should call remote data source and save to local data source on topUpBeneficiary',
        () async {
      // Arrange
      const userData = UserData(
        balance: 1300,
        beneficiaries: [beneficiary],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );
      when(() => mockRemoteDataSource.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).thenAnswer((_) async => userData);
      when(() => mockLocalDataSource.saveBeneficiaries(response: userData))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.topUpBeneficiary(
        beneficiary: beneficiary,
        amount: 500,
      );

      // Assert
      expect(result, equals(userData));
      verify(() => mockRemoteDataSource.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).called(1);
      verify(() => mockLocalDataSource.saveBeneficiaries(response: userData))
          .called(1);
    });

    test(
        'should call local data source first and remote data source if local is null on getBeneficiaries',
        () async {
      // Arrange
      const userData = UserData(
        balance: 1300,
        beneficiaries: [beneficiary],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );
      when(() => mockLocalDataSource.getBeneficiaries())
          .thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.getBeneficiaries())
          .thenAnswer((_) async => userData);
      when(() => mockLocalDataSource.saveBeneficiaries(response: userData))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getBeneficiaries();

      // Assert
      expect(result, equals(userData));
      verify(() => mockLocalDataSource.getBeneficiaries()).called(1);
      verify(() => mockRemoteDataSource.getBeneficiaries()).called(1);
      verify(() => mockLocalDataSource.saveBeneficiaries(response: userData))
          .called(1);
    });

    test(
        'should call remote data source and local data source on addNewBeneficiary',
        () async {
      // Arrange
      const userData = UserData(
        balance: 1300,
        beneficiaries: [beneficiary],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );
      when(() => mockRemoteDataSource.addNewBeneficiary(
            beneficiaryName: 'nickname1',
            phoneNumber: '+201013615170',
          )).thenAnswer((_) async => userData);
      when(() => mockLocalDataSource.addNewBeneficiary(
            beneficiaryName: 'nickname1',
            phoneNumber: '+201013615170',
          )).thenAnswer((_) async => userData);

      // Act
      final result = await repository.addNewBeneficiary(
        beneficiaryName: 'nickname1',
        phoneNumber: '+201013615170',
      );

      // Assert
      expect(result, equals(userData));
      verify(() => mockRemoteDataSource.addNewBeneficiary(
            beneficiaryName: 'nickname1',
            phoneNumber: '+201013615170',
          )).called(1);
      verify(() => mockLocalDataSource.addNewBeneficiary(
            beneficiaryName: 'nickname1',
            phoneNumber: '+201013615170',
          )).called(1);
    });

    test(
        'should handle null response from remote data source gracefully in topUpBeneficiary',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).thenAnswer((_) async => null);

      // Act
      final result = await repository.topUpBeneficiary(
        beneficiary: beneficiary,
        amount: 500,
      );

      // Assert
      expect(result, isNull);
      verify(() => mockRemoteDataSource.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).called(1);
    });

    test(
        'should handle null response from remote data source gracefully in addNewBeneficiary',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.addNewBeneficiary(
            beneficiaryName: 'nickname1',
            phoneNumber: '+201013615170',
          )).thenAnswer((_) async => null);

      // Act
      final result = await repository.addNewBeneficiary(
        beneficiaryName: 'nickname1',
        phoneNumber: '+201013615170',
      );

      // Assert
      expect(result, isNull);
      verify(() => mockRemoteDataSource.addNewBeneficiary(
            beneficiaryName: 'nickname1',
            phoneNumber: '+201013615170',
          )).called(1);
      verifyNever(() => mockLocalDataSource.addNewBeneficiary(
            beneficiaryName: 'nickname1',
            phoneNumber: '+201013615170',
          ));
    });

    test(
        'should handle null response from local data source in getBeneficiaries',
        () async {
      // Arrange
      const userData = UserData(
        balance: 1300,
        beneficiaries: [beneficiary],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );
      when(() => mockLocalDataSource.getBeneficiaries())
          .thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.getBeneficiaries())
          .thenAnswer((_) async => userData);
      when(() => mockLocalDataSource.saveBeneficiaries(response: userData))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getBeneficiaries();

      // Assert
      expect(result, equals(userData));
      verify(() => mockLocalDataSource.getBeneficiaries()).called(1);
      verify(() => mockRemoteDataSource.getBeneficiaries()).called(1);
      verify(() => mockLocalDataSource.saveBeneficiaries(response: userData))
          .called(1);
    });
  });
}
