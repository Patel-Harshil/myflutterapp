extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}

/* Filter-> new extension
 filter -> new function 
 filter(bool Function(T) where) -> Function as parameter to get condition(where)
 map(Function ) -> converts the Iterable to new Iterable based on the given Function(condition)
 (items) => items.where(where).toList() returns item that is approved by function(Condition)
*/
