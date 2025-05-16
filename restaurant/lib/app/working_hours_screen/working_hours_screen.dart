import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialog.dart';
import 'package:restaurant/controller/working_hours_controller.dart';
import 'package:restaurant/themes/app_them_data.dart';
import 'package:restaurant/themes/round_button_fill.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/widget/my_separator.dart';

class WorkingHoursScreen extends StatelessWidget {
  const WorkingHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: WorkingHoursController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark
                : AppThemeData.surface,
            appBar: AppBar(
              backgroundColor: AppThemeData.secondary300,
              centerTitle: false,
              iconTheme: IconThemeData(
                  color: themeChange.getThem()
                      ? AppThemeData.grey800
                      : AppThemeData.grey100,
                  size: 20),
              title: Text(
                "Working Hours".tr,
                style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.grey800
                        : AppThemeData.grey100,
                    fontSize: 18,
                    fontFamily: AppThemeData.medium),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.grey50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.workingHours.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                MySeparator(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey700
                                        : AppThemeData.grey200),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${controller.workingHours[index].day}"
                                            .tr,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey100
                                              : AppThemeData.grey800,
                                          fontSize: 18,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          controller.addValue(index);
                                        },
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_add_one.svg"))
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller
                                      .workingHours[index].timeslot!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, indexTimeSlot) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () async {
                                                  TimeOfDay? startTime =
                                                      await _selectTime(
                                                          context);
                                                  controller
                                                      .workingHours[index]
                                                      .timeslot![indexTimeSlot]
                                                      .from = DateFormat(
                                                          'HH:mm')
                                                      .format(DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                          startTime!.hour,
                                                          startTime.minute));
                                                },
                                                child: Container(
                                                  decoration: ShapeDecoration(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .surfaceDark
                                                        : AppThemeData.surface,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              controller
                                                                      .workingHours[
                                                                          index]
                                                                      .timeslot![
                                                                          indexTimeSlot]
                                                                      .from!
                                                                      .isEmpty
                                                                  ? 'Start Time'
                                                                      .tr
                                                                  : controller
                                                                      .workingHours[
                                                                          index]
                                                                      .timeslot![
                                                                          indexTimeSlot]
                                                                      .from
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: controller
                                                                          .workingHours[
                                                                              index]
                                                                          .timeslot![
                                                                              indexTimeSlot]
                                                                          .to!
                                                                          .isEmpty
                                                                      ? themeChange
                                                                              .getThem()
                                                                          ? AppThemeData
                                                                              .grey600
                                                                          : AppThemeData
                                                                              .grey400
                                                                      : themeChange
                                                                              .getThem()
                                                                          ? AppThemeData
                                                                              .grey100
                                                                          : AppThemeData
                                                                              .grey900),
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.access_time,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey200
                                                                : AppThemeData
                                                                    .grey700,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () async {
                                                  TimeOfDay? endTimeOfDay =
                                                      await _selectTime(
                                                          context);

                                                  if (endTimeOfDay != null) {
                                                    DateTime endTime = DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month,
                                                        DateTime.now().day,
                                                        endTimeOfDay.hour,
                                                        endTimeOfDay.minute);
                                                    DateTime time = DateFormat(
                                                            "HH:mm")
                                                        .parse(controller
                                                            .workingHours[index]
                                                            .timeslot![
                                                                indexTimeSlot]
                                                            .from
                                                            .toString());
                                                    DateTime startTime =
                                                        DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day,
                                                            time.hour,
                                                            time.minute);

                                                    if (startTime
                                                        .isAfter(endTime)) {
                                                      ShowToastDialog.showToast(
                                                          "Please select Valid Time"
                                                              .tr);
                                                    } else {
                                                      if (endTimeOfDay
                                                              .format(context)
                                                              .toString() ==
                                                          "12:00 AM") {
                                                        controller
                                                            .workingHours[index]
                                                            .timeslot![
                                                                indexTimeSlot]
                                                            .to = DateFormat(
                                                                'HH:mm')
                                                            .format(DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day,
                                                                23,
                                                                59));
                                                      } else {
                                                        controller
                                                            .workingHours[index]
                                                            .timeslot![
                                                                indexTimeSlot]
                                                            .to = DateFormat(
                                                                'HH:mm')
                                                            .format(DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day,
                                                                endTimeOfDay
                                                                    .hour,
                                                                endTimeOfDay
                                                                    .minute));
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  decoration: ShapeDecoration(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .surfaceDark
                                                        : AppThemeData.surface,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              controller
                                                                      .workingHours[
                                                                          index]
                                                                      .timeslot![
                                                                          indexTimeSlot]
                                                                      .to!
                                                                      .isEmpty
                                                                  ? 'End Time'
                                                                      .tr
                                                                  : controller
                                                                      .workingHours[
                                                                          index]
                                                                      .timeslot![
                                                                          indexTimeSlot]
                                                                      .to
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: controller
                                                                          .workingHours[
                                                                              index]
                                                                          .timeslot![
                                                                              indexTimeSlot]
                                                                          .to!
                                                                          .isEmpty
                                                                      ? themeChange
                                                                              .getThem()
                                                                          ? AppThemeData
                                                                              .grey600
                                                                          : AppThemeData
                                                                              .grey400
                                                                      : themeChange
                                                                              .getThem()
                                                                          ? AppThemeData
                                                                              .grey100
                                                                          : AppThemeData
                                                                              .grey800),
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.access_time,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey200
                                                                : AppThemeData
                                                                    .grey700,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.remove(
                                                  index, indexTimeSlot);
                                            },
                                            child: Text(
                                              "Remove Time".tr,
                                              style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.danger300
                                                      : AppThemeData.danger300,
                                                  fontSize: 16,
                                                  fontFamily:
                                                      AppThemeData.medium),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            bottomNavigationBar: Container(
              color: themeChange.getThem()
                  ? AppThemeData.grey900
                  : AppThemeData.grey50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RoundedButtonFill(
                  title: "Save Details".tr,
                  height: 5.5,
                  color: themeChange.getThem()
                      ? AppThemeData.secondary300
                      : AppThemeData.secondary300,
                  textColor: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  fontSizes: 16,
                  onPress: () async {
                    bool isEmptyField = false;
                    for (var element in controller.workingHours) {
                      var emptyList = element.timeslot!.where((element) =>
                          element.from!.isEmpty || element.to!.isEmpty);
                      if (element.timeslot!.isNotEmpty &&
                          emptyList.isNotEmpty &&
                          !isEmptyField) {
                        ShowToastDialog.showToast(
                            "Please enter valid details".tr);
                        isEmptyField = true;
                        continue;
                      }
                    }

                    if (!isEmptyField) {
                      controller.saveWorkingHours();
                    }
                  },
                ),
              ),
            ),
          );
        });
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode()); //remove focus
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      return newTime;
    }
    return null;
  }
}
