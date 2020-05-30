// 目標を表します。
import 'package:objective_management/model/step.dart';

import 'evaluation.dart';

class Objective extends Evaluable<Objective> {
  final Steps steps;
  final Goal goal;
  final Period period;
  final Evaluation _evaluation;
  final Result result;

  Objective._(
      this.steps, this.goal, this.period, this._evaluation, this.result);

  factory Objective.create(
    Steps steps,
    Goal goal,
    Period period,
    Evaluation _evaluation,
  ) {
    return Objective._(steps, goal, period, Evaluation.empty, Result.empty);
  }

  @override
  Objective evaluate(Evaluation e) {
    return Objective._(steps, goal, period, e, result);
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
class Goal {}

// 目標への結果を表します。
class Result extends Evaluable<Result> {
  Result._(this._evaluation);

  bool isEmpty() => false;
  static Result empty = EmptyResult();

  final Evaluation _evaluation;

  @override
  Result evaluate(Evaluation e) => Result._(e);

  @override
  Evaluation evaluation() => _evaluation;
}

class EmptyResult extends Result {
  EmptyResult() : super._(Evaluation.empty);

  @override
  bool isEmpty() => true;
}

