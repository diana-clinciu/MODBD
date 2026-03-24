sealed class DataState<T> {}

class Loading<T> extends DataState<T> {}

class Failure<T> extends DataState<T> {
  final Exception exception;
  Failure(this.exception);
}

class Ready<T> extends DataState<T> {
  final T data;
  Ready(this.data);
}
