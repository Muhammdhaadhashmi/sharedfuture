import 'package:flutter/material.dart';
import 'Utils/app_colors.dart';

class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int pageIndex = 0;
  String name="";

  final pages = [
    // WorkOut(),
    // BmiCalculate(),
    // const DietPlan(),
    // const SignUpView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),

      body: pages[pageIndex],
      // bottomNavigationBar: buildMyNavBar(context),
    );
  }
  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 13,
      decoration: BoxDecoration(
        color: AppColors.mainColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  child: Icon(Icons.support)),
              SizedBox(
                height: 5,
              ),
              Text(
                "Support",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    // setState(() {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => SignUpView()));
                    //   // pageIndex = 1;
                    // });
                  },
                  child: Icon(Icons.phone)),
              SizedBox(
                height: 5,
              ),
              Text(
                "Contact Us",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpView()));
                    });
                  },
                  child: Icon(Icons.privacy_tip_outlined)),
              SizedBox(
                height: 5,
              ),
              Text(
                "Privacy Policy",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    // setState(() {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => WeightGain()));
                    // });
                  },
                  child: Icon(Icons.note_alt_sharp)),
              SizedBox(
                height: 5,
              ),
              Text(
                "Terms & Conditions",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
