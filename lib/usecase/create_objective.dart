import 'package:objective_management/model/objective.dart';
import 'package:objective_management/model/repository/objective.dart';
import 'package:objective_management/model/step.dart';
import 'package:objective_management/model/description.dart';

class CreateObjectiveInput {
  final List<StepDescription> steps;
  final GoalDescription goal;
  final Period period;
  final ObjectiveDescription description;

  CreateObjectiveInput(this.steps, this.goal, this.period, this.description);
}
class CreateObjective {
  final ObjectiveRepository objectiveRepository;

  CreateObjective(this.objectiveRepository);

  void execute(CreateObjectiveInput input) {
    final steps = Steps.fromDescriptionList(input.steps);
    final goal = Goal(input.goal);
    final id = ObjectiveID.generate();
    final objective = Objective.create(id, steps, goal, input.period, input.description);
    objectiveRepository.store(objective);
  }
}