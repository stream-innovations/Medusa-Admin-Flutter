import 'package:flutter/material.dart';
import 'package:medusa_admin/app/data/models/store/product.dart';
import 'package:medusa_admin/app/modules/products_module/products/components/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsLoadingPage extends StatelessWidget {
  const ProductsLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const product =
        Product(title: 'Medusa Js Product', status: ProductStatus.published);
    return Column(
      children: List.generate(
        20,
        (index) => index.isEven
            ? const Skeletonizer(
                enabled: true, child: ProductListTile(product: product))
            : const Divider(height: 0, indent: 16),
      ),
    );
  }
}
