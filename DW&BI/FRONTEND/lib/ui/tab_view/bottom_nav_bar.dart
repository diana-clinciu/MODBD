import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvvm_flutter/ui/tab_view/tab_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_flutter/internal_models/image_resource.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';

class _BottomNavBarItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ImageResource iconResource;
  final ImageResource selectedIconResource;
  final bool isSelected;

  const _BottomNavBarItem({
    required this.label,
    required this.iconResource,
    required this.selectedIconResource,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.rippleEffectBackground,
          highlightColor: AppColors.rippleEffectBackground,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12, top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  isSelected
                      ? selectedIconResource.source
                      : iconResource.source,
                  width: 24,
                  height: 24,
                ),
                SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.oliveColor : AppColors.contentPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TabViewViewModel>(builder: (context, viewModel, child) {
      return Material(
        color: Colors.transparent,
        child: Container(
          height: 100,
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(27, 27, 28, 2),
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: 16),
                        child: Text("Hotel Manager",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.contentPrimary)),
                      ),
                      Row(
                        children: [
                          _BottomNavBarItem(
                            label: "OLTP",
                            iconResource: ImageResource.bottomNavOtlp,
                            selectedIconResource:
                                ImageResource.bottomNavOtlpSelected,
                            isSelected: viewModel.activeTab == AppTabType.otlp,
                            onTap: () => viewModel.selectTab(AppTabType.otlp),
                          ),
                          _BottomNavBarItem(
                            label: "DW",
                            iconResource: ImageResource.bottomNavDw,
                            selectedIconResource:
                                ImageResource.bottomNavDwSelected,
                            isSelected: viewModel.activeTab == AppTabType.dw,
                            onTap: () => viewModel.selectTab(AppTabType.dw),
                          ),
                          _BottomNavBarItem(
                            label: "Rapoarte",
                            iconResource: ImageResource.bottomNavReports,
                            selectedIconResource:
                                ImageResource.bottomNavReportsSelected,
                            isSelected: viewModel.activeTab == AppTabType.rapoarte,
                            onTap: () => viewModel.selectTab(AppTabType.rapoarte),
                          ),
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ),
      );
    });
  }
}
