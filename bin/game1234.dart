
sealed class Expression {
  Set<int> get ints;

  int get value;
}

class IntExpr extends Expression {
  @override
  final int value;

  IntExpr(this.value);

  @override
  Set<int> get ints => {value};

  @override
  operator ==(other) {
    return other is IntExpr && other.value == value;
  }

  @override
  String toString() => value.toString();

  @override
  int get hashCode => 0;
}

class AddExpr extends Expression {
  final Expression l;
  final Expression r;

  AddExpr(this.l, this.r);

  @override
  Set<int> get ints => {...l.ints, ...r.ints};

  @override
  int get value => l.value + r.value;

  @override
  operator ==(other) {
    return other is AddExpr &&
        ((other.l == l && other.r == r) || (other.r == l && other.l == r));
  }

  @override
  int get hashCode => 0;

  @override
  String toString() => '($l + $r)';
}

class MultiplyExpr extends Expression {
  final Expression l;
  final Expression r;

  MultiplyExpr(this.l, this.r);

  @override
  Set<int> get ints => {...l.ints, ...r.ints};

  @override
  int get value => l.value * r.value;

  @override
  String toString() => '($l * $r)';

  @override
  operator ==(other) {
    return other is MultiplyExpr &&
        ((other.l == l && other.r == r) || (other.r == l && other.l == r));
  }

  @override
  int get hashCode => 0;
}

List<Expression> simples(Expression? a, Expression? b) {
  if (a == null) {
    int ai = 1;
    List<Expression> result = [];
    while (ai <= 4) {
      int bi = 1;
      while (bi <= 4) {
        if (ai == bi) {
          bi++;
          continue;
        }
        result.addAll(simples(IntExpr(ai), IntExpr(bi)));
        bi++;
      }
      ai++;
    }
    return result;
  }
  return [AddExpr(a, b!), MultiplyExpr(a, b), a, b];
}

Set<Expression> calculate() {
  List<Expression> simpleList = simples(null, null);
  Set<Expression> result = {};
  for (Expression simplea in simpleList) {
    for (Expression simpleb in simpleList) {
      if (simplea.ints.intersection(simpleb.ints).isNotEmpty) {
        continue;
      }
      result.addAll([
        simplea,
        simpleb,
        AddExpr(simplea, simpleb),
        MultiplyExpr(simplea, simpleb)
      ]);
    }
  }
  int a = 1;
  while (a <= 4) {
    int b = 1;
    while (b <= 4) {
      if (a == b) {
        b++;
        continue;
      }
      int c = 1;
      while (c <= 4) {
        if (c == b || c == a) {
          c++;
          continue;
        }
        int d = 1;
        while (d <= 4) {
          if (d == c || d == b || d == a) {
            d++;
            continue;
          }
          result.add(MultiplyExpr(MultiplyExpr(MultiplyExpr(IntExpr(a), IntExpr(b)), IntExpr(c)), IntExpr(d)));
          result.add(MultiplyExpr(MultiplyExpr(AddExpr(IntExpr(a), IntExpr(b)), IntExpr(c)), IntExpr(d)));
          result.add(MultiplyExpr(AddExpr(MultiplyExpr(IntExpr(a), IntExpr(b)), IntExpr(c)), IntExpr(d)));
          result.add(MultiplyExpr(AddExpr(AddExpr(IntExpr(a), IntExpr(b)), IntExpr(c)), IntExpr(d)));
          result.add(AddExpr(MultiplyExpr(MultiplyExpr(IntExpr(a), IntExpr(b)), IntExpr(c)), IntExpr(d)));
          result.add(AddExpr(MultiplyExpr(AddExpr(IntExpr(a), IntExpr(b)), IntExpr(c)), IntExpr(d)));
          result.add(AddExpr(AddExpr(MultiplyExpr(IntExpr(a), IntExpr(b)), IntExpr(c)), IntExpr(d)));
          result.add(AddExpr(AddExpr(AddExpr(IntExpr(a), IntExpr(b)), IntExpr(c)), IntExpr(d)));
          d++;
        }
        c++;
      }
      b++;
    }
    a++;
  }
  return result;
}

void main(List<String> arguments) {
  for (Expression expression in calculate().toList()..sort((e, e2) => e.value.compareTo(e2.value))) {
    print('${expression.value}: $expression');
  }
}
