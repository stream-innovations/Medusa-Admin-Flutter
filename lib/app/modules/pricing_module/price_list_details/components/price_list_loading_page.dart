import 'package:flutter/material.dart';
import 'package:medusa_admin/app/data/models/store/price_list.dart';
import 'package:medusa_admin/core/utils/colors.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'price_list_details_tile.dart';

class PriceListLoadingPage extends StatelessWidget {
  const PriceListLoadingPage(this.priceList,{super.key});
  final PriceList priceList;
  @override
  Widget build(BuildContext context) {
    final manatee = ColorManager.manatee;
    final smallTextStyle = context.bodySmall;
    final mediumTextStyle = context.bodyMedium;
    return  Column(
      children: [
        PriceListDetailsTile(priceList, shimmer: true),
        Skeletonizer(
          enabled: true,
          child: Column(
            children: [
              ListTile(
                leading: Container(width: 45,color: ColorManager.manatee,child: const Icon(Icons.image_not_supported),),
                title: const Text('Medusa Product'),
                subtitle: Text('collection',
                    style:
                    smallTextStyle?.copyWith(color: manatee))
                ,
                trailing: Text(
                    'Variants: N/A',
                    style: mediumTextStyle),
              ),
              ListTile(
                leading: Container(width: 45,color: ColorManager.manatee,child: const Icon(Icons.image_not_supported),),
                title: const Text('Medusa Product'),
                subtitle: Text('collection',
                    style:
                    smallTextStyle?.copyWith(color: manatee))
                ,
                trailing: Text(
                    'Variants: N/A',
                    style: mediumTextStyle),
              ),
              ListTile(
                leading: Container(width: 45,color: ColorManager.manatee,child: const Icon(Icons.image_not_supported),),
                title: const Text('Medusa Product'),
                subtitle: Text('collection',
                    style:
                    smallTextStyle?.copyWith(color: manatee))
                ,
                trailing: Text(
                    'Variants: N/A',
                    style: mediumTextStyle),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
