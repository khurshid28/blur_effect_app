import 'dart:io';

import 'package:blur_effect_app/adress/imagesAdress.dart';
import 'package:blur_effect_app/screens/filtrScreen.dart';
import 'package:blur_effect_app/widgets/myAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';


class ImagesScreen extends StatefulWidget {
  ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  
  PageController? controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(
    initialPage:ImagesAdress.currentPage,
    viewportFraction: 0.8,
  );
  }
 

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    ScreenUtil.init(
    BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height),
    designSize: Size(411, 899),
    context: context,
    minTextAdapt: true,
    orientation: Orientation.portrait);
    return  Scaffold(
      backgroundColor: Colors.blueGrey,
      floatingActionButton: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                borderRadius:const BorderRadius.all(Radius.circular(40),),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 40.r,
                  child: Text("Back",style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold,),),
                ),
              ),
     appBar: MyAppBar.build(),
     body: Center(
       child: SizedBox(
         width: size.width,
         height: 360.h,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             if (ImagesAdress.list.isEmpty) 
             const Center(
               child: Text("No Image Here !!!",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,),),
             ),
             if (ImagesAdress.list.isNotEmpty)  SizedBox(
               height: 20.h,
               child: Center(child: Text("${ImagesAdress.currentPage  +1}/${ImagesAdress.list.length}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19.sp,color: Colors.white),),),
             ),
             
             SizedBox(
               width: size.width,
               height: 300.h,
               child: PageView.builder(
                 onPageChanged: (v){
                      ImagesAdress.currentPage =v;
                      setState(() {});
                 },
                 controller: controller,
                 itemCount: ImagesAdress.list.length,
                 itemBuilder: (context,index){
                   return InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>FiltrScreen()));
                     },
                     onLongPress: (){
                        showDialog(
                         context: context,
                          builder: (context)=>CupertinoAlertDialog(
                           content:  Text( "Are you sure that image deleted?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: SizedBox(
                                  width: 90.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:const [
                                      Text("CANCEL",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                onPressed: () async{
                                  Navigator.of(context).pop();
                                },),
                              CupertinoDialogAction(
                                child: SizedBox(
                                  width: 90.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:const [
                                      Text("OK",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                onPressed: () async{
                                  Navigator.of(context).pop();
                                  List<File> _list=[];
                                  if(index==ImagesAdress.list.length-1){
                                    ImagesAdress.currentPage= ImagesAdress.list.isEmpty ? 0 : ImagesAdress.list.length-2;
                                  }
                                  for (var element in ImagesAdress.list) {
                                    if(ImagesAdress.list[index] != element){
                                      _list.add(element);
                                    }
                                  }

                                  ImagesAdress.list=_list;

                                  setState(() {});
                                  
                               
                                },),

                          ],
                          ),
                         );
                     },
                     child: Hero(
                       tag: index.toString(),
                       child: Container(
                         width: 300.w,
                         height: 300.h,
                         margin: EdgeInsets.symmetric(horizontal: 10.h),
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.white,width: 5.w),
                           image: DecorationImage(image: FileImage(ImagesAdress.list[index]),
                           fit: BoxFit.cover,
                           ),
                          
                         ),
                       ),
                     ),
                   );
                 }
                 ),
             ),
           ],
         ),
       ),
       ),
    );
  }
}