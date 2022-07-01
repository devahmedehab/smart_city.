import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_city/modules/home/cubit/cubit.dart';
import 'package:smart_city/modules/home/cubit/states.dart';
import 'package:smart_city/shared/components/constants.dart';
import 'package:smart_city/shared/style/icon_broken.dart';

class LivingRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double temperature = 7;
    Size size = MediaQuery.of(context).size;
    RefreshController _refreshController = RefreshController();
    bool _hasInternet = false;
    ConnectivityResult result = ConnectivityResult.none;
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Living Room'),
          ),
          body:  SmartRefresher(
          onRefresh: () async {
          await Future.delayed(Duration(microseconds: 500));
          _refreshController.refreshFailed();
          _hasInternet = await InternetConnectionChecker().hasConnection;
          final color = _hasInternet ? Colors.green : Colors.red;

          result = await Connectivity().checkConnectivity();

          if (_hasInternet) {
          HomeCubit.get(context).getHomeData();
          }
          },
          onLoading: () async {
          await Future.delayed(Duration(microseconds: 500));
          _refreshController.refreshFailed();
          },
          //  enablePullUp: true,
          controller: _refreshController,
          child:
          SingleChildScrollView(
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
                height: 50,
              ),
              Center(
                child: Column(
                  children: [
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
                        customWidths: CustomSliderWidths(
                            progressBarWidth: 0, handlerSize: 0),
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
                                      height: 40,
                                    ),
                                    Text(
                                      '$temp °C',
                                      style: TextStyle(
                                        fontSize: 12 + (22 * 683 / size.height),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    if (temp >= 25&&rain ==0)
                                      CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              'assets/images/weather.jpg')),
                                    if (temp < 25&&rain==0)
                                      CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              'assets/images/weather1.png')),
                                    if (rain == 1)
                                      CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              'assets/images/weather2.png'))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
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
                        customWidths: CustomSliderWidths(
                            progressBarWidth: 0, handlerSize: 0),
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
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 75,
                                    ),
                                    Text(
                                      '$hum %',
                                      style: TextStyle(
                                        fontSize: 12 + (22 * 683 / size.height),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
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
                    SizedBox(
                      height: 10,
                    ),

                  ],
                ),

            ),
        ]),
          )
        ));
      },
    );
  }
}