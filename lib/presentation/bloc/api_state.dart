
abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiLoadingDelete extends ApiState{}

class ApiSuccessDelete<T> extends ApiState {
  final T data;
  ApiSuccessDelete(this.data);
}

class ApiFailureDelete extends ApiState {
  final String message;
  ApiFailureDelete(this.message);
}

class ApiSuccess<T> extends ApiState {
  final T data;
  ApiSuccess(this.data);
}

class ApiFailure extends ApiState {
  final String message;
  ApiFailure(this.message);
}

