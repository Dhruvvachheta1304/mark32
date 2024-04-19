import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mark2/home/model/list_model.dart';
import 'package:mark2/home/widget/custom_glass_button.dart';
import 'package:mark2/theme/app_colors.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<HobbyData> selectedList = [];
  List<HobbyData> finalSelectedList = [];

  @override
  void didChangeDependencies() {
    final getDataList = ModalRoute.of(context)?.settings.arguments;
    if (getDataList is List<HobbyData>) {
      selectedList = getDataList;
    }
    super.didChangeDependencies();
  }

  bool isAvail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlueShimmer,
      appBar: AppBar(
        clipBehavior: Clip.none,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Selected Category',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.darkBlueShimmer,
                AppColors.lightBlue,
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        // clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ),
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2 / 3,
                        crossAxisCount: 4,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 15.0,
                      ),
                      itemCount: selectedList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            for (int i = 0; i < finalSelectedList.length; i++) {
                              if (finalSelectedList[i] == selectedList[index]) {
                                isAvail = true;
                                break;
                              }
                            }

                            if (finalSelectedList.length < 5 && !isAvail) {
                              setState(() {
                                finalSelectedList.add(selectedList[index]);
                              });
                            } else {
                              if (isAvail) {
                                finalSelectedList.removeWhere(
                                  (element) => element == selectedList[index],
                                );
                                isAvail = false;
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.black.withOpacity(0.5),
                                    duration: const Duration(milliseconds: 1000),
                                    content: const Text(
                                      "You can't choose more than 5 items !!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 57,
                                width: 57,
                                decoration: !finalSelectedList.contains(selectedList[index])
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: AppColors.white,
                                        border: Border.all(color: const Color(0xff14152B)))
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: AppColors.grey200,
                                        border: Border.all(color: const Color(0xff063B6D))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(selectedList[index].link),
                                ),
                              ),
                              Text(
                                selectedList[index].hobbyName,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey200,
                  spreadRadius: 5,
                  offset: Offset(0, 0),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: finalSelectedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 17,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 9, right: 1),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: AppColors.tileColor,
                                  ),
                                  child: SvgPicture.asset(
                                    finalSelectedList[index].link,
                                  ),
                                ),
                                Positioned(
                                  top: -20,
                                  right: -20,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        finalSelectedList.removeAt(index);
                                        isAvail = false;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.cancel_rounded,
                                      color: AppColors.danger500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55, right: 55, bottom: 10),
                  child: SizedBox(
                    height: 45,
                    child: GlassButton(
                      text: 'Next',
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar:
    );
  }
}
