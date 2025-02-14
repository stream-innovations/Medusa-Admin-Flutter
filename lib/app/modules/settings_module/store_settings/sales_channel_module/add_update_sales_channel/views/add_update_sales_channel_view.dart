import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:medusa_admin/app/data/models/store/index.dart';
import 'package:medusa_admin/app/modules/components/adaptive_back_button.dart';
import 'package:medusa_admin/app/modules/components/custom_text_field.dart';
import 'package:medusa_admin/app/modules/components/header_card.dart';
import 'package:medusa_admin/core/utils/extension.dart';

import '../../../../../../data/repository/sales_channel/sales_channel_repo.dart';
import '../controllers/add_update_sales_channel_controller.dart';

@RoutePage()
class AddUpdateSalesChannelView extends StatelessWidget {
  const AddUpdateSalesChannelView( {super.key,this.salesChannel});
  final SalesChannel? salesChannel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddUpdateSalesChannelController>(
      init: AddUpdateSalesChannelController(
          salesChannelRepo: SalesChannelRepo(), salesChannel: salesChannel),
      builder: (controller) {
        final bottomViewPadding = MediaQuery.of(context).viewPadding.bottom;
        return GestureDetector(
          onTap: () => context.unfocus(),
          child: Scaffold(
            appBar: AppBar(
              leading: const AdaptiveBackButton(),
              title: controller.updateMode
                  ? const Text('Update sales channel')
                  : const Text('Create new sales channel'),
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18.0),
              padding: EdgeInsets.only(
                  bottom: bottomViewPadding, top: bottomViewPadding / 2),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: controller.disabled ? Colors.blueGrey : null
                ),
                onPressed: () async => controller.updateMode
                    ? await controller.updateChannel(context)
                    : await controller.createChannel(context),
                child: controller.updateMode
                    ? const Text('Update Channel',
                        style: TextStyle(color: Colors.white))
                    : controller.disabled
                        ? const Text('Save as draft',
                            style: TextStyle(color: Colors.white))
                        : const Text('Publish Channel',
                            style: TextStyle(color: Colors.white)),
              ),
            ),
            body: SafeArea(
              child: Form(
                key: controller.formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  children: [
                    HeaderCard(
                      initiallyExpanded: true,
                      title: Text('General info'),
                      child: Column(
                        children: [
                          LabeledTextField(
                            label: 'Title',
                            controller: controller.titleCtrl,
                            hintText:
                            'Website, App, Amazon, physical store POS, facebook, product feed',
                            required: !controller.updateMode,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Field is required';
                              }

                              return null;
                            },
                          ),
                          LabeledTextField(
                            label: 'Description',
                            controller: controller.descriptionCtrl,
                            hintText:
                            'Available products at our website, app ...',
                            textInputAction: TextInputAction.done,
                          ),
                          CheckboxListTile(
                            value: controller.disabled,
                            onChanged: (val) {
                              if (val == null) return;
                              controller.disabled = val;
                              controller.update();
                            },
                            title: const Text('Disabled'),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
