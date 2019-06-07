import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences{
  static const  URL = "url";

  static final MyPreferences instance = MyPreferences._internal();


  //Campos a manejar
  SharedPreferences _sharedPreferences;
  String url = "";

  MyPreferences._internal();

  factory MyPreferences()=>instance;

  Future<SharedPreferences> get preferences async{
    if(_sharedPreferences != null){
      return _sharedPreferences;
    }else{
      _sharedPreferences = await SharedPreferences.getInstance();
      url = _sharedPreferences.getString(URL) ?? "";
      return _sharedPreferences;

    }

  }
  Future<bool> commit() async {
    await _sharedPreferences.setString(URL, url);
  }

  Future<MyPreferences> init() async{
    _sharedPreferences = await preferences;
    return this;
  }


}