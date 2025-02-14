import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:medusa_admin/app/data/models/store/index.dart';
import 'package:medusa_admin/app/modules/auth_module/sign_in/components/sign_in_text_fields.dart';
import 'package:medusa_admin/app/modules/components/adaptive_back_button.dart';
import 'package:medusa_admin/app/modules/components/adaptive_button.dart';
import 'package:medusa_admin/app/modules/components/header_card.dart';
import 'package:medusa_admin/app/modules/orders_module/order_details/components/index.dart';
import 'package:medusa_admin/app/modules/orders_module/order_details/controllers/order_details_controller.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/route/app_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../../core/utils/colors.dart';
import '../../../components/countries/components/countries.dart';

class OrderCustomer extends GetView<OrderDetailsController> {
  const OrderCustomer(this.order, {super.key, this.onExpansionChanged});
  final Order order;
  final void Function(bool)? onExpansionChanged;
  @override
  Widget build(BuildContext context) {
    final manatee = ColorManager.manatee;
    final mediumTextStyle = context.bodyMedium;
    final largeTextStyle = context.bodyLarge;
    String getCountry() {
      String countryName = '';
      final countryCode = order.shippingAddress?.countryCode;
      if (countryCode != null) {
        final country = countries.firstWhere((element) => element.iso2 == countryCode,
            orElse: () => const Country(iso2: '', iso3: '', numCode: 0, name: '', displayName: ''));
        countryName = country.name ?? '';
      }
      return countryName.capitalize ?? countryName;
    }

    return HeaderCard(
      key: controller.customerKey,
      onExpansionChanged: onExpansionChanged,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text('Customer'),
      trailing: IconButton(
          onPressed: () async {
            await showModalActionSheet<int>(context: context, actions: <SheetAction<int>>[
              const SheetAction(label: 'Go to Customer', icon: Icons.person, key: 0),
              const SheetAction(label: 'Transfer Ownership', key: 1),
              const SheetAction(label: 'Edit Shipping Address', key: 2),
              const SheetAction(label: 'Edit Billing Address', key: 3),
              const SheetAction(label: 'Edit Email Address', key: 4),
            ]).then((value) async {
              if (value == null) return;
              switch (value) {
                case 0:
                  await context.pushRoute(CustomerDetailsRoute(customerId: order.customerId!));
                  break;
                case 1:
                  await context.pushRoute(TransferOrderRoute(order: order));
                  break;
                case 2:
                  final result = await showBarModalBottomSheet(
                    context: context,
                    overlayStyle: context.theme.appBarTheme.systemOverlayStyle,
                    builder: (context) => EditAddress(
                      shippingAddress: order.shippingAddress!,
                      countries: order.region?.countries ?? <Country>[],
                      appbarTitle: 'Shipping Address',
                      context: context,
                    ),
                  );
                  if (result is Address) {
                    await controller.updateShippingAddress(result);
                  }
                  break;
                case 3:
                  final result = await showBarModalBottomSheet(
                    context: context,
                    overlayStyle: context.theme.appBarTheme.systemOverlayStyle,
                    builder: (context) => EditAddress(
                      shippingAddress: order.billingAddress!,
                      countries: order.region?.countries ?? <Country>[],
                      appbarTitle: 'Billing Address',
                      context: context,
                    ),
                  );
                  if (result is Address) {
                    await controller.updateBillingAddress(result);
                  }
                  break;
                case 4:
                  final result = await showBarModalBottomSheet(
                      context: context,
                      overlayStyle: context.theme.appBarTheme.systemOverlayStyle,
                      builder: (context) {
                        return EmailUpdateView(currentEmail: order.email);
                      });
                  if (result is String) {
                    await controller.updateEmail(result);
                  }
              }
            });
          },
          icon: const Icon(Icons.more_horiz)),
      childPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: ColorManager.getAvatarColor(order.email),
                        child: Text(order.customer?.firstName?[0].toUpperCase() ?? order.email![0].toUpperCase(),
                            style: largeTextStyle?.copyWith(color: Colors.white))),
                    const SizedBox(width: 14.0),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${order.customer?.firstName ?? ''} ${order.customer?.lastName ?? ''}',
                              style: mediumTextStyle),
                          Text('${order.shippingAddress?.city ?? ''}, ${getCountry()}',
                              style: mediumTextStyle?.copyWith(color: manatee))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.email!, style: context.bodyMedium),
                    if (order.billingAddress != null && order.billingAddress!.phone != null)
                      Text(order.billingAddress!.phone.toString(), style: context.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shipping', style: mediumTextStyle!.copyWith(color: manatee)),
                    const SizedBox(height: 5.0),
                    Text('${order.shippingAddress?.address1 ?? ''} ${order.shippingAddress?.address2 ?? ''}',
                        style: context.bodyMedium),
                    Text(
                        '${order.shippingAddress?.postalCode ?? ''} ${order.shippingAddress?.province ?? ''} ${order.shippingAddress?.countryCode ?? ''}',
                        style: context.bodyMedium),
                  ],
                ),
                const VerticalDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Billing', style: mediumTextStyle.copyWith(color: manatee)),
                    const SizedBox(height: 5.0),
                    Text('${order.billingAddress?.address1 ?? ''} ${order.billingAddress?.address2 ?? ''}',
                        style: context.bodyMedium),
                    Text(
                        '${order.billingAddress?.postalCode ?? ''} ${order.billingAddress?.province ?? ''} ${order.billingAddress?.countryCode ?? ''}',
                        style: context.bodyMedium),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmailUpdateView extends StatefulWidget {
  const EmailUpdateView({super.key, this.currentEmail});
  final String? currentEmail;
  @override
  State<EmailUpdateView> createState() => _EmailUpdateViewState();
}

class _EmailUpdateViewState extends State<EmailUpdateView> {
  final emailCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailCtrl.text = widget.currentEmail ?? '';
    super.initState();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = context.bottomViewPadding == 0 ? 20.0 : context.bottomViewPadding;
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              leading: const AdaptiveBackButton(),
              title: const Text('Update Email Address'),
              actions: [
                AdaptiveButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      if (emailCtrl.text == widget.currentEmail) {
                        context.popRoute();
                        return;
                      }
                      context.popRoute(emailCtrl.text);
                    },
                    child: const Text('Save'))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 10, 8, context.bottomViewInsetPadding),
              child: EmailTextField(
                controller: emailCtrl,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email can not be empty';
                  }
                  if (!value.isEmail) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
            ),
            Gap(bottomPadding),
          ],
        ),
      ),
    );
  }
}
