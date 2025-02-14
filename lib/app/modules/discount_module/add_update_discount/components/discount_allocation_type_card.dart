import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medusa_admin/app/data/models/store/discount_rule.dart';
import 'package:medusa_admin/core/utils/extension.dart';

import '../../../../../core/utils/colors.dart';

class DiscountAllocationTypeDiscount extends StatelessWidget {
  const DiscountAllocationTypeDiscount({super.key, required this.allocationType, required this.groupValue, this.onTap});
  final AllocationType allocationType;
  final AllocationType? groupValue;
  final void Function(AllocationType allocationType)? onTap;

  @override
  Widget build(BuildContext context) {
    final manatee = ColorManager.manatee;
    final smallTextStyle = context.bodySmall;
    final mediumTextStyle = context.bodyMedium;
    final theme = context.theme;
    String title = '';
    String description = '';
    switch (allocationType) {
      case AllocationType.total:
        title = 'Total amount';
        description = 'Apply to the total amount';
        break;
      case AllocationType.item:
        title = 'Item specific';
        description = 'Apply to every allowed item';
        break;
    }
    final selected = allocationType == groupValue;
    double borderRadius = context.theme.useMaterial3 ? 12 : 4;
    final ShapeBorder shapeBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      side: selected
          ? BorderSide(color: theme.colorScheme.primaryContainer, width: 1)
          : BorderSide.none,
    );
    return Card(
      shape: shapeBorder,
      elevation: 0,
      color: theme.scaffoldBackgroundColor,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!(allocationType);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              Radio<AllocationType>(
                  value: allocationType,
                  groupValue: groupValue,
                  onChanged: (val) {
                    if (val != null) {
                      if (onTap != null) {
                        onTap!(allocationType);
                      }
                    }
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: mediumTextStyle),
                  Text(
                    description,
                    style: smallTextStyle?.copyWith(color: manatee),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
