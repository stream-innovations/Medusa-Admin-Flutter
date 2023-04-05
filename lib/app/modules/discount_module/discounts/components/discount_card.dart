import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medusa_admin/app/data/models/store/discount.dart';

import '../../../../routes/app_pages.dart';
import '../../../components/adaptive_icon.dart';
import 'discount_rule_type_label.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard(this.discount, {Key? key, this.onToggle, this.onDelete}) : super(key: key);
  final Discount discount;
  final void Function()? onToggle;
  final void Function()? onDelete;
// final
  @override
  Widget build(BuildContext context) {
    Color lightWhite = Get.isDarkMode ? Colors.white54 : Colors.black54;
    final smallTextStyle = Theme.of(context).textTheme.titleSmall;
    const space = SizedBox(height: 12.0);
    return InkWell(
      onTap: () => Get.toNamed(Routes.DISCOUNT_DETAILS, arguments: discount.id!),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Theme.of(context).appBarTheme.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.discount_outlined, size: 20, color: lightWhite),
                          const SizedBox(width: 6.0),
                          Flexible(child: Text(discount.code ?? '')),
                        ],
                      ),
                      if (discount.rule?.description?.isNotEmpty ?? false)
                        Text(
                          discount.rule?.description ?? '',
                          style: smallTextStyle?.copyWith(color: lightWhite),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    DiscountRuleTypeLabel(discount: discount),
                    AdaptiveIcon(
                        onPressed: () async {
                          await showModalActionSheet<int>(context: context, actions: <SheetAction<int>>[
                            const SheetAction(label: 'Edit', key: 0),
                            discount.isDisabled == null || !discount.isDisabled!
                                ? const SheetAction(label: 'Disable', key: 1)
                                : const SheetAction(label: 'Enable', key: 1),
                            const SheetAction(label: 'Delete', isDestructiveAction: true, key: 2),
                          ]).then((value) async {
                            if (value == null) {
                              return;
                            }
                            switch (value) {
                              case 0:
                                Get.toNamed(Routes.ADD_UPDATE_DISCOUNT, arguments: discount.id!);
                                break;
                              case 1:
                                if (onToggle != null) {
                                  onToggle!();
                                }
                                break;
                              case 2:
                                await showOkCancelAlertDialog(
                                        context: context,
                                        title: 'Delete Promotion',
                                        message: 'Are you sure you want to delete this promotion?',
                                        okLabel: 'Yes, delete',
                                        cancelLabel: 'Cancel',
                                        isDestructiveAction: true)
                                    .then((value) async {
                                  if (value == OkCancelResult.ok) {
                                    if (onDelete != null) {
                                      onDelete!();
                                    }
                                  }
                                });
                                break;
                            }
                          });
                        },
                        icon: const Icon(Icons.more_horiz))
                  ],
                ),
              ],
            ),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Redemptions: ${discount.usageCount}',
                  style: smallTextStyle?.copyWith(color: lightWhite),
                ),
                DiscountStatusDot(disabled: discount.isDisabled ?? true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
