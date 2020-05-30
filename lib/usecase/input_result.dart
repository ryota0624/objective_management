import 'package:objective_management/model/evaluation.dart';
import 'package:objective_management/model/objective.dart';
import 'package:objective_management/model/repository/objective.dart';
import 'package:objective_management/model/step.dart';
import 'package:objective_management/usecase/application_time.dart';


class InputResultInput {
  final ObjectiveID objectiveID;
  final Result result;

  InputResultInput(this.objectiveID, this.result);
}

// TODO もっといい名前あるだろう
class InputResult {
  final ObjectiveRepository objectiveRepository;

  InputResult(this.objectiveRepository);

  void execute(InputResultInput input) {
    final objective = objectiveRepository.get(input.objectiveID);
    final updated = objective.withResult(input.result);
    objectiveRepository.store(updated);
  }
}
