// Evaluable は評価が可能なもの表します。
abstract class Evaluable<E> {
  E evaluate(Evaluation e);

  Evaluation evaluation();
}

// 目標の結果への評価を表します。
class Evaluation {
  const Evaluation();

  bool isEmpty() => false;

  static const EmptyEvaluation empty = EmptyEvaluation();
}

class EmptyEvaluation extends Evaluation {
  const EmptyEvaluation();

  @override
  bool isEmpty() => true;
}
