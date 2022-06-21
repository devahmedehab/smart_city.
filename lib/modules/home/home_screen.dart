import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_city/models/home_model.dart';
import 'package:smart_city/modules/home/cubit/cubit.dart';
import 'package:smart_city/modules/home/cubit/states.dart';
import 'package:smart_city/shared/components/constants.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
/*
  StreamController<HomeModel>_streamControler= StreamController();


  @override
  void initState()
  {
    super.initState();

    Timer.periodic(
        Duration(seconds: 3),
            (timer) {
          getData();
        }
    );

  }

  Future <void> getData() async {
    var url =Uri.parse('https://smart-city-9.herokuapp.com/api/home/degrees');
    final response = await http.get(url);

    final dataBody = json.decode(response.body).first;

    HomeModel homeModel=new HomeModel.fromJson(dataBody);

    _streamControler.sink.add(homeModel);
  }*/

  @override
  Widget build(BuildContext context,) {
    RefreshController _refreshController = RefreshController();
    bool _hasInternet =false;
    ConnectivityResult result = ConnectivityResult.none;

    double temperature = 7;
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<HomeCubit, HomeStates>(
      listener:(context,state){
        if(state is ParkingSuccessHomeState){
          if(state.homeModel.status){
            var model = HomeCubit.get(context).homeModel;
            temp = model.data.degrees[0];
            gas  = model.data.degrees[1];
            hum  = model.data.degrees[2];
            rain = model.data.degrees[3];
          }

        }
      } ,
      builder: (context,state){
        return Scaffold(
          body: SmartRefresher(
            onRefresh:() async {
              await Future.delayed(Duration(microseconds: 500));
              _refreshController.refreshFailed();
              //Restart.restartApp();

              _hasInternet=await InternetConnectionChecker().hasConnection ;
              final color = _hasInternet ? Colors.green :Colors.red;

              result= await Connectivity().checkConnectivity();

              if(_hasInternet){
                HomeCubit.get(context).getHomeData();

              }
            },
            onLoading:() async {
              await Future.delayed(Duration(microseconds: 500));
              _refreshController.refreshFailed();
            },
            //  enablePullUp: true,
            controller: _refreshController,
            child: Column(children: [
              SizedBox(height: 20),
              Text(
                'Today',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Column(

                  children: [

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              customColors: CustomSliderColors(
                                trackColor: Colors.white,
                                dotColor: Colors.white,
                                progressBarColor: Colors.white,
                              ),
                              startAngle: 0,
                              angleRange: 360,
                              size: 250,


                              customWidths:
                              CustomSliderWidths(progressBarWidth: 0, handlerSize:0),
                            ),

                            initialValue: temperature,
                            onChangeEnd: (_value) => _value,
                            innerWidget: (percentage) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 7,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                        width: 1,
                                      ),
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Center(

                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                          ),
                                          Text(
                                            '${temp}° C',
                                            style: TextStyle(
                                              fontSize: 12 + (22 * 683 / size.height),
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            'Temperature',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),

                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              customColors: CustomSliderColors(
                                trackColor: Colors.white,
                                dotColor: Colors.white,
                                progressBarColor: Colors.white,
                              ),

                              startAngle: 0,
                              angleRange: 360,
                              size: 250,


                              customWidths:
                              CustomSliderWidths(progressBarWidth: 0, handlerSize:0),
                            ),

                            initialValue: temperature,
                            onChangeEnd: (_value) => _value,
                            innerWidget: (percentage) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 7,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                        width: 1,
                                      ),
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Center(

                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                          ),
                                          if(gas==1)
                                          Text(
                                            'Warning.!',
                                            style: TextStyle(
                                              fontSize: 12 + (22 * 683 / size.height),
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if(gas != 1)
                                            Text(
                                              'All is well',
                                              style: TextStyle(
                                                fontSize: 12 + (22 * 683 / size.height),
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          SizedBox(height: 10,),

                                          Text(
                                            'Gas',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),

                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),

                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              customColors: CustomSliderColors(
                                trackColor: Colors.white,
                                dotColor: Colors.white,
                                progressBarColor: Colors.white,
                              ),

                              startAngle: 0,
                              angleRange: 360,
                              size: 250,


                              customWidths:
                              CustomSliderWidths(progressBarWidth: 0, handlerSize: 0),
                            ),
                            min: 0,
                            max: 30,
                            initialValue: temperature,
                            onChangeEnd: (_value) => _value,
                            innerWidget: (percentage) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 7,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                        width: 1,
                                      ),
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Center(

                                      child:
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 75,
                                          ),
                                          Text(
                                            '${hum} %',
                                            style: TextStyle(
                                              fontSize: 12 + (22 * 683 / size.height),
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            'Humidity',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),

                          SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              customColors: CustomSliderColors(
                                trackColor: Colors.white,
                                dotColor: Colors.white,
                                progressBarColor: Colors.white,
                              ),
                              startAngle: 0,
                              angleRange: 360.0,
                              size: 250,


                              customWidths:
                              CustomSliderWidths(progressBarWidth: 0, handlerSize: 0),
                            ),
                            min: 0,
                            max: 30,
                            initialValue: temperature,
                            onChangeEnd: (_value) => _value,
                            innerWidget: (percentage) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(


                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 7,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                        width: 1,
                                      ),
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Center(

                                      child:
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 75,
                                          ),
                                          if(rain == 1)
                                            Text(
                                              'Rainy',
                                              style: TextStyle(
                                                fontSize: 12 + (22 * 683 / size.height),
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                        if(rain!=1)
                                          Text(
                                            'Clear sky',
                                            style: TextStyle(
                                              fontSize: 12 + (22 * 683 / size.height),
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            'Rain',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100,),

                  ],
                ),


              ),
            ]),
          ),
        );
      },
    );

  }
}
