import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDatSource extends Mock implements NumberTriviaRemoteDataSource {
}

class MockLocalDatSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDatSource mockRemoteDatSource;
  MockLocalDatSource mockLocalDatSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatSource = MockRemoteDatSource();
    mockLocalDatSource = MockLocalDatSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDatSource,
      localDataSource: mockLocalDatSource,
      networkInfo: mockNetworkInfo,
    );
  });
}
