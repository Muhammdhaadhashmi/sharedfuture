import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_future/Utils/app_colors.dart';
import 'package:shared_future/Utils/dimensions.dart';
import 'package:shared_future/Utils/spaces.dart';
import 'package:shared_future/Utils/text_view.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../LocalDatabaseHelper/local_database_handler.dart';

class AccountListItem extends StatelessWidget {
  final listItem;

   AccountListItem({super.key, required this.listItem});

  LocalDatabaseHepler db = LocalDatabaseHepler();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Dimensions.screenWidth(context),
      child: InkWell(
        onTap: () async{
          if(listItem["title"]=="Log out"){
            // final db = await openDatabase('db_sharedfuture');
            // await db.execute('DELETE FROM tbl_login');
            db.deleteTable(tableName: "tbl_login");
            db.deleteTable(tableName: "tbl_cart");
            Get.offAll(
              listItem["onTap"],
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 600),
            );
          }else{
            Get.to(
              listItem["onTap"],
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 600),
            );
          }

        },
        child: Row(
          children: [
            AddHorizontalSpace(20),
            Container(
              height: 24,
              width: 24,
              child: Icon(
                listItem["image"],
                color: AppColors.white,
              ),
            ),
            AddHorizontalSpace(20),
            TextView(
              text: listItem["title"],
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
