import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:blur_effect_app/adress/imagesAdress.dart';
import 'package:blur_effect_app/screens/imagesScreen.dart';
import 'package:blur_effect_app/widgets/myAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GetPictureScreen extends StatefulWidget {
  const GetPictureScreen({ Key? key }) : super(key: key);

  @override
  _GetPictureScreenState createState() => _GetPictureScreenState();
}

class _GetPictureScreenState extends State<GetPictureScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool isOk=false;
  
  @override
  void initState() {
    super.initState();
    checkPer();
  }
  checkPer()async{
     await Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      print("ok check");
     
      isOk=true;
      setState(() {});
    }
    else{
        await Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.red,
          title: 'Blur Effect App',
          message:'Cannot use this App',
          duration:const Duration(seconds: 4),
      ).show(context);
     exit(0);
    }
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
    return !isOk ? 
      Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: MyAppBar.build(),
        body:  Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 10.r,
          ),
        ),
        )
    :Scaffold(
      backgroundColor: Colors.blueGrey,
      floatingActionButton: InkWell(
                onTap: ()async{
                  ImagesAdress.currentPage= ImagesAdress.list.length-1 ==-1? 0 : ImagesAdress.list.length-1;
                  await Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: ImagesScreen()));
                  image=null;
                  setState(() {});
                },
                borderRadius: BorderRadius.all(Radius.circular(40.r),),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 40.r,
                  child: Text("Images",style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold,),),
                ),
              ),
      appBar: MyAppBar.build(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           image!=null 
           ?
           Container(
             width: 300.w,
             height: 300.h,
             decoration: BoxDecoration(
               border: Border.all(color: Colors.white,width: 5.w),
               image: DecorationImage(
                 image: FileImage(File(image!.path),
                 ),
                 fit: BoxFit.cover,
               ),
             ),
           )
           :
            InkWell(
              onTap: (){
                 showDialog(
                   context: context,
                    builder: (context)=>CupertinoAlertDialog(
                     content:  Text( "Which one? Camera or Gallery",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: SizedBox(
                            width: 90.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:const [
                                Icon(Icons.camera_alt_rounded,color: Colors.black,),
                                Text("Camera",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          onPressed: () async{
                            Navigator.of(context).pop();
                            image = await _picker.pickImage(source: ImageSource.camera);
                            setState(() {});
                          },),
                        CupertinoDialogAction(
                          child: SizedBox(
                            width: 90.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:const [
                                Icon(Icons.image_rounded,color: Colors.black,), 
                                Text("Gallery",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          onPressed: () async{
                            Navigator.of(context).pop();
                            image = await _picker.pickImage(source: ImageSource.gallery);
                            setState(() {});
                          },),

                    ],
                    ),
                   );
              },
              borderRadius: BorderRadius.all(Radius.circular(120.r)),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 120.r,
                child:const Icon(Icons.image,size: 100,),
                ),
            ),
            if(image ==null)
               SizedBox(height: 25.h,),
            if(image ==null)  
               Text("Pick Image",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24.sp,shadows:const [Shadow(color: Colors.black,offset: Offset(1, 1),blurRadius: 1)]),),
            if(image !=null)
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: size.width/2-165.w,vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: ()async{
                        String imageSize=getFileSizeString(bytes:(await File(image!.path).readAsBytes()).length);
                        image=null;
                        setState(() {});
                        await Flushbar(
                          flushbarPosition: FlushbarPosition.TOP,
                          backgroundColor: Colors.blue,
                          title: 'Blur Effect App',
                          message:
                              'Image is deleted ('+imageSize+")",
                          duration:const Duration(seconds: 2),
                      ).show(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            
                            Text("Delete",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp)),
                           const Icon(Icons.delete_outline_rounded,color: Colors.white,size: 30,), 
                        ],
                      ),
                    ),
                     InkWell(
                       splashColor: Colors.transparent,
                       highlightColor: Colors.transparent,
                        onTap: ()async{
                          ImagesAdress.list.add(File(image!.path));
                           String imageSize=getFileSizeString(bytes:(await File(image!.path).readAsBytes()).length);
                          image=null;
                          setState(() {});
                         
                          await Flushbar(
                            flushbarPosition: FlushbarPosition.TOP,
                            backgroundColor: Colors.green,
                            title: 'Blur Effect App',
                            message:
                                'Image is saved ('+imageSize+")",
                            duration:const Duration(seconds: 2),
                        ).show(context);
                      },
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           const Icon(Icons.save_alt_rounded,color: Colors.white,size: 30,), 
                            Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.sp)),
                        ],
                    ),
                     ),
                  ],
                ),
              ),

          ],
        ),
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