import 'package:objective_management/model/evaluation.dart';
import 'package:objective_management/model/objective.dart';
import 'package:objective_management/model/repository/objective.dart';
import 'package:objective_management/model/step.dart';
import 'package:objective_management/usecase/application_time.dart';

abstract class EvaluateTarget {
  Objective evaluate(Objective objective, Evaluation evaluation);
}

class EvaluateTargetObjective extends EvaluateTarget {
  @override
  Objective evaluate(Objective objective, Evaluation evaluation) =>
      objective.evaluate(evaluation);
}

class EvaluateTargetResult extends EvaluateTarget {
  @override
  Objective evaluate(Objective objective, Evaluation evaluation) =>
      objective.withResult(objective.result.evaluate(evaluation));
}

class EvaluateTargetStep extends EvaluateTarget {
  final StepOrder order;

  EvaluateTargetStep(this.order);

  @override
  Objective evaluate(Objective objective, Evaluation evaluation) {
    final evaluated = objective.steps.getByOrder(order).evaluate(evaluation);
    return objective.withSteps(objective.steps.updateStep(evaluated));
  }
}

class EvaluateInput {
  final ObjectiveID objectiveID;
  final EvaluateTarget target;
  final Evaluation evaluation;

  EvaluateInput(this.objectiveID, this.target, this.evaluation);
}

abstract class Evaluate with ApplicationTime {
  final ObjectiveRepository objectiveRepository;

  Evaluate(this.objectiveRepository);

  void execute(EvaluateInput input) {
    final objective = objectiveRepository.get(input.objectiveID);
    final updated = input.target.evaluate(objective, input.evaluation);
    objectiveRepository.store(updated);
  }
}
