import 'package:hacknight_project/repository/image_repo.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerRepositoryImpl extends ImagePickerRepository {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<String?> pickImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }
}
