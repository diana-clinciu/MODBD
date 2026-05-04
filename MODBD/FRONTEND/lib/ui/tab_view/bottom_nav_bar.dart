import 'package:flutter/material.dart';
import 'package:mvvm_flutter/ui/tab_view/tab_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_flutter/internal_models/app_colors.dart';

class _NavItem extends StatelessWidget {
  final String? label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
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
            padding: const EdgeInsets.only(bottom: 12, top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: 24,
                  color: isSelected
                      ? AppColors.oliveColor
                      : AppColors.blackForestColor,
                ),
                const SizedBox(width: 6),
                Text(
                  label ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.w900 : FontWeight.w600,
                    color: isSelected
                        ? AppColors.oliveColor
                        : AppColors.blackForestColor,
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
                    borderRadius: const BorderRadius.only(
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
                        padding:
                            const EdgeInsets.only(left: 16, top: 16),
                        child: Text('Hotel Manager',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackForestColor)),
                      ),
                      Row(
                        children: [
                          _NavItem(
                            label: 'Local',
                            icon: Icons.place_outlined,
                            selectedIcon: Icons.place,
                            isSelected:
                                viewModel.activeTab == AppTabType.local,
                            onTap: () =>
                                viewModel.selectTab(AppTabType.local),
                          ),
                          _NavItem(
                            label: 'Global',
                            icon: Icons.public_outlined,
                            selectedIcon: Icons.public,
                            isSelected:
                                viewModel.activeTab == AppTabType.global,
                            onTap: () =>
                                viewModel.selectTab(AppTabType.global),
                          ),
                          _NavItem(
                            label: 'Statistici',
                            icon: Icons.bar_chart_outlined,
                            selectedIcon: Icons.bar_chart,
                            isSelected:
                                viewModel.activeTab == AppTabType.statistici,
                            onTap: () => viewModel
                                .selectTab(AppTabType.statistici),
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
