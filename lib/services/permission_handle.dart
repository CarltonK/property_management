//import 'package:permission_handler/permission_handler.dart';
//
//class PermissionService {
//  //Instantiate permission handler
//  final PermissionHandler _permissionHandler = PermissionHandler();
//
//  //This function requests a specific permission
//  //The parameter is a list or permissions otherwise called a Permission Group
//  Future<bool> requestPermission(PermissionGroup permissionGroup) async {
//    //Request permissions in a permission group
//    var result = await _permissionHandler.requestPermissions([permissionGroup]);
//    print('result: $result');
//    //result is a Map. To request the value of a single entry, pass the key,
//    //which is an entry in the permissiongroup
//    if (result[permissionGroup] == PermissionStatus.granted) {
//      //If permission is granted return true
//      return true;
//    }
//    //Call the permission request window
//    await _permissionHandler
//        .shouldShowRequestPermissionRationale(permissionGroup);
//    return false;
//    //Otherwise return false by default
//  }
//
//  //All permissions required by this application
//  List<PermissionGroup> requiredPerms = [PermissionGroup.location];
//  Future<bool> requestallPermissions() async {
//    for (int i = 0; i < requiredPerms.length; i++) {
//      await requestPermission(requiredPerms[i]);
//    }
//    return null;
//  }
//}
