import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:medusa_admin/app/data/models/req/user_shipping_option_req.dart';
import 'package:medusa_admin/app/data/models/store/index.dart';
import 'package:medusa_admin/app/data/repository/regions/regions_repo.dart';
import 'package:medusa_admin/app/data/repository/shipping_options/shipping_options_repo.dart';
import 'package:medusa_admin/app/data/repository/shipping_profile/shipping_profile_repo.dart';
import 'package:medusa_admin/app/modules/components/easy_loading.dart';
import 'package:medusa_admin/app/modules/settings_module/store_settings/regions_module/region_details/controllers/region_details_controller.dart';
import 'package:medusa_admin/core/utils/extension.dart';
import 'package:medusa_admin/core/utils/extensions/snack_bar_extension.dart';
import '../../../../../../data/models/store/fulfillment_option.dart';

class AddUpdateShippingOptionController extends GetxController {
  AddUpdateShippingOptionController(
      {required this.shippingProfileRepo, required this.regionsRepo, required this.shippingOptionsRepo, required this.addUpdateShippingOptionReq});

  final ShippingProfileRepo shippingProfileRepo;
  final ShippingOptionsRepo shippingOptionsRepo;
  final RegionsRepo regionsRepo;
  List<FulfillmentOption>? fulfillmentOptions;
  List<ShippingProfile>? shippingProfiles;
  final AddUpdateShippingOptionReq addUpdateShippingOptionReq ;
  bool get updateMode => addUpdateShippingOptionReq.shippingOption != null;
  bool visibleInStore = false;
  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final minSubtotalCtrl = TextEditingController();
  final maxSubtotalCtrl = TextEditingController();
  ShippingOptionPriceType? selectedPriceType;
  ShippingProfile? selectedShippingProfile;
  FulfillmentOption? selectedFulfillmentOption;
  final formKey = GlobalKey<FormState>();
  @override
  Future<void> onInit() async {
    if (!updateMode) {
      await loadFulfillmentOptions();
      await loadShippingProfile();
    }
    if (updateMode) {
      loadShippingOption();
    }
    super.onInit();
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    priceCtrl.dispose();
    minSubtotalCtrl.dispose();
    maxSubtotalCtrl.dispose();
    super.onClose();
  }

  Future<void> createShippingOption(BuildContext context) async {
    if (fulfillmentOptions == null ||
        shippingProfiles == null ||
        !formKey.currentState!.validate() ||
        selectedFulfillmentOption == null) {
      return;
    }
    if (!formKey.currentState!.validate()) {
      return;
    }
    loading();
    final price = int.tryParse(priceCtrl.text.replaceAll('.', '').replaceAll(',', ''));
    final minSubtotal = int.tryParse(minSubtotalCtrl.text.replaceAll('.', '').replaceAll(',', ''));
    final maxSubtotal = int.tryParse(maxSubtotalCtrl.text.replaceAll('.', '').replaceAll(',', ''));
    List<ShippingOptionRequirement>? requirements = [
      if (minSubtotal != null) ShippingOptionRequirement(type: RequirementType.minSubtotal, amount: minSubtotal),
      if (maxSubtotal != null) ShippingOptionRequirement(type: RequirementType.maxSubtotal, amount: maxSubtotal),
    ];
    context.unfocus();
    final result = await shippingOptionsRepo.create(
      userCreateShippingOptionReq: UserCreateShippingOptionReq(
        shippingOption: ShippingOption(
          name: titleCtrl.text,
          regionId: addUpdateShippingOptionReq.region.id!,
          profileId: null,
          isReturn: addUpdateShippingOptionReq.returnShippingOption,
          data: {},
          providerId: selectedFulfillmentOption!.providerId,
          priceType: selectedPriceType,
          amount: selectedPriceType == ShippingOptionPriceType.flatRate ? price : null,
          requirements: requirements.isNotEmpty ? requirements : null,
        ),
      ),
    );

    result.when((success) async {
      if (addUpdateShippingOptionReq.returnShippingOption) {
        RegionDetailsController.instance.updateReturnOptions();
      } else {
        RegionDetailsController.instance.updateOptions();
      }
      dismissLoading();
      context.popRoute();
    }, (error) {
      context.showSnackBar('Error creating shipping option, ${error.toSnackBarString()}');
      dismissLoading();
    });
  }

