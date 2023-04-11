import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medusa_admin/app/data/models/store/index.dart';
import 'package:medusa_admin/app/modules/orders_module/order_details/controllers/order_details_controller.dart';

import '../../../components/adaptive_button.dart';
import '../../../components/custom_expansion_tile.dart';
import 'order_summery_card.dart';

class OrderSummery extends StatelessWidget {
  const OrderSummery(this.order, {Key? key, this.onExpansionChanged}) : super(key: key);
  final Order order;

  final void Function(bool)? onExpansionChanged;
  @override
  Widget build(BuildContext context) {
    final refunded = order.refunds != null && order.refunds!.isNotEmpty;
    const halfSpace = SizedBox(height: 6.0);
    final mediumTextStyle = Theme.of(context).textTheme.titleMedium;
    final lightWhite = Get.isDarkMode ? Colors.white54 : Colors.black54;
    final totalTextTheme = refunded ? mediumTextStyle : Theme.of(context).textTheme.displayLarge;

    return CustomExpansionTile(
      onExpansionChanged: onExpansionChanged,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text('Summery'),
      trailing: AdaptiveButton(onPressed: () {}, padding: EdgeInsets.zero, child: const Text('Edit Order')),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:order.items!.length ,
            itemBuilder: (context, index) => OrderSummeryCard(order: order, index: index)),
        const Divider(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: mediumTextStyle),
                  Row(
                    children: [
                      Text(getPrice(order.subTotal), style: mediumTextStyle),
                      Text(' ${order.currencyCode?.toUpperCase() ?? ''}',
                          style: mediumTextStyle?.copyWith(color: lightWhite)),
                    ],
                  ),
                ],
              ),
            ),
            halfSpace,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping', style: mediumTextStyle),
                  Row(
                    children: [
                      Text(getPrice(order.shippingTotal), style: mediumTextStyle),
                      Text(' ${order.currencyCode?.toUpperCase() ?? ''}',
                          style: mediumTextStyle?.copyWith(color: lightWhite)),
                    ],
                  ),
                ],
              ),
            ),
            halfSpace,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax', style: mediumTextStyle),
                  Row(
                    children: [
                      Text(getPrice(order.taxTotal), style: mediumTextStyle),
                      Text(' ${order.currencyCode?.toUpperCase() ?? ''}',
                          style: mediumTextStyle?.copyWith(color: lightWhite)),
                    ],
                  ),
                ],
              ),
            ),
            halfSpace,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(refunded ? 'Original Total' : 'Total', style: totalTextTheme),
                  Text(getPrice(order.total), style: Theme.of(context).textTheme.displayLarge),
                ],
              ),
            ),
            halfSpace,
          ],
        ),
        if (refunded)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Manually refunded', style: mediumTextStyle),
                    Row(
                      children: [
                        Text(getPrice(order.refundedTotal), style: mediumTextStyle),
                        Text(' ${order.currencyCode?.toUpperCase() ?? ''}',
                            style: mediumTextStyle?.copyWith(color: lightWhite)),
                      ],
                    ),
                  ],
                ),
              ),
              halfSpace,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Net Total', style: mediumTextStyle),
                    Text(getPrice(order.refundableAmount), style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              halfSpace,
            ],
          ),
      ],
    );
  }

  String getPrice(num? price) {
    var value = price ?? 0;
    final valueFormatter = NumberFormat.currency(name: order.currencyCode!);
    if (valueFormatter.decimalDigits != null) {
      value = value / pow(10, valueFormatter.decimalDigits!).roundToDouble();
    }
    return '${order.currency?.symbolNative ?? ''} ${valueFormatter.format(value).split(valueFormatter.currencySymbol)[1]}';
  }
}
