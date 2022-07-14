import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/models/home_model.dart';
import 'package:smart_city/models/light_model.dart';
import 'package:smart_city/modules/home/cubit/states.dart';
import 'package:smart_city/shared/components/constants.dart';
import 'package:smart_city/shared/network/cache_helper.dart';
import 'package:smart_city/shared/network/dio_helper.dart';
import 'package:smart_city/shared/style/end_point.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super((HomeInitialState()));


  static HomeCubit get(context) => BlocProvider.of(context);


  bool isDark =false;

  void changeAppMode({bool fromShared})
  {
    if(fromShared !=null){

      isDark=fromShared;
      emit(AppChangeModeState());
    } else
    {
      isDark =!isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
      {
        emit(AppChangeModeState());
      } );

    }



  }
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
    LightModel lightsModel;

  Future getLightsData() async{
    emit(HomeGetLoadingLightsState());

    await DioHelper.getData(
      url: lights,
      token: token,


    ).then((value){




      lightsModel = LightModel.fromJson(value.data);

      emit(HomeGetSuccessLightsState(lightsModel));
      print(LightModel.fromJson(value.data));
      print(lightsModel.message);

      print(lightsModel.data.led2);


    }).catchError((error) {
      print(error.toString());
      emit(HomeGetErrorLightsState(error.toString()));
    });
  }
  Future postLightData ({
     int led1 ,
     int led2 ,
     int led3 ,
     int led4 ,
     int led5 ,
     int led6 ,


  })async

  {
    emit(HomePostLoadingLightsState());

   // getLightsData();
    await DioHelper.postData(
      url: lights,
      token: token,
      data:{
        'led1':led1,
        'led2':led2,
        'led3':led3,
        'led4':led4,
        'led5':led5,
        'led6':led6,
      },
    ).then((value) {
      lightsModel= LightModel.fromJson(value.data);






      emit(HomePostSuccessLightsState(lightsModel));
    }).catchError((error){
      print(error.toString());
      emit(HomePostErrorLightsState(error.toString()));
    });


  }

bool  isLighted=false;
Icon icon = Icon(Icons.flashlight_off_outlined,size: 60,);

  void lightSwitch(){

    if (isLighted) {
        icon = Icon(
        Icons.flashlight_off_outlined,
        size: 60,
      );
        isLighted =!isLighted;

    }
    else{
      icon = Icon(
        Icons.flashlight_on_outlined,
        size: 60,
      );
      isLighted =!isLighted;

    }

    print(isLighted);

      emit(AppChangeLightState());
  }






}




