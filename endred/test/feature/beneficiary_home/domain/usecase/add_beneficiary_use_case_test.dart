import 'package:endred/feature/beneficiary_home/data/repository/beneficiary_repository.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/add_beneficiary_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock
class MockBeneficiaryRepository extends Mock implements BeneficiaryRepository {}

void main() {
  late AddNewBeneficiaryUseCaseImpl useCase;
  late MockBeneficiaryRepository mockRepository;

  setUp(() {
    mockRepository = MockBeneficiaryRepository();
    useCase = AddNewBeneficiaryUseCaseImpl(
      beneficiaryRepository: mockRepository,
    );
  });

  const beneficiary = BeneficiaryModel(
    id: '1',
    nickname: 'nickname1',
    phoneNumber: '+201013615170',
    availableBalance: 1000,
  );

  group('AddNewBeneficiaryUseCaseImpl', () {
    test('should call repository with correct parameters and return data',
        () async {
      // Arrange
      const userData = UserData(
        balance: 1300,
        beneficiaries: [beneficiary],
        availableBalance: 800,
        maxNumberOfBeneficiariesAllowed: 5,
      );
      when(() => mockRepository.addNewBeneficiary(
            beneficiaryName: beneficiary.nickname,
            phoneNumber: beneficiary.phoneNumber,
          )).thenAnswer((_) async => userData);

      // Act
      final result = await useCase.addBeneficiary(
        name: beneficiary.nickname,
        phoneNumber: beneficiary.phoneNumber,
      );

      // Assert
      expect(result, equals(userData));
      verify(() => mockRepository.addNewBeneficiary(
            beneficiaryName: beneficiary.nickname,
            phoneNumber: beneficiary.phoneNumber,
          )).called(1);
    });

    test('should handle null response from repository', () async {
      // Arrange
      when(() => mockRepository.addNewBeneficiary(
            beneficiaryName: beneficiary.nickname,
            phoneNumber: beneficiary.phoneNumber,
          )).thenAnswer((_) async => null);

      // Act
      final result = await useCase.addBeneficiary(
        name: beneficiary.nickname,
        phoneNumber: beneficiary.phoneNumber,
      );

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.addNewBeneficiary(
            beneficiaryName: beneficiary.nickname,
            phoneNumber: beneficiary.phoneNumber,
          )).called(1);
    });
  });
}
