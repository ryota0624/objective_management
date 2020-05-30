// 目標を表します。
import 'package:objective_management/model/errors.dart';
import 'package:objective_management/model/step.dart';
import 'package:objective_management/model/description.dart';

import 'evaluation.dart';

class ObjectiveID {
  final String _value;

  ObjectiveID(this._value);

  @override
  String toString() => _value;

  factory ObjectiveID.generate() {
    final randomStr = ''; // TODO ランダムにする
    return ObjectiveID(randomStr);
  }
}

class Objective extends Evaluable<Objective> {
  final ObjectiveID id;
  final Steps steps;
  final Goal goal;
  final Period period;
  final Evaluation _evaluation;
  final Result result;
  final ObjectiveDescription description;

  Objective withSteps(Steps steps) =>
      Objective._(id, steps, goal, period, _evaluation, result, description);

  Objective withResult(Result result) {
    if (!steps.isAllFinished()) {
      throw PreconditionError('all steps should finished');
    }
    return Objective._(id, steps, goal, period, _evaluation, result, description);
  }

  Objective._(
    this.id,
    this.steps,
    this.goal,
    this.period,
    this._evaluation,
    this.result,
    this.description,
  );

  factory Objective.create(
    ObjectiveID id,
    Steps steps,
    Goal goal,
    Period period,
    ObjectiveDescription description,
  ) {
    return Objective._(
      id,
      steps,
      goal,
      period,
      Evaluation.empty,
      Result.empty,
      description,
    );
  }

  @override
  Objective evaluate(Evaluation e) {
    return Objective._(id, steps, goal, period, e, result, description);
  }

  @override
  Evaluation evaluation() => _evaluation;
}

// 目標の開始から終了までの期間です。
class Period {
  DateTime start;
  DateTime end;
}

// 目標のゴールを表します。
class Goal {
  final GoalDescription description;

  Goal(this.description);
}

// 目標への結果を表します。
class Result extends Evaluable<Result> {
  Result._(this.description, this._evaluation);

  final ResultDescription description;

  bool isEmpty() => false;
  static Result empty = EmptyResult();

  final Evaluation _evaluation;

  @override
  Result evaluate(Evaluation e) => Result._(description, e);

  @override
  Evaluation evaluation() => _evaluation;
}

class EmptyResult extends Result {
  EmptyResult() : super._(ResultDescription(''), Evaluation.empty);

  @override
  bool isEmpty() => true;
}
