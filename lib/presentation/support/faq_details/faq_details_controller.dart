import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/data/models/faq_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';

class FaqDetailsController extends GetxController with StateMixin {
  FaqDetailsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    faq = Get.arguments as Faq;
    loadFaqsSteps();
    super.onInit();
  }

  Future<void> loadFaqsSteps() async {
    change(null, status: RxStatus.loading());
    final params = FirebaseParamsRequest(
      collection: 'faq/${faq!.id}/steps',
      parser: FaqStep.fromJson,
      orderBy: FirebaseOrderByParam('order'),
    );
    final result =
        await GeneralUsecase(apiRepository).readData<FaqStep>(params);
    result.fold(
      (failure) {
        change(
          null,
          status: RxStatus.error(getMessageFromFailure(failure).toString()),
        );
      },
      (r) {
        faqSteps.value = r;
        change(null, status: RxStatus.success());
      },
    );
  }

  Faq? faq;
  RxList<FaqStep> faqSteps = <FaqStep>[].obs;
}
