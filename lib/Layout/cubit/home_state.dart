part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class loadAddPopUpLoading extends HomeState {}
final class loadAddPopUpSucces extends HomeState {}
final class loadAddPopUpError extends HomeState {}

final class loadPostLoading extends HomeState {}
final class loadPostSucces extends HomeState {}
final class loadPostError extends HomeState {}
final class loadPDFLoading extends HomeState {}
final class loadPDFSucces extends HomeState {}
final class loadPDFError extends HomeState {}
final class deletePostLoading extends HomeState {}
final class deletePostSucces extends HomeState {}
final class deletePostError extends HomeState {}
final class deletePDFLoading extends HomeState {}
final class deletePDFSucces extends HomeState {}
final class deletePDFError extends HomeState {}
final class deleteAdPopUpLoading extends HomeState {}
final class deleteAdPopUpSucces extends HomeState {}
final class deleteAdPopUpError extends HomeState {
  final String error;
  deleteAdPopUpError(this.error);
}
final class uploadAdPopUpLoading extends HomeState {}
final class uploadAdPopUpSucces extends HomeState {}
final class uploadAdPopUpError extends HomeState {
  final String error;
  uploadAdPopUpError(this.error);
}
final class updateAdPopUpLoading extends HomeState {}
final class updateAdPopUpSucces extends HomeState {}
final class updateAdPopUpError extends HomeState {
  final String error;
  updateAdPopUpError(this.error);
}
class uploadPDFLoading extends HomeState {}

class uploadPDFSuccess extends HomeState {}

class uploadPDFError extends HomeState {}

class uploadPDFCancelled extends HomeState {}
class UploadImageLoading extends HomeState {}

class UploadImageSuccess extends HomeState {
  final String imageUrl;
  UploadImageSuccess(this.imageUrl);
}

class UploadImageFailure extends HomeState {
  final String error;
  UploadImageFailure(this.error);
}
class SelectImageLoading extends HomeState {}

class SelectImageSuccess extends HomeState {
  final String imagePath;
  SelectImageSuccess(this.imagePath);
}

class SelectImageFailure extends HomeState {
  final String error;
  SelectImageFailure(this.error);
}