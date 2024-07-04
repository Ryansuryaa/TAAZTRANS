import 'package:az_travel/app/routes/app_pages.dart';
import 'package:az_travel/app/theme/theme.dart';
import 'package:az_travel/app/utils/textfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../controllers/dashboard_user_controller.dart';

class DashboardUserView extends GetView<DashboardUserController> {
  const DashboardUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final c = Get.put(DashboardUserController());

    // add scrollcontroller to listen scroll activity for appbar
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset > (125 - kToolbarHeight) &&
          !c.showTitle.value) {
        c.showTitle.value = true;
      } else if (scrollController.offset <= (125 - kToolbarHeight) &&
          c.showTitle.value) {
        c.showTitle.value = false;
      }
    });
    return Scaffold(
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            c.resetAnimationOnScroll();
          }
          return false;
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            Obx(
              () => SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 15.h,
                centerTitle: false,
                title: c.showTitle.value
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: 2.5.w,
                          right: 2.5.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            formInput(
                                key: c.searchFormKey2.value,
                                width: 65.w,
                                height: 5.h,
                                hintTextFontSize: 10.sp,
                                textEditingController: c.searchC,
                                hintText: 'Cari dan Pesan Mobil...',
                                iconPrefix: PhosphorIconsBold.magnifyingGlass,
                                keyboardType: TextInputType.text,
                                validator: null,
                                isDatePicker: false),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: ClipOval(
                                    child: Container(
                                      width: 8.w,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: blue_0C134F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding:
                        EdgeInsets.only(left: 6.5.w, right: 6.5.w, top: 5.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AZ Travel',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            formInput(
                                key: c.searchFormKey.value,
                                width: 65.w,
                                height: 5.h,
                                hintTextFontSize: 10.sp,
                                textEditingController: c.searchC,
                                hintText: 'Cari dan Pesan Mobil...',
                                iconPrefix: PhosphorIconsBold.magnifyingGlass,
                                keyboardType: TextInputType.text,
                                validator: null,
                                isDatePicker: false),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: ClipOval(
                                    child: Container(
                                      width: 12.w,
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: blue_0C134F),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 4.w),
                    child: StreamBuilder(
                        stream: c.firestoreDataMobilList,
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final dataMobilList = snap.data!;
                          if (dataMobilList.isEmpty) {
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text('Data kosong.'),
                                ),
                              ],
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: dataMobilList.length,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 0.1.h),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    childAspectRatio: 0.65,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0),
                            itemBuilder: (context, index) {
                              // initiate animation and duration for animation each index
                              if (c.cAniDashboardCategories[index] == null) {
                                c.cAniDashboardCategories[index] =
                                    AnimationController(
                                  vsync: c,
                                  duration: const Duration(milliseconds: 70),
                                );
                                c.isItemClicked[index] = false;
                              }

                              var dataMobil = dataMobilList[index];
                              final formatCurrency =
                                  NumberFormat.simpleCurrency(
                                      locale: 'id_ID', decimalDigits: 0);
                              int hargaPerHariIDR =
                                  int.parse(dataMobil.hargaPerHari!);
                              return AnimatedBuilder(
                                animation: c.cAniDashboardCategories[index]!,
                                builder: (context, child) {
                                  return ScaleTransition(
                                    scale: Tween(begin: 1.0, end: 0.95).animate(
                                        c.cAniDashboardCategories[index]!),
                                    child: child,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 4, right: 4, bottom: 4),
                                  child: GestureDetector(
                                    onLongPressDown: (details) {
                                      c.cAniDashboardCategories[index]!
                                          .forward();
                                    },
                                    onLongPressEnd: (details) async {
                                      await c.cAniDashboardCategories[index]!
                                          .reverse();
                                      await Get.toNamed(Routes.DETAIL_MOBIL,
                                          arguments: dataMobil);
                                    },
                                    child: InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: () {
                                        c.cAniDashboardCategories[index]!
                                            .forward();
                                        Future.delayed(
                                            const Duration(milliseconds: 70),
                                            () {
                                          c.cAniDashboardCategories[index]!
                                              .reverse();
                                        });
                                        Get.toNamed(Routes.DETAIL_MOBIL,
                                            arguments: dataMobil);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: black.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                              child: Image.network(
                                                dataMobil.fotoMobil!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 1.5.h,
                                                  left: 3.w,
                                                  right: 3.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        dataMobil.namaMobil!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              fontSize: 12.sp,
                                                              height: 1,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Text(
                                                        dataMobil.merek!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium!
                                                            .copyWith(
                                                              fontSize: 9.sp,
                                                              height: 1,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Text(
                                                        '${formatCurrency.format(hargaPerHariIDR)}/hari',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium!
                                                            .copyWith(
                                                              fontSize: 10.sp,
                                                              height: 1,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 0.7.h,
                                                      ),
                                                      Text(
                                                        'Tahun ${dataMobil.tahun!}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium!
                                                            .copyWith(
                                                              fontSize: 9.sp,
                                                              height: 1,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      c.cAniDashboardCategories[
                                                              index]!
                                                          .forward();
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds: 70),
                                                          () {
                                                        c.cAniDashboardCategories[
                                                                index]!
                                                            .reverse();
                                                      });
                                                      Get.toNamed(
                                                          Routes.DETAIL_MOBIL,
                                                          arguments: dataMobil);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          PhosphorIconsLight
                                                              .caretRight,
                                                          size: 6.w,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
