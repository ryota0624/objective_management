// 目標のステップを表します。
import 'package:objective_management/model/evaluation.dart';
import 'package:objective_management/model/text.dart';

class Step extends Evaluable<Step> {
  final StepOrder order;
  final Evaluation _evaluation;
  final StatusTransition _statusTransition;
  final StepDescription description;

  Step start(DateTime when) => _updateStatus(when, _StatusInProgress());

  Step complete(DateTime when) => _updateStatus(when, _StatusCompleted());

  Step skip(DateTime when) => _updateStatus(when, _StatusSkipped());

  Step _updateStatus(DateTime when, StepStatus s) =>
      Step._(order, _evaluation, _statusTransition.add(when, s), description);

  bool isCompleted() => _statusTransition.current().isCompleted();

  bool isFinished() => _statusTransition.current().isFinished();

  Step._(
      this.order, this._evaluation, this._statusTransition, this.description);

  factory Step(StepOrder order, StepDescription description) =>
      Step._(order, Evaluation.empty, StatusTransition.initial(), description);

  @override
  Step evaluate(Evaluation e) =>
      Step._(order, e, _statusTransition, description);

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
  final int order;

  StepOrder(this.order);

  StepOrder next() => StepOrder(order + 1);

  static StepOrder one = StepOrder(1);
}

// Stepの集合です。
class Steps {
  Step last() => _sorted().last;

  Step first() => _sorted().first;

  // TODO 進行中のものを取り出す。 inProgress
  List<Step> _sorted() {
    // TODO StepOrderに実装
    var list = _values.values.toList();
    list.sort((a, b) => a.order.order - b.order.order);
    return list;
  }

  Step inProgress() {
    return _sorted().firstWhere((element) => element is _StatusInProgress);
  }

  Steps completeInProgressStep(DateTime now) {
    return _processInProgressStep(now, (now, step) => step.complete(now));
  }

  Steps skipInProgressStep(DateTime now) {
    return _processInProgressStep(now, (now, step) => step.skip(now));
  }

  Steps _processInProgressStep(
      DateTime now, Step Function(DateTime, Step) process) {
    final step = inProgress();
    final completedStep = process(now, step);
    final updated = updateStep(completedStep);
    if (updated._values.containsKey(completedStep.order.next())) {
      final next = updated._values[completedStep.order.next()];
      return updateStep(next.start(now));
    } else {
      return updated;
    }
  }

  bool isAllFinished() =>
      _values.values.every((element) => element.isFinished());

  final Map<StepOrder, Step> _values;

  Steps(this._values);

  factory Steps.fromList(List<Step> list) {
    var _values = Map<StepOrder, Step>.identity();
    list.forEach((element) {
      _values[element.order] = element;
    });
    return Steps(_values);
  }

  factory Steps.fromDescriptionList(List<StepDescription> list) {
    final firstStep = Step(StepOrder.one, list.first);
    return list.fold<Steps>(Steps.fromList([firstStep]), (orders, desc) {
      return orders.add(Step(orders.last().order.next(), desc));
    });
  }

  Step getByOrder(StepOrder o) => _values[o];

  Steps updateStep(Step s) {
    var updated = Map.from(_values);
    updated[s.order] = s;
    return Steps(updated);
  }

  Steps add(Step s) => updateStep(s);
}
