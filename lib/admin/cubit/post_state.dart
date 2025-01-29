abstract class PostState {}

class PostInitial extends PostState {}

class CreatePostLoading extends PostState {}

class CreatePostSuccess extends PostState {}

class CreatePostFailure extends PostState {
  final String error;
  CreatePostFailure(this.error);
}

class UploadImageLoading extends PostState {}

class UploadImageSuccess extends PostState {
  final String imageUrl;
  UploadImageSuccess(this.imageUrl);
}

class UploadImageFailure extends PostState {
  final String error;
  UploadImageFailure(this.error);
}
class SelectImageLoading extends PostState {}

class SelectImageSuccess extends PostState {
  final String imagePath;
  SelectImageSuccess(this.imagePath);
}

class SelectImageFailure extends PostState {
  final String error;
  SelectImageFailure(this.error);
}
class UpdatePostLoading extends PostState {}

class UpdatePostSuccess extends PostState {}

class UpdatePostFailure extends PostState {
  final String error;

  UpdatePostFailure(this.error);
}
class UpdateSliderLoading extends PostState {}

class UpdateSliderSuccess extends PostState {}

class UpdateSliderFailure extends PostState {
  final String error;

  UpdateSliderFailure(this.error);
}
class UploadSliderLoading extends PostState {}

class UploadSliderSuccess extends PostState {}

class UploadSliderFailure extends PostState {
  final String error;

  UploadSliderFailure(this.error);
}
class DeleteSliderLoading extends PostState {}

class DeleteSliderSuccess extends PostState {}

class DeleteSliderFailure extends PostState {
  final String error;

  DeleteSliderFailure(this.error);
}
class GetSliderLoading extends PostState {}

class GetSliderSuccess extends PostState {}

class GetSliderFailure extends PostState {
  final String error;

  GetSliderFailure(this.error);
}