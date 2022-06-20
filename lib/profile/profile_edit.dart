import 'dart:io';
import 'package:eradko/const.dart';
import 'package:eradko/profile/profile_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:eradko/auth/city_roles_provider.dart';
import 'package:eradko/auth/widget/drop_down_list.dart';
import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfile extends StatefulWidget {
  final LocaleUser localeUser ;
  const EditProfile({Key? key, required this.localeUser}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
 late TextEditingController nameCtrl ;
 late TextEditingController emailCtrl ;
 late TextEditingController phoneCtrl ;
 late int  roleId ;
 String  imgPath = '' ;
 String selectedRole = 'نوع الحساب' ;
 Roles? roles ;

 @override
  void initState() {
   nameCtrl = TextEditingController(text: widget.localeUser.name);
   emailCtrl = TextEditingController(text: widget.localeUser.email);
   phoneCtrl = TextEditingController(text: widget.localeUser.phone);
   selectedRole = widget.localeUser.role.name ;
   roleId = widget.localeUser.role.id ;
   WidgetsBinding.instance.addPostFrameCallback((_) async => getRoles(locale: 'ar'));
    super.initState();
  }

  Future uploadImages(BuildContext context ) async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery,maxWidth: 360  , imageQuality: 75);
    if(mounted){
      setState(() {
        imgPath = img == null  ? '' : img.path;
      });
    }
  }



  getRoles({String? locale})async{
   try{
     RolesProvider().roles(locale: locale ?? AppLocalizations.of(context)!.localeName).then((value) {
       if(mounted){
         setState(() {
           roles = value ;
         });
       }
     });
   }catch(e){
     showSnackError(context, msg: AppLocalizations.of(context)!.conectApp);
   }
 }

 _updateData() {
     ProfileProvider().updateProfileData(
     name: nameCtrl.text,
     role: Role(id: roleId, name: selectedRole),
     img: imgPath,
     email: emailCtrl.text ,
     phone: phoneCtrl.text,
   ).then((value){
       showSnackError(context, msg: value);
   });

 }


 @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context, showCart: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        child: Column(
         children: [
           const SizedBox(height: 50),
           GestureDetector(
             onTap: (){
               uploadImages(context);
             },
             child: Stack(
               alignment: Alignment.center,
               children: [
                 imgPath == '' ?
                 widget.localeUser.image == 'null' ?
                 SizedBox(
                   height: 100,
                   width: 100,
                   child: Image.asset("assets/image/user (1).png"),
                 ):
                 Container(
                   height: 100,
                   width: 100,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     image: DecorationImage(
                       image: CachedNetworkImageProvider(widget.localeUser.image),
                       fit: BoxFit.cover,
                     ),
                   ),
                 ):
                 ClipRRect(
                   borderRadius: BorderRadius.circular(80),
                   child: Container(
                     height: 100,
                     width: 100,
                     decoration: const BoxDecoration(
                       shape: BoxShape.circle,
                     ),
                     child: Image.file(File(imgPath) , fit: BoxFit.cover,),
                   ),
                 ),
                 const Icon(Icons.camera , color: Colors.white,),
               ],
             ),
           ),
          const SizedBox(height: 30),
          CustomTextField(
            hintText: AppLocalizations.of(context)!.name,
            textEditingController: nameCtrl,
            onChanged: (val){},
            obscureText: false,
          ),
           CustomTextField(
             hintText:AppLocalizations.of(context)!.email,
             textEditingController: emailCtrl,
             onChanged: (val){},
             obscureText: false,
           ),
           CustomTextField(
             hintText: AppLocalizations.of(context)!.phone,
             textEditingController: phoneCtrl,
             onChanged: (val){},
             obscureText: false,
           ),
           AccTypeList(
             roles: roles ?? Roles(data: []),
             onChanged: (String? val ) {
               setState(() {
                 selectedRole = val! ;
                 for (var acc in roles!.data) {
                   if(acc.name == val ) roleId = acc.id ;
                 }
               });
             },
             dropValue: selectedRole ,
           ),
           const SizedBox(height: 30),
           SizedBox(
             height: 50,
             width: double.infinity,
             child: RawMaterialButton(
               onPressed: () {
                 _updateData();
               },
               fillColor: accentColor,
               elevation: 0,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
               child:   Text(AppLocalizations.of(context)!.save,
                 style: const TextStyle(
                   color: Colors.white,
                 ),
               ),
             ),
           ),
         ],
        ),
      ),
    );
  }
}
