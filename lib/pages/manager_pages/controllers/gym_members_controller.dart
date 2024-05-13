import 'package:get/get.dart';

class GymMemberController extends GetxController {
  Rx enddate = "".obs;

  endDateUpdate(String enddate) {
    this.enddate.value = enddate;
  }
}