  Future<void> updateShippingOption(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    loading();
    context.unfocus();
    final price = int.tryParse(priceCtrl.text.replaceAll('.', '').replaceAll(',', ''));
    final minSubtotal = int.tryParse(minSubtotalCtrl.text.replaceAll('.', '').replaceAll(',', ''));
    final maxSubtotal = int.tryParse(maxSubtotalCtrl.text.replaceAll('.', '').replaceAll(',', ''));
    List<ShippingOptionRequirement>? requirements = [
      if (minSubtotal != null) ShippingOptionRequirement(type: RequirementType.minSubtotal, amount: minSubtotal),
      if (maxSubtotal != null) ShippingOptionRequirement(type: RequirementType.maxSubtotal, amount: maxSubtotal),
    ];
    final shippingOption = addUpdateShippingOptionReq.shippingOption!;
    final result = await shippingOptionsRepo.update(
      id: shippingOption.id!,
      userUpdateReturnReasonReq: UserUpdateShippingOptionReq(
        shippingOption: ShippingOption(
          name: shippingOption.name == titleCtrl.text ? null : titleCtrl.text,
          regionId: null,
          profileId: null,
          providerId:null,
          priceType: null,
          amount: selectedPriceType == ShippingOptionPriceType.flatRate ? price : null,
          requirements: requirements.isNotEmpty ? requirements : null,
        ),
      ),
    );
    result.when((success) async {
      if (addUpdateShippingOptionReq.returnShippingOption) {
        RegionDetailsController.instance.updateReturnOptions();
      } else {
        RegionDetailsController.instance.updateOptions();
      }
      context.popRoute();
      dismissLoading();
    }, (error) {
      context.showSnackBar('Error updating shipping option, ${error.toSnackBarString()}');
      dismissLoading();
    });
  }

  Future<void> loadFulfillmentOptions() async {
    final result = await regionsRepo.retrieveFulfillmentOptions(id: addUpdateShippingOptionReq.region.id!);
    result.when(
      (success) {
        fulfillmentOptions = success.fulfillmentOptions;
        update();
      },
      (error) {
        debugPrint(error.toString());
        EasyLoading.showError('Error loading fulfillment options');
      },
    );
  }

  Future<void> loadShippingProfile() async {
    final result = await shippingProfileRepo.retrieveAll();
    result.when((success) {
      shippingProfiles = success.shippingProfiles;
      update();
    }, (error) {
      debugPrint(error.toString());
      EasyLoading.showError('Error loading shipping option');
    });
  }

  void loadShippingOption() {
    final shippingOption = addUpdateShippingOptionReq.shippingOption!;
    if(shippingOption.adminOnly != null){
      visibleInStore = !shippingOption.adminOnly!;
    } else {
      visibleInStore = true;
    }

    titleCtrl.text = shippingOption.name ?? '';
    selectedPriceType = shippingOption.priceType;
    if (shippingOption.amount != null) {
      priceCtrl.text = shippingOption.amount.formatAsPrice(addUpdateShippingOptionReq.region.currencyCode, includeSymbol: false);
    }
    if (shippingOption.requirements?.isNotEmpty ?? false) {
      for (var element in shippingOption.requirements!) {
        if (element.type == RequirementType.minSubtotal) {
          minSubtotalCtrl.text = element.amount.formatAsPrice( addUpdateShippingOptionReq.region.currencyCode, includeSymbol: false);
        } else {
          maxSubtotalCtrl.text = element.amount.formatAsPrice( addUpdateShippingOptionReq.region.currencyCode, includeSymbol: false);
        }
      }
    }
    update();
  }
}

class AddUpdateShippingOptionReq {
  AddUpdateShippingOptionReq({
    required this.region,
    this.shippingOption,
    this.returnShippingOption = false,
  });
  final Region region;
  final ShippingOption? shippingOption;
  final bool returnShippingOption;
}
