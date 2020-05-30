abstract class Repository<ID, AggregateRoot> {
  void store(AggregateRoot aggregate);
  AggregateRoot get(ID id);
}