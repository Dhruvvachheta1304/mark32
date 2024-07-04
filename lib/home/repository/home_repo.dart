import 'package:hobbies/data/hobbies_data.dart';
import 'package:hobbies/home/model/list_model.dart';

abstract class IHobbiesRepo {
  Future<List<HobbiesModel>?> getHobbies();
}

class GetHobbies extends IHobbiesRepo {
  @override
  Future<List<HobbiesModel>?> getHobbies() async {
    try {
      return List<HobbiesModel>.from(HobbiesList.hobbies.map((e) => HobbiesModel.fromJson(e)));
    } catch (e) {
      throw Exception(e);
    }
  }
}
