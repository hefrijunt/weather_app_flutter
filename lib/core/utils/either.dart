abstract class Either<L, R> {
  T fold<T>(T Function(L l) left, T Function(R r) right);
}

class Left<L, R> extends Either<L, R> {
  final L value;

  Left(this.value);

  @override
  T fold<T>(T Function(L l) left, T Function(R r) right) {
    return left(value);
  }
}

class Right<L, R> extends Either<L, R> {
  final R value;

  Right(this.value);

  @override
  T fold<T>(T Function(L l) rightFn, T Function(R r) right) {
    return right(value);
  }
}
