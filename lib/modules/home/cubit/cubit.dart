import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/models/home_model.dart';
import 'package:smart_city/modules/home/cubit/states.dart';
import 'package:smart_city/shared/components/constants.dart';
import 'package:smart_city/shared/network/dio_helper.dart';
import 'package:smart_city/shared/style/end_point.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super((HomeInitialState()));


  static HomeCubit get(context) => BlocProvider.of(context);


  HomeModel homeModel;

    Future getHomeData() async{
    emit(ParkingLoadingHomeState());

   await DioHelper.getData(
      url: degrees,
      token: token,

    ).then((value){
      homeModel = HomeModel.fromJson(value.data);
     emit(ParkingSuccessHomeState(homeModel));
    }).catchError((error) {
      print(error.toString());
       emit(ParkingErrorHomeState(error.toString()));
    });
  }

}




