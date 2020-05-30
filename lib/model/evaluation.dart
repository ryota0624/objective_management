import 'package:objective_management/model/text.dart';

// Evaluable は評価が可能なもの表します。
abstract class Evaluable<E> {
  E evaluate(Evaluation e);

  Evaluation evaluation();
}

// 目標の結果への評価を表します。
class Evaluation {
  Evaluation(this.description);

  final Description description;
  bool isEmpty() => false;

  static EmptyEvaluation empty = EmptyEvaluation();
}

class EmptyEvaluation extends Evaluation {
  EmptyEvaluation(): super(Description(0, ''));

  @override
  bool isEmpty() => true;
}
