

import 'dart:math';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:blur/blur.dart';
import 'package:blur_effect_app/adress/imagesAdress.dart';
import 'package:blur_effect_app/widgets/myAppBar.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class FiltrScreen extends StatefulWidget {
  const FiltrScreen({ Key? key }) : super(key: key);
  @override
  _FiltrScreenState createState() => _FiltrScreenState();
}
class _FiltrScreenState extends State<FiltrScreen> with TickerProviderStateMixin{
  double blurEffect=0;
  Color blurColor=Colors.white;
  double colorOpacity=0;
  String value ="Value: 0";
  TabController? tabController;
  ScreenshotController screenshotController = ScreenshotController(); 
  @override
  void initState() {
    tabController=TabController(length: 3,vsync: this);
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 40.w,),
              Text(value,style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold,),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                        InkWell(
                        onTap: ()async{
                         Uint8List? bydata= await screenshotController.capture();
                         String imageSize=getFileSizeString(bytes:(bydata!).length);
                         await ImageGallerySaver.saveImage(bydata,name:  DateTime.now().toIso8601String());
                          await Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor: Colors.green,
                                title: 'Blur Effect App',
                                message:
                                    'Image is saved to Gallery ('+imageSize+")",
                                duration:const Duration(seconds: 3),
                            ).show(context);
                          
                        },
                        borderRadius:const BorderRadius.all(Radius.circular(40),),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 40.r,
                          child:const Icon(Icons.save_alt_rounded,size: 50,color: Colors.white,),
                        ),
                      ),
               SizedBox(
                width: 20.w,
              ),
              InkWell(
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
            ],
          ),
        ],
      ),
     appBar: MyAppBar.build(),
     body: Column(
       children: [
          SizedBox(height: 20.h,),
         Hero(
           tag: ImagesAdress.currentPage.toString(),
           child: Container(
             color: Colors.white,
             padding: EdgeInsets.all(5.w),
             child: Screenshot(
               controller: screenshotController,
               child: Blur(
                 blur: blurEffect,
                 blurColor: blurColor,
                 colorOpacity: colorOpacity,
                 child: Container(
                   width: size.width-10.w,
                   height: (size.width-10.w),
                   decoration: BoxDecoration(
                    
                      image: DecorationImage(image: FileImage(ImagesAdress.list[ImagesAdress.currentPage]),
                        fit: BoxFit.cover,
                      ),

                   ),
                 ),
               ),
             ),
           ),
         ),
          SizedBox(height: 15.h,),
         SizedBox(
           height: 35.h,
           child: TabBar(
             onTap: (v){
               if (v==0) {
                 value="Value: "+(blurEffect).toInt().toString();
               }else if(v==2){
                 value="Value: "+(colorOpacity*100).toInt().toString()+" %";
               }
                else {
                  value="";
               }
               setState(() {});
             },
             indicatorColor: Colors.black,
             controller: tabController,
             tabs: [
               Container(
                 alignment: Alignment.center,
                 width: 100.w,
                 child:const Text("Blur effect")),
                Container(
                  alignment: Alignment.center,
                 width: 100.w,
                 child:const Text("Blurcolor")),
                Container(
                  alignment: Alignment.center,
                 width: 100.w,
                 child:const Text("Color opacity")),
             ],
             ),
         ),

         Container(
           width: size.width,
           height: 320.h,
           child: TabBarView(
             controller:tabController ,
             children: [
               Container(
                 width: size.width,
                 child: Slider(
                   thumbColor: Colors.white,
                   activeColor: Colors.black,
                   inactiveColor: Colors.grey,
                   value: blurEffect,
                   max: 20,
                   min: 0,
                  onChanged: (v){
                      blurEffect=v;
                      value="Value: "+(blurEffect).toInt().toString();
                      setState(() {});
                    },
                   ),
               ),
               Container(
                 width: size.width,

                 child:ColorPicker(
                  color: blurColor,
                    onColorChanged: (Color v){
                      blurColor=v;
                      
                      setState(() {});
                    },
                    ),
               ),
               Container(
                 width: size.width,
                 child:  Slider(
                   thumbColor: Colors.white,
                   activeColor: Colors.black,
                   inactiveColor: Colors.grey,
                   value: colorOpacity,
                   max: 1,
                   min: 0,
                  onChanged: (v){
                      colorOpacity=v;
                      value="Value: "+(colorOpacity*100).toInt().toString()+" %";
                      setState(() {});
                    },
                   ),
               ),
             ],
             ),
         ),

       ],
     ),
    );
  }
      String getFileSizeString({@required int? bytes, int decimals = 0}) {
      if (bytes! <= 0) return "0 Bytes";
      const suffixes = [" Bytes", " KB", " MB", " GB", " TB"];
      var i = (log(bytes) / log(1024)).floor();
      return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
}