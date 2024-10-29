import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";


final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async{
  try{
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    sl.registerSingleton<SharedPreferences>(preferences);
  }
 catch(e){
    print("error $e");
 }

}