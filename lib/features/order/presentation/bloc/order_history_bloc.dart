import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/order/domain/entities/order.dart';
import 'package:flutter_enterprise_app/features/order/domain/usecases/get_orders.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final GetOrders getOrders;

  OrderHistoryBloc({required this.getOrders}) : super(OrderHistoryInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
  }

  Future<void> _onLoadOrderHistory(
    LoadOrderHistory event,
    Emitter<OrderHistoryState> emit,
  ) async {
    emit(OrderHistoryLoading());
    final failureOrOrders = await getOrders(NoParams());
    failureOrOrders.fold(
      (failure) => emit(OrderHistoryError(failure.toString())),
      (orders) => emit(OrderHistoryLoaded(orders)),
    );
  }
}
