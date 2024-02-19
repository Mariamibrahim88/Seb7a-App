import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:seb7a_app/widgets/custom_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ResetToZero({bool resetGoal = false}) {
    setCount(_counter = 0);
    resetGoal == true ? setGoal(_goal = 0) : null;
    setRepeat(_repeat = 0);
  }

  setCount(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', value);
    getCount();
  }

  setGoal(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('goal', value);
    getCount();
  }

  setRepeat(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('_repeat', value);
    getCount();
  }

  setColor(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('color', value);
    getCount();
  }

  getCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
      _goal = prefs.getInt('goal') ?? 0;
      _repeat = prefs.getInt('_repeat') ?? 0;
      selectedColor = prefs.getInt('color') ?? kred;
    });
  }

  void setGoalFromCustomCard(int goal) {
    setState(() {
      _goal = goal;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getCount();
    super.initState();
  }

  int _goal = 0;
  int _counter = 0;
  int _repeat = 0;
  int selectedColor = kred;
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    Color mainColor = Color(selectedColor);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {
            ResetToZero(resetGoal: true);
          },
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mainColor,
          actions: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    isActive = !isActive;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                      isActive ? Icons.color_lens_outlined : Icons.color_lens),
                )),
          ],
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 170,
              color: mainColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'الهدف',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 28,
                          color: Colors.white,
                          onPressed: () {
                            ResetToZero();
                            setGoal(_goal + 1);
                          },
                          icon: Icon(Icons.add_circle),
                        ),
                        Text(
                          '$_goal',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          iconSize: 28,
                          color: Colors.white,
                          onPressed: () {
                            ResetToZero();
                            if (_goal > 0) {
                              setGoal(_goal - 1);
                            }
                          },
                          icon: Icon(Icons.remove_circle),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomCard(
                          text: '0',
                          onCardTap: () {
                            setGoalFromCustomCard(0);
                          },
                        ),
                        CustomCard(
                          text: '33',
                          onCardTap: () {
                            setGoalFromCustomCard(33);
                          },
                        ),
                        CustomCard(
                          onCardTap: () {
                            setGoalFromCustomCard(100);
                          },
                          text: '100',
                        ),
                        CustomCard(
                          onCardTap: () {
                            setGoalFromCustomCard(_goal + 100);
                          },
                          text: '+100',
                        ),
                        CustomCard(
                            onCardTap: () {
                              setGoalFromCustomCard(_goal + 1000);
                            },
                            text: '+1000'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 20),
                Text(
                  'الاستغفار',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                SizedBox(height: 5),
                Text(
                  '$_counter',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                SizedBox(height: 10),
                CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 5.0,
                  percent: _goal != 0 ? _counter / _goal : 0,
                  center: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_counter >= _goal) {
                          setRepeat(_repeat + 1);
                          setCount(_counter = 1);
                        } else {
                          setCount(_counter + 1);
                        }
                      });
                    },
                    child: Icon(
                      Icons.touch_app,
                      size: 50.0,
                      color: mainColor,
                    ),
                  ),
                  backgroundColor: mainColor.withOpacity(0.2),
                  progressColor: mainColor,
                ),
                SizedBox(height: 10),
                Text(
                  'مرات التكرار : $_repeat',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                SizedBox(height: 5),
                Text(
                  'المجموع : ${_repeat * _goal + _counter}',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
              ],
            ),
            Spacer(),
            Visibility(
              visible: isActive,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Color(kred)),
                      value: kred,
                      groupValue: selectedColor,
                      onChanged: (val) {
                        setState(() {
                          setColor(val!);
                        });
                      }),
                  Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Color(kblack)),
                      value: kblack,
                      groupValue: selectedColor,
                      onChanged: (val) {
                        setState(() {
                          setColor(val!);
                        });
                      }),
                  Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Color(kpurple)),
                      value: kpurple,
                      groupValue: selectedColor,
                      onChanged: (val) {
                        setState(() {
                          setColor(val!);
                        });
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
