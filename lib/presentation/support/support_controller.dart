import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/data/models/faq_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';

class SupportController extends GetxController with StateMixin {
  SupportController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadFaqs();
    super.onInit();
  }

  Future<void> loadFaqs() async {
    change(null, status: RxStatus.loading());
    final params = FirebaseParamsRequest(
      collection: 'faq',
      parser: Faq.fromJson,
    );
    final result = await GeneralUsecase(apiRepository).readData<Faq>(params);
    result.fold(
      (failure) {
        change(
          null,
          status: RxStatus.error(getMessageFromFailure(failure).toString()),
        );
      },
      (r) {
        faqs.value = r;
        change(null, status: RxStatus.success());
      },
    );
  }

  RxList<Faq> faqs = <Faq>[].obs;
}
