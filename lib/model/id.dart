abstract class ID {
  final String _value;

  ID(this._value);

  @override
  String toString() => _value;
}

mixin RandomStringGenerator {
  String randomString();
}

abstract class IDFactory<I extends ID> {
  final I Function(String) _createFromString;
  final RandomStringGenerator _randomStringGenerator;

  IDFactory(
    this._createFromString,
    this._randomStringGenerator,
  );

  I create() => _createFromString(_randomStringGenerator.randomString());
}

class ObjectiveID extends ID {
  ObjectiveID(String value) : super(value);
}

class ObjectiveIDFactory extends IDFactory<ObjectiveID> {
  ObjectiveIDFactory(RandomStringGenerator _randomStringGenerator)
      : super((str) => ObjectiveID(str), _randomStringGenerator);
}
