import 'package:objective_management/model/id.dart';
import 'package:objective_management/model/repository/objective.dart';
import 'package:objective_management/model/step.dart';
import 'package:objective_management/usecase/application_time.dart';

enum ProgressType { completed, skip }

extension on ProgressType {
  Steps applyProgress(DateTime now, Steps steps) {
    switch (this) {
      case ProgressType.completed:
        return steps.completeInProgressStep(now);
      case ProgressType.skip:
        return steps.skipInProgressStep(now);
      default:
        throw UnimplementedError();
    }
  }
}

class ApplyProgressObjectiveInput {
  final ObjectiveID objectiveID;
  final ProgressType progressType;

  ApplyProgressObjectiveInput(this.objectiveID, this.progressType);
}

class ApplyProgressObjective  {
  final ObjectiveRepository objectiveRepository;
  final ApplicationTime applicationTime;

  ApplyProgressObjective(this.objectiveRepository, this.applicationTime);

  void execute(ApplyProgressObjectiveInput input) {
    final objective = objectiveRepository.get(input.objectiveID);
    objective.withSteps(input.progressType.applyProgress(applicationTime.now(), objective.steps));
    objectiveRepository.store(objective);
  }
}
