import 'package:endred/feature/beneficiary_home/data/repository/beneficiary_repository.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/get_beneficiaries_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock
class MockBeneficiaryRepository extends Mock implements BeneficiaryRepository {}

void main() {
  late GetBeneficiariesUseCaseImpl useCase;
  late MockBeneficiaryRepository mockRepository;

  setUp(() {
    mockRepository = MockBeneficiaryRepository();
    useCase = GetBeneficiariesUseCaseImpl(
      beneficiaryRepository: mockRepository,
    );
  });

  const userData = UserData(
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
  );

  group('GetBeneficiariesUseCaseImpl', () {
    test('should return data from repository', () async {
      // Arrange
      when(() => mockRepository.getBeneficiaries())
          .thenAnswer((_) async => userData);

      // Act
      final result = await useCase.getBeneficiaries();

      // Assert
      expect(result, equals(userData));
      verify(() => mockRepository.getBeneficiaries()).called(1);
    });

    test('should handle null response from repository', () async {
      // Arrange
      when(() => mockRepository.getBeneficiaries())
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase.getBeneficiaries();

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getBeneficiaries()).called(1);
    });

    test('should handle exception thrown by repository', () async {
      // Arrange
      when(() => mockRepository.getBeneficiaries())
          .thenThrow(Exception('Failed to load beneficiaries'));

      // Act & Assert
      expect(() async => await useCase.getBeneficiaries(),
          throwsA(isA<Exception>()));
      verify(() => mockRepository.getBeneficiaries()).called(1);
    });
  });
}
