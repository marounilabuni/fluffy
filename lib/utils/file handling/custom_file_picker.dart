import 'package:file_picker/file_picker.dart';

abstract class CustomFilePicker {
  static Future<List<PlatformFile>> pick({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
    bool allowMultiple = false,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: type,
      allowedExtensions: allowedExtensions,
      withData: true,
    );
    //
    List<PlatformFile> files = result == null ? [] : result.files;

    return files;
  }

  ////

  static Future<List<PlatformFile>> pickImages({
    bool allowMultiple = false,
  }) async {
    return await pick(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
  }
}
