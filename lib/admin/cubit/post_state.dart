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