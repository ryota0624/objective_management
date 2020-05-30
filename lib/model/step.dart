// 目標のステップを表します。
import 'package:objective_management/model/evaluation.dart';

class Step extends Evaluable<Step> {
  final StepOrder order;
  final Evaluation _evaluation;
  final StatusTransition _statusTransition;
  final Duration elapsedTimeFromStarted;

  Step start(DateTime when) => _updateStatus(when, _StatusInProgress());

  Step complete(DateTime when) => _updateStatus(when, _StatusCompleted());

  Step skip(DateTime when) => _updateStatus(when, _StatusSkipped());

  Step _updateStatus(DateTime when, StepStatus s) => Step._(order, _evaluation,
      _statusTransition.add(when, s), elapsedTimeFromStarted);

  bool isCompleted() => _statusTransition.current().isCompleted();

  bool isFinished() => _statusTransition.current().isFinished();

  Step._(this.order, this._evaluation, this._statusTransition,
      this.elapsedTimeFromStarted);

  factory Step(StepOrder order) => Step._(
      order, Evaluation.empty, StatusTransition.initial(), Duration.zero);

  @override
  Step evaluate(Evaluation e) =>
      Step._(order, e, _statusTransition, elapsedTimeFromStarted);

  @override
  Evaluation evaluation() => _evaluation;
}

// ステータスの遷移です。
class StatusTransition {
  // 開始からの時間
  // 完了までの時間 等のStatusの変遷に関する計算をする
  final List<StepStatus> _statuses;

  StatusTransition(this._statuses);

  StepStatus current() => _statuses.last;

  StatusTransition add(DateTime when, StepStatus status) =>
      StatusTransition([..._statuses, status]);

  static StatusTransition initial() => StatusTransition([StepStatus.pending]);
}

abstract class StepStatus {
  bool isCompleted();

  bool isFinished();

  static StepStatus pending = _StatusPending();
}

class _StatusPending extends StepStatus {
  @override
  bool isCompleted() => false;

  @override
  bool isFinished() => false;
}

class _StatusInProgress extends StepStatus {
  @override
  bool isCompleted() => false;

  @override
  bool isFinished() => false;
}

class _StatusCompleted extends StepStatus {
  @override
  bool isCompleted() => true;

  @override
  bool isFinished() => true;
}

class _StatusSkipped extends StepStatus {
  @override
  bool isCompleted() => false;

  @override
  bool isFinished() => true;
}

// Stepの順序です。
class StepOrder {
  int order;
}

// Stepの集合です。
class Steps {
  bool isAllFinished() =>
      _values.values.every((element) => element.isFinished());

  final Map<StepOrder, Step> _values;

  Steps(this._values);

  Step getByOrder(StepOrder o) => _values[o];

  Steps updateStep(Step s) {
    var updated = Map.from(_values);
    updated[s.order] = s;
    return Steps(updated);
  }
}
