import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mark2/app/enum.dart';
import 'package:mark2/home/bloc/hobbies_bloc.dart';
import 'package:mark2/home/model/list_model.dart';
import 'package:mark2/home/repository/home_repo.dart';
import 'package:mark2/home/widget/alert_dialog.dart';
import 'package:mark2/selection/screens/selection_screen.dart';
import 'package:mark2/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget home() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) {
            return GetHobbies();
          },
        ),
        BlocProvider(
          create: (BuildContext context) => HobbiesBloc(
            hobbiesRepo: context.read<GetHobbies>(),
          )..add(GetHobbiesEvent()),
        ),
      ],
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HobbyData> selectedList = [];
  int hobbyIndex = 0;

  int hobbyItemIndex = 0;
  List<List<bool>> selected = [];

  int hobbyCount = 0;

  Color nextButtonColor = Colors.grey; // Initially set to grey

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlueShimmer,
      appBar: AppBar(
        title: const Text(
          'Select Category',
          style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600),
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
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
        child: Container(
          color: AppColors.white,
          child: BlocConsumer<HobbiesBloc, HobbiesState>(
            listener: (context, state) {
              if (state is HobbyListingState && state.status == Status.loaded) {
                selected = List.generate(state.listHobbies?.length ?? 0, (index) => List.generate(20, (index) => false));
              }
            },
            builder: (context, state) {
              if (state is HobbyListingState && state.status == Status.loaded) {
                hobbyCount = state.listHobbies?.length ?? 0;

                return ListView(
                  children: [
                    ListView.builder(
                      key: Key(hobbyIndex.toString()),
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      itemCount: state.listHobbies?.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.tileColor,
                          ),
                          child: ExpansionTile(
                            trailing: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(1),
                                    spreadRadius: -2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                index == hobbyIndex ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                color: const Color(0xff14152B),
                              ),
                            ),
                            key: Key(index.toString()),
                            initiallyExpanded: index == hobbyIndex,
                            shape: const StadiumBorder(),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                              child: Text(
                                state.listHobbies?[index].hobbyName ?? '',
                                style:
                                    const TextStyle(color: AppColors.tileTitleColor, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            onExpansionChanged: ((state) {
                              if (state) {
                                setState(() {
                                  hobbyIndex = index;
                                });
                              } else {
                                setState(() {
                                  hobbyIndex = -1;
                                });
                              }
                            }),
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                                color: AppColors.white,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2 / 4,
                                    crossAxisCount: 5,
                                    mainAxisSpacing: .0,
                                    crossAxisSpacing: 26.0,
                                  ),
                                  itemCount: state.listHobbies?[index].hobbyDataList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        int count = selected[hobbyIndex].where((element) => element).length;
                                        hobbyItemIndex = index;
                                        if (count <= 4) {
                                          selection(hobbyIndex, hobbyItemIndex);
                                        } else {
                                          if (selected[hobbyIndex][index]) {
                                            selection(hobbyIndex, hobbyItemIndex);
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
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: !selected[hobbyIndex][index]
                                                ? BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: const Color(0xff14152B)),
                                                    color: AppColors.white,
                                                  )
                                                : BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: const Color(0xff063B6D)),
                                                    color: AppColors.grey200,
                                                  ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(9.0),
                                              child: SvgPicture.asset(
                                                  state.listHobbies?[hobbyIndex].hobbyDataList[index].link ?? ''),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 3.0),
                                            child: Text(
                                              state.listHobbies?[hobbyIndex].hobbyDataList[index].hobbyName ?? '',
                                              style: const TextStyle(fontSize: 10),
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 41.0, right: 41, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0DA8F5), Color(0xFF2255FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(35), // Adjust the radius as needed
                        ),
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            bool isValidate = true;
                            for (int i = 0; i < selected.length; i++) {
                              if (!validation(i)) {
                                isValidate = false;
                                break;
                              }
                            }
                            if (isValidate) {
                              for (int i = 0; i < (state.listHobbies?.length ?? 0); i++) {
                                for (int j = 0; j < (state.listHobbies?[i].hobbyDataList.length ?? 0); j++) {
                                  if (selected[i][j]) {
                                    selectedList
                                        .add(state.listHobbies?[i].hobbyDataList[j] ?? HobbyData(hobbyName: '', link: ''));
                                  }
                                }
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SelectionScreen(),
                                    settings: RouteSettings(arguments: selectedList),
                                  )).then((value) => selectedList.clear());
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialogBox();
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: AppColors.transparent,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ),
    );
  }

  void selection(int listIndex, int tileIndex) {
    setState(() {
      selected[listIndex][tileIndex] = !selected[listIndex][tileIndex];
    });
  }

  bool validation(int listIndex) {
    int count = selected[listIndex].where((element) => element).length;
    return count >= 2 && count <= 5;
  }
}

class CustomSnackbar extends StatelessWidget {
  final String message;

  const CustomSnackbar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      // Adjust duration as needed
      backgroundColor: Colors.blue,
      // Customize background color
      behavior: SnackBarBehavior.floating,
      // Customize behavior
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Customize border radius
      ),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
