import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_delivery/models/new_message_system.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/services/chat_service.dart';

class ConversationViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ChatService chatService = ChatService();
  bool uploadingImage = false;
  final picker = ImagePicker();
 late File? image;

  sendMessage(String? chatId, Message message) {
    chatService.sendMessage(
      message,
      chatId,
    );
  }

  Future<String?> sendFirstMessage(
      String? recipient, Message message, Orders? orders) async {
    String? newChatId =
        await chatService.sendFirstMessage(message, recipient, orders);

    return newChatId;
  }

  setReadCount(String? chatId, var user, int count) {
    chatService.setUserRead(chatId, user, count);
  }

  setUserTyping(String? chatId, var user, bool typing) {
    chatService.setUserTyping(chatId, user, typing);
  }

  pickImage(int source, BuildContext context, String? chatId) async {
    File image = source == 0
        ? await ImagePicker.pickImage(
            source: ImageSource.camera,
          )
        : await ImagePicker.pickImage(
            source: ImageSource.gallery,
          );

    if (image != null) {
      File? croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Theme.of(context).appBarTheme.color,
          toolbarWidgetColor: Theme.of(context).iconTheme.color,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      Navigator.of(context).pop();

      if (croppedFile != null) {
        uploadingImage = true;
        image = croppedFile;
        notifyListeners();
        showInSnackBar("Uploading image...",context);
        String? imageUrl = await chatService.uploadImage(croppedFile, chatId);
        return imageUrl;
      }
    }
  }

  void showInSnackBar(String? value,BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value??"")));
  }
}
