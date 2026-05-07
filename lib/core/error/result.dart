import 'failures.dart';

export 'failures.dart';

sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  final T data;
  const Ok(this.data);
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}

extension ResultExtension<T> on Result<T> {
  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T? get dataOrNull => switch (this) {
        Ok(:final data) => data,
        Err() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Ok() => null,
        Err(:final failure) => failure,
      };

  /// Transforms both branches. Use for synchronous folding.
  R fold<R>(R Function(Failure) onErr, R Function(T) onOk) => switch (this) {
        Ok(:final data) => onOk(data),
        Err(:final failure) => onErr(failure),
      };
}
