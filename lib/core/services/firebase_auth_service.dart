import 'package:sham/core/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreService _fireStoreService = FirestoreService();

  /// Get the current user
  User? get currentUser => _auth.currentUser;

  /// Sign up with email and password
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Returns the created user
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error (signUpWithEmail): ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error (signUpWithEmail): $e");
      return null;
    }
  }

  /// Sign in with email and password
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Returns the signed-in user
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error (signInWithEmail): ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error (signInWithEmail): $e");
      return null;
    }
  }

  /// Sign out the current user
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print("Error (signOut): $e");
      return false;
    }
  }

  /// Send email verification to the current user
  Future<bool> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return true;
      } else {
        print("User is either null or already verified.");
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error (sendEmailVerification): ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error (sendEmailVerification): $e");
      return false;
    }
  }

  /// Reset password using email
  Future<String> sendPasswordResetEmail({required String email}) async {
    try {
      // Check if the email is associated with an account
      bool ifUserExist = await _fireStoreService.checkUserExists(email: email);

      if (ifUserExist == false) {
        print("No user found with this email: $email");
        return 'No user found with this email $email'; // User does not exist
      }

      // If the user exists, send the reset password email
      await _auth.sendPasswordResetEmail(email: email);
      return 'Success'; // Email sent successfully
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error (sendPasswordResetEmail): ${e.message}");
      return e.message ?? 'An error occurred'; // Return the error message
    } catch (e) {
      print("Unexpected Error (sendPasswordResetEmail): $e");
      return 'An error occurred'; // Return a generic error message
    }
  }

  /// Delete the current user
  Future<bool> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        return true;
      } else {
        print("No user is currently signed in.");
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error (deleteUser): ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error (deleteUser): $e");
      return false;
    }
  }

  /// Check if the current user is email-verified
  bool isEmailVerified() {
    User? user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  /// Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error (signInAnonymously): ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error (signInAnonymously): $e");
      return null;
    }
  }

  /// Update email for the current user
  Future<bool> updateEmail({required String newEmail}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
        return true;
      } else {
        print("No user is currently signed in.");
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error (updateEmail): ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error (updateEmail): $e");
      return false;
    }
  }

  /// Update password for the current user
  Future<bool> updatePassword({required String newPassword}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        return true;
      } else {
        print("No user is currently signed in.");
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error (updatePassword): ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error (updatePassword): $e");
      return false;
    }
  }
}