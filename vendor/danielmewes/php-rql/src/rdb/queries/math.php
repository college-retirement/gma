<?php namespace r;

// Helper class
class BinaryOp extends ValuedQuery
{
    public function __construct($termType, ValuedQuery $value, $other) {
        if (!(is_object($other) && is_subclass_of($other, "\\r\\Query")))
            $other = nativeToDatum($other);
        $this->termType = $termType;

        $this->setPositionalArg(0, $value);
        $this->setPositionalArg(1, $other);
    }

    protected function getTermType() {
        return $this->termType;
    }

    private $termType;
}

class Add extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_ADD, $value, $other);
    }
}
class Sub extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_SUB, $value, $other);
    }
}
class Mul extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_MUL, $value, $other);
    }
}
class Div extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_DIV, $value, $other);
    }
}
class Mod extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_MOD, $value, $other);
    }
}
class RAnd extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_ALL, $value, $other);
    }
}
class ROr extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_ANY, $value, $other);
    }
}
class Eq extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_EQ, $value, $other);
    }
}
class Ne extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_NE, $value, $other);
    }
}
class Gt extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_GT, $value, $other);
    }
}
class Ge extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_GE, $value, $other);
    }
}
class Lt extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_LT, $value, $other);
    }
}
class Le extends BinaryOp {
    public function __construct(ValuedQuery $value, $other) {
        parent::__construct(pb\Term_TermType::PB_LE, $value, $other);
    }
}

class Not extends ValuedQuery
{
    public function __construct(ValuedQuery $value) {
        $this->setPositionalArg(0, $value);
    }

    protected function getTermType() {
        return pb\Term_TermType::PB_NOT;
    }
}

class Match extends ValuedQuery
{
    public function __construct(ValuedQuery $value, $expression) {
        if (!(is_object($expression) && is_subclass_of($expression, "\\r\\Query")))
            $expression = nativeToDatum($expression);

        $this->setPositionalArg(0, $value);
        $this->setPositionalArg(1, $expression);
    }

    protected function getTermType() {
        return pb\Term_TermType::PB_MATCH;
    }
}

?>
