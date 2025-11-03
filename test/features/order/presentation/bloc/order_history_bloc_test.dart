import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/order/domain/entities/order.dart';
import 'package:flutter_enterprise_app/features/order/domain/usecases/get_orders.dart';
import 'package:flutter_enterprise_app/features/order/presentation/bloc/order_history_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'order_history_bloc_test.mocks.dart';

// Generate mocks for GetOrders use case
@GenerateMocks([GetOrders])
void main() {
  late MockGetOrders mockGetOrders;
  late OrderHistoryBloc bloc;

  setUp(() {
    mockGetOrders = MockGetOrders();
    bloc = OrderHistoryBloc(getOrders: mockGetOrders);
  });

  tearDown(() {
    bloc.close();
  });

  group('OrderHistoryBloc', () {
    final tOrder = Order(
      items: [],
      totalPrice: 99.99,
      orderDate: DateTime.now(),
    );
    final tOrders = [tOrder];

    test('initial state should be OrderHistoryInitial', () {
      expect(bloc.state, equals(OrderHistoryInitial()));
    });

    blocTest<OrderHistoryBloc, OrderHistoryState>(
      'emits [OrderHistoryLoading, OrderHistoryLoaded] when orders are fetched successfully',
      build: () {
        when(mockGetOrders.call(any)).thenAnswer((_) async => Right(tOrders));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadOrderHistory()),
      expect: () => [
        OrderHistoryLoading(),
        OrderHistoryLoaded(tOrders),
      ],
      verify: (_) {
        verify(mockGetOrders.call(any));
        verifyNoMoreInteractions(mockGetOrders);
      },
    );

    blocTest<OrderHistoryBloc, OrderHistoryState>(
      'emits [OrderHistoryLoading, OrderHistoryError] when fetching orders fails',
      build: () {
        when(mockGetOrders.call(any))
            .thenAnswer((_) async => Left(CacheFailure(message: 'Test Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadOrderHistory()),
      expect: () => [
        OrderHistoryLoading(),
        const OrderHistoryError('CacheFailure(Test Failure)'),
      ],
      verify: (_) {
        verify(mockGetOrders.call(any));
        verifyNoMoreInteractions(mockGetOrders);
      },
    );
  });
}
