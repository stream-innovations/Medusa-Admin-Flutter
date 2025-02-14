import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:medusa_admin/app/data/models/store/publishable_api_key.dart';
import 'package:medusa_admin/app/modules/components/adaptive_back_button.dart';
import 'package:medusa_admin/app/modules/components/adaptive_button.dart';
import 'package:medusa_admin/app/modules/components/custom_text_field.dart';
import 'package:medusa_admin/app/modules/components/header_card.dart';
import 'package:medusa_admin/core/utils/colors.dart';
import 'package:medusa_admin/core/utils/extension.dart';

import '../../../../../../data/repository/publishable_api_key/publishable_api_key_repo.dart';
import '../controllers/add_update_api_key_controller.dart';

@RoutePage()
class AddUpdateApiKeyView extends StatelessWidget {
  const AddUpdateApiKeyView({super.key, this.publishableApiKey});
  final PublishableApiKey? publishableApiKey;

  @override
  Widget build(BuildContext context) {
    final lightWhite = ColorManager.manatee;
    final smallTextStyle = context.bodySmall;
    const space = Gap(12);
    return GetBuilder<AddUpdateApiKeyController>(
        init: AddUpdateApiKeyController(
            publishableApiKeyRepo: PublishableApiKeyRepo(), publishableApiKey: publishableApiKey),
        builder: (controller) {
          return GestureDetector(
            onTap: () => context.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                leading: const AdaptiveBackButton(),
                title: controller.updateMode
                    ? const Text('Update Api Key')
                    : const Text('Create New Api Key'),
                actions: [
                  AdaptiveButton(
                    onPressed: () async => await controller.publish(context),
                    child: const Text('Publish'),
                  ),
                ],
              ),
              body: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  children: [
                    Form(
                      key: controller.keyForm,
                      child: HeaderCard(
                        title: const Text('General Information'),
                        initiallyExpanded: true,
                       child: Column(
                         children: [
                           Text(
                             'Create and manage API keys. Right now this is only related to sales channels.',
                             style: smallTextStyle?.copyWith(color: lightWhite),
                           ),
                           space,
                           LabeledTextField(
                             label: 'Title',
                             controller: controller.titleCtrl,
                             hintText: 'Name your key',
                             required: true,
                             validator: (val) {
                               if (val == null ||
                                   val.removeAllWhitespace.isEmpty) {
                                 return 'Field is required';
                               }
                               return null;
                             },
                           )
                         ],
                       ),
                      ),
                    ),
                    space,
                    HeaderCard(
                      title: const Text('Sales channels'),
                      child: Column(
                        children: [
                          Text(
                            'Connect as many sales channels to your API key as you need.',
                            style: smallTextStyle?.copyWith(color: lightWhite),
                          ),
                          space,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
