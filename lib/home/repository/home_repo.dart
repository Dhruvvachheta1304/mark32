import 'package:mark2/data/hobbies_data.dart';
import 'package:mark2/home/model/list_model.dart';

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
