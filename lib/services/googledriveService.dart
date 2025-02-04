import 'dart:convert';
import 'dart:io';
import 'package:empoderaecommerce/controller/authController.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:get/get.dart';

class GoogleDriveService {
  static const String folderId = "11pm-nxE8SGd5zV-U_P95PGsK8QXG55AA"; 

  Future<drive.DriveApi> getDriveApi() async {
    try {
      final credentials = await rootBundle.loadString('assets/google/google-cloud.json');

      final serviceAccount = ServiceAccountCredentials.fromJson(json.decode(credentials));

      final authClient = await clientViaServiceAccount(
        serviceAccount,
        [drive.DriveApi.driveFileScope],
      );

      return drive.DriveApi(authClient);
    } catch (e) {
      print("❌ Erro ao autenticar com Google Drive: $e");
      rethrow;
    }
  }

  Future<String?> uploadImageToDrive(File imageFile) async {
    try {
      final driveApi = await getDriveApi();
      var fileMetadata = drive.File();
      fileMetadata.name = "perfil_${DateTime.now().millisecondsSinceEpoch}.jpg";
      fileMetadata.parents = [folderId];

      var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());
      var response = await driveApi.files.create(fileMetadata, uploadMedia: media);

      if (response.id == null) {
        throw Exception("❌ Erro: ID do arquivo retornado como null!");
      }

      print("✅ Imagem enviada para Google Drive! ID: ${response.id}");

      // 🔹 Tornar a imagem pública
      await driveApi.permissions.create(
        drive.Permission(type: 'anyone', role: 'reader'),
        response.id!,
      );

      // 🔹 Gerar URL pública da imagem
      String url = "https://drive.google.com/uc?export=view&id=${response.id}";
      print("🔗 URL da imagem: $url");

      // 🔹 Atualizar banco de dados do usuário
      AuthController authController = Get.find();
      authController.updateUserAvatarInDB(url);

      return url;
    } catch (e) {
      print("❌ Erro ao enviar imagem para o Google Drive: $e");
      return null;
    }
  }
}
