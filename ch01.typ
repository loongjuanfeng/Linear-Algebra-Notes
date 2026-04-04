#import "../libs.typ": *

#show: ilm.with(
  title: [Chapter 1: Linear Algebra],
  date: datetime.today(),
)
#show: setup

= Vectors and Spaces

#definition[向量空间][
  A set $V$ with operations $+$ and $dot$ satisfying the axioms of associativity, commutativity, identity, and distributivity.
  不是，啥意思啊
]

#idea[
  Think of vectors as arrows in space, or as abstract objects that can be added and scaled.
]

#example[
  $RR^n$ is the most common vector space. For instance, $RR^2$ consists of all pairs $(x, y)$ where $x, y in RR$.
]

#motivation[
  Why study vector spaces? Because linear systems, polynomials, functions, and many other mathematical objects all share the same algebraic structure.
]

= Linear Independence

#definition[Linear Independence][
  Vectors $v_1, v_2, ..., v_n$ are linearly independent if
  $ c_1 v_1 + c_2 v_2 + dots.c + c_n v_n = 0 $
  implies $c_1 = c_2 = dots.c = c_n = 0$.
]

#intuition[
  If none of the vectors can be written as a combination of the others, they are independent.
]

#remark[
  In $RR^2$, any two non-parallel vectors are linearly independent and form a basis.
]

#todo[
  Add exercises on proving linear independence with row reduction.
]
