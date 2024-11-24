import 'package:kms/utils/index.dart';
void main(){
    String path = "F:\\server";
    Utils.walkDir(path).then((value) {
      print(value);

    });

}