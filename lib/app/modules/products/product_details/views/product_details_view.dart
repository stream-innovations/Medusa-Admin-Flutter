import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';
import 'package:medusa_admin/app/data/models/store/product.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final smallTextStyle = Theme.of(context).textTheme.titleSmall;
    const space = SizedBox(height: 12.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        actions: [
          if (controller.state != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(controller.state!.status.name.capitalize ?? controller.state!.status.name,
                  style: smallTextStyle),
            ),
        ],
      ),
      body: SafeArea(
        child: controller.obx(
          (product) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            children: [
              buildProductOverview(context, product),
              space,
              buildVariantsExpansionTile(context, product),
              space,
              buildAttributesExpansionTile(context, product),
              space,
              buildThumbnailExpansionTile(context, product),
              space,
              buildImagesExpansionTile(context, product),
            ],
          ),
          onError: (e) => const Center(child: Text('Error loading product')),
          onLoading: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }

  ExpansionTile buildImagesExpansionTile(BuildContext context, Product? product) {
    const space = SizedBox(height: 12.0);
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text('Images', style: Theme.of(context).textTheme.bodyLarge),
      trailing: GetPlatform.isAndroid
          ? TextButton(onPressed: () {}, child: const Text('Edit'))
          : CupertinoButton(onPressed: () {}, padding: EdgeInsets.zero, child: const Text('Edit')),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      children: [
        if (product!.images != null)
          Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: product.images!
                  .map((e) => SizedBox(height: 120, width: 90, child: CachedNetworkImage(imageUrl: e.url!)))
                  .toList()),
        space,
      ],
    );
  }

  ExpansionTile buildThumbnailExpansionTile(BuildContext context, Product? product) {
    const space = SizedBox(height: 12.0);
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text('Thumbnail', style: Theme.of(context).textTheme.bodyLarge),
      trailing: GetPlatform.isAndroid
          ? TextButton(onPressed: () {}, child: const Text('Edit'))
          : CupertinoButton(onPressed: () {}, padding: EdgeInsets.zero, child: const Text('Edit')),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      children: [
        if (product!.thumbnail != null) SizedBox(height: 120, child: CachedNetworkImage(imageUrl: product.thumbnail!)),
        space,
      ],
    );
  }

  ExpansionTile buildAttributesExpansionTile(BuildContext context, Product? product) {
    final mediumTextStyle = Theme.of(context).textTheme.titleMedium;
    const space = SizedBox(height: 12.0);
    Color lightWhite = Get.isDarkMode ? Colors.white54 : Colors.black54;
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text('Attributes', style: Theme.of(context).textTheme.bodyLarge),
      trailing: GetPlatform.isAndroid
          ? TextButton(onPressed: () {}, child: const Text('Edit'))
          : CupertinoButton(onPressed: () {}, padding: EdgeInsets.zero, child: const Text('Edit')),
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dimensions', style: mediumTextStyle),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Height', style: mediumTextStyle!.copyWith(color: lightWhite))),
                Expanded(
                    flex: 2,
                    child: Text(product!.height?.toString() ?? '-',
                        style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
              ],
            ),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Width', style: mediumTextStyle.copyWith(color: lightWhite))),
                Expanded(
                    flex: 2,
                    child: Text(product.width?.toString() ?? '-',
                        style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
              ],
            ),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Length', style: mediumTextStyle.copyWith(color: lightWhite))),
                Expanded(
                    flex: 2,
                    child: Text(product.length?.toString() ?? '-',
                        style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
              ],
            ),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Weight', style: mediumTextStyle.copyWith(color: lightWhite))),
                Expanded(
                    flex: 2,
                    child: Text(product.weight?.toString() ?? '-',
                        style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
              ],
            ),
            space,
            space,
            Text('Customs', style: mediumTextStyle),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('MID Code', style: mediumTextStyle.copyWith(color: lightWhite))),
                Expanded(
                    flex: 2,
                    child: Text(product.midCode?.toString() ?? '-',
                        style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
              ],
            ),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('HS Code', style: mediumTextStyle.copyWith(color: lightWhite))),
                Expanded(
                    flex: 2,
                    child: Text(product.hsCode?.toString() ?? '-',
                        style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
              ],
            ),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Country of origin', style: mediumTextStyle.copyWith(color: lightWhite))),
                Expanded(
                    flex: 2,
                    child: Text(product.originCountry?.toString() ?? '-',
                        style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
              ],
            ),
            space,
          ],
        )
      ],
    );
  }

  ExpansionTile buildVariantsExpansionTile(BuildContext context, Product? product) {
    final smallTextStyle = Theme.of(context).textTheme.titleSmall;
    final mediumTextStyle = Theme.of(context).textTheme.titleMedium;
    const space = SizedBox(height: 12.0);
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text('Variants', style: Theme.of(context).textTheme.bodyLarge),
      trailing: IconButton(
          onPressed: () async {
            final result = await showModalActionSheet(context: context, actions: <SheetAction>[
              const SheetAction(label: 'Add Variants'),
              const SheetAction(label: 'Edit Variants'),
              const SheetAction(label: 'Edit Options'),
            ]);
          },
          icon: const Icon(Icons.more_horiz)),
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product!.options != null)
              ListView.builder(
                shrinkWrap: true,
                itemCount: product.options!.length,
                itemBuilder: (context, index) {
                  final option = product.options![index];

                  // print(option.);
                  return Text('');
                },
              ),
            // Do not remove the row
            Row(
              children: [
                Text(product.options?[0].title ?? 'Sized', style: mediumTextStyle),
              ],
            ),
            if (product.variants != null)
              Wrap(
                spacing: 8.0,
                children:
                    product.variants!.map((e) => Chip(label: Text(e.title ?? '', style: smallTextStyle))).toList(),
              ),
          ],
        ),
        space,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Product Variants (${product.variants?.length ?? ''})', style: mediumTextStyle),
              ],
            ),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Center(child: Text('Title', style: smallTextStyle))),
                Expanded(child: Center(child: Text('SKU', style: smallTextStyle))),
                Expanded(child: Center(child: Text('EAN', style: smallTextStyle))),
                Expanded(
                  child: Text('Inventory', style: smallTextStyle),
                )
              ],
            ),
            const Divider(),
            if (product.variants != null)
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: product.variants!.length,
                  itemBuilder: (context, index) {
                    final variant = product.variants![index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Center(child: Text(variant.title ?? '-', style: smallTextStyle))),
                        Expanded(child: Center(child: Text(variant.sku ?? '-', style: smallTextStyle))),
                        Expanded(child: Center(child: Text(variant.ean ?? '-', style: smallTextStyle))),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(child: Text(variant.inventoryQuantity?.toString() ?? '-', style: smallTextStyle)),
                              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
                            ],
                          ),
                        )
                      ],
                    );
                  })
          ],
        ),
      ],
    );
  }

  Container buildProductOverview(BuildContext context, Product? product) {
    final mediumTextStyle = Theme.of(context).textTheme.titleMedium;
    const space = SizedBox(height: 12.0);
    Color lightWhite = Get.isDarkMode ? Colors.white54 : Colors.black54;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        color: Theme.of(context).expansionTileTheme.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(product!.title ?? '')),
              IconButton(
                onPressed: () async {
                  final result = await showModalActionSheet(context: context, actions: <SheetAction>[
                    const SheetAction(label: 'Edit General Information'),
                    const SheetAction(label: 'Edit Sales Channels'),
                    const SheetAction(label: 'Delete', isDestructiveAction: true),
                  ]);
                },
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          space,
          Text(product.description ?? '', style: mediumTextStyle!.copyWith(color: lightWhite)),
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Details', style: mediumTextStyle),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Subtitle', style: mediumTextStyle.copyWith(color: lightWhite))),
                  Expanded(
                      flex: 2,
                      child: Text(product.subtitle ?? '-',
                          style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Handle', style: mediumTextStyle.copyWith(color: lightWhite))),
                  Expanded(
                      flex: 2,
                      child: Text(product.handle ?? '-',
                          style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Type', style: mediumTextStyle.copyWith(color: lightWhite))),
                  Expanded(
                      flex: 2,
                      child: Text(product.type?.value ?? '-',
                          style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Collection', style: mediumTextStyle.copyWith(color: lightWhite))),
                  Expanded(
                      flex: 2,
                      child: Text(product.collection?.title ?? '-',
                          style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
                ],
              ),
              space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Discountable', style: mediumTextStyle.copyWith(color: lightWhite))),
                  Expanded(
                      flex: 2,
                      child: Text(product.discountable.toString().capitalize ?? product.discountable.toString(),
                          style: mediumTextStyle.copyWith(color: lightWhite), textAlign: TextAlign.right)),
                ],
              ),
              space,
              space,
              Text('Sales Channel', style: mediumTextStyle),
              space,
            ],
          )
        ],
      ),
    );
  }
}
