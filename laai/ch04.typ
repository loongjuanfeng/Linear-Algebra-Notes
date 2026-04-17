#import "../../libs.typ": *
#import "../syms.typ": *

#show: ilm.with(
  title: [Linear Algebra],
  date: datetime.today(),
  author: "Junfeng Lve",
  abstract: [Notes on Chapter 4 of _Linear Algebra for Artificial Intelligence_],
)
#show: setup

= 范数理论

== 向量范数

在欧氏几何里，我们用长度描述向量有多大。在线性代数里，我们希望把“长度”抽象成一个满足少量公理的函数：它既保留几何直觉，又允许我们针对不同任务强调不同的“大小”概念。比如稀疏表示更关心非零分量是否多，鲁棒优化更关心最大坐标偏差，而最小二乘问题则天然偏向欧氏长度。

#definition[向量范数][
  设 $V$ 是定义在 $RR$ 上的向量空间。称函数
  $
    norm(·) : V -> RR
  $
  为 $V$ 上的一个向量范数，若对任意 $vc(x), vc(y) in V$ 与任意 $alpha in RR$，都有
  + $norm(vc(x)) >= 0$，且 $norm(vc(x)) = 0$ 当且仅当 $vc(x) = 0$
  + $norm(alpha vc(x)) = abs(alpha) norm(vc(x))$
  + $norm(vc(x) + vc(y)) <= norm(vc(x)) + norm(vc(y))$
]

这三个条件分别抓住了“长度”最基本的结构。

+ 第一条说的是：长度不能为负，而且只有零向量的长度为零。
+ 第二条说的是：把向量拉伸 $abs(alpha)$ 倍，它的长度也恰好拉伸 $abs(alpha)$ 倍。
+ 第三条就是三角不等式：走“折线”不会比走“直线”更短，因此两个向量合在一起的长度不会超过各自长度之和。

其中第三条最关键。许多分析性质，例如连续性、极限估计、误差传播控制，本质上都依赖于三角不等式。

#example[$RR^n$ 中的常见范数][
  对于 $vc(x) = (x_1, dots, x_n)^"T" in RR^n$，最常见的几种范数是
  + $norm(vc(x))_1 = sum_(i = 1)^n abs(x_i)$
  + $norm(vc(x))_2 = (sum_(i = 1)^n abs(x_i)^2)^(1 / 2)$
  + $norm(vc(x))_oo = max_(1 <= i <= n) abs(x_i)$

  更一般地，当 $1 <= p < oo$ 时，
  $
    norm(vc(x))_p = (sum_(i = 1)^n abs(x_i)^p)^(1 / p)
  $
  也是范数。
]

$norm(·)_1$ 衡量的是所有坐标偏差的总量，因此对稀疏结构很敏感；$norm(·)_2$ 就是通常的欧氏长度，最符合几何直觉；$norm(·)_oo$ 只看最坏的那个坐标，因此常用于控制逐坐标误差。

#caveat[“$norm(·)_0$” 不是范数][
  机器学习里常把向量的非零分量个数记为 $norm(vc(x))_0$，它确实能刻画稀疏性，但它不是严格意义下的范数。原因在于当 $alpha != 0$ 时，通常有
  $
    norm(alpha vc(x))_0 = norm(vc(x))_0 != abs(alpha) norm(vc(x))_0
  $
  因而它不满足齐次性。
]

#proposition[反三角不等式][
  对任意向量范数与任意 $vc(x), vc(y) in V$，都有
  $
    abs(norm(vc(x)) - norm(vc(y))) <= norm(vc(x) - vc(y))
  $
]

证明只需把三角不等式用两次。由
$
  vc(x) = (vc(x) - vc(y)) + vc(y)
$
可得
$
  norm(vc(x)) <= norm(vc(x) - vc(y)) + norm(vc(y))
$
即
$
  norm(vc(x)) - norm(vc(y)) <= norm(vc(x) - vc(y))
$
交换 $vc(x), vc(y)$ 的角色，又有
$
  norm(vc(y)) - norm(vc(x)) <= norm(vc(x) - vc(y))
$
合并这两式便得到结论。

这个不等式很有用，它表明范数本身就是连续的：若 $vc(x)$ 略微改变，则 $norm(vc(x))$ 也只能略微改变。

#theorem[三种常用范数之间的比较][
  对任意 $vc(x) in RR^n$，都有
  $
    norm(vc(x))_oo <= norm(vc(x))_2 <= norm(vc(x))_1 <= n norm(vc(x))_oo
  $
  以及
  $
    norm(vc(x))_2 <= sqrt(n) norm(vc(x))_oo, quad
    norm(vc(x))_1 <= sqrt(n) norm(vc(x))_2
  $
]

这些不等式说明：虽然不同范数测量“大小”的方式不同，但它们不会彼此相差得毫无边界。

证明可以逐条估计。

对任意 $i$，都有
$
  abs(x_i)^2 <= sum_(k = 1)^n abs(x_k)^2 = norm(vc(x))_2^2
$
所以 $abs(x_i) <= norm(vc(x))_2$，再对 $i$ 取最大值得到
$
  norm(vc(x))_oo <= norm(vc(x))_2
$

另一方面，
$
  norm(vc(x))_2^2 = sum_(i = 1)^n abs(x_i)^2
  <= (sum_(i = 1)^n abs(x_i))^2 = norm(vc(x))_1^2
$
因而 $norm(vc(x))_2 <= norm(vc(x))_1$。

又因为每个 $abs(x_i) <= norm(vc(x))_oo$，故
$
  norm(vc(x))_1 = sum_(i = 1)^n abs(x_i) <= sum_(i = 1)^n norm(vc(x))_oo = n norm(vc(x))_oo
$

同理，
$
  norm(vc(x))_2^2 = sum_(i = 1)^n abs(x_i)^2 <= sum_(i = 1)^n norm(vc(x))_oo^2 = n norm(vc(x))_oo^2
$
从而 $norm(vc(x))_2 <= sqrt(n) norm(vc(x))_oo$。

最后由Cauchy-Schwarz不等式，
$
  norm(vc(x))_1 = sum_(i = 1)^n 1 abs(x_i)
  <= (sum_(i = 1)^n 1^2)^(1 / 2) (sum_(i = 1)^n abs(x_i)^2)^(1 / 2)
  = sqrt(n) norm(vc(x))_2
$

#connection[单位球反映了范数的几何][
  在 $RR^2$ 中，单位球
  $
    B = {vc(x) in RR^2 : norm(vc(x)) <= 1}
  $
  的形状会随着范数不同而改变：
  + $norm(·)_2$ 的单位球是圆盘
  + $norm(·)_1$ 的单位球是菱形
  + $norm(·)_oo$ 的单位球是正方形
]

这件事很值得记住。选择范数，不只是换一个公式而已，而是在改变空间里的几何。最优化问题中的约束区域、最近点的形状、误差传播的方式，都会随着范数变化而变化。

#theorem[有限维空间中的范数等价][
  设 $V$ 是有限维实向量空间，$norm(·)_a$ 与 $norm(·)_b$ 是 $V$ 上两个向量范数，则存在常数 $c, C > 0$，使得对任意 $vc(x) in V$ 都有
  $
    c norm(vc(x))_a <= norm(vc(x))_b <= C norm(vc(x))_a
  $
]

这个定理说明，在有限维空间里，“用哪一个范数”通常不会改变问题的定性结论。比如收敛、连续、有界等概念，在不同范数下是等价的；真正会出现本质差异的，往往是无穷维空间。

下面给出一个非常重要且直观的证明思路。

先选定 $V$ 的一组基，把 $V$ 与 $RR^n$ 识别，并以 $norm(·)_2$ 表示欧氏范数。由反三角不等式可知，每一个范数都是连续函数，因为
$
  abs(norm(vc(x))_a - norm(vc(y))_a) <= norm(vc(x) - vc(y))_a
$

考虑欧氏单位球面
$
  S = {vc(x) in RR^n : norm(vc(x))_2 = 1}
$
它是闭且有界的，因此是紧集。连续函数 $norm(·)_a$ 在紧集 $S$ 上必能取到最小值与最大值，记为 $m_a$ 与 $M_a$。又因为 $vc(x) in S$ 时不可能有 $vc(x) = 0$，所以 $m_a > 0$。于是对任意 $vc(u) in S$，都有
$
  m_a <= norm(vc(u))_a <= M_a
$

对任意非零向量 $vc(x)$，令
$
  vc(u) = vc(x) / norm(vc(x))_2
$
则 $vc(u) in S$，并且由齐次性，
$
  norm(vc(x))_a = norm(vc(x))_2 norm(vc(u))_a
$
从而
$
  m_a norm(vc(x))_2 <= norm(vc(x))_a <= M_a norm(vc(x))_2
$
对 $norm(·)_b$ 也同样成立，于是二者都被欧氏范数夹住，自然就能彼此比较，得到存在常数 $c, C > 0$ 使得
$
  c norm(vc(x))_a <= norm(vc(x))_b <= C norm(vc(x))_a
$

因此，在有限维线性代数里，我们往往可以按照计算方便、几何解释或应用场景来选择范数，而不必担心“换了范数以后整个理论就变了”。

== 矩阵范数

向量范数衡量的是“一个向量有多大”，矩阵范数则衡量“一个线性变换有多强”或者“一个矩阵的整体规模有多大”。这两种说法看似不同，其实对应着看矩阵的两种基本视角：

+ 把矩阵看成一个由很多数字组成的对象，此时范数衡量的是所有元素整体有多大。
+ 把矩阵看成线性映射 $vc(x) mapsto mt(A) vc(x)$，此时范数衡量的是它会把向量放大多少。

这两条路线都会得到合法的矩阵范数，但它们关心的信息并不完全一样。

#definition[矩阵范数][
  设 $RR^(m times n)$ 表示所有 $m times n$ 实矩阵构成的向量空间。称函数
  $
    norm(·) : RR^(m times n) -> RR
  $
  为一个矩阵范数，若对任意 $mt(A), mt(B) in RR^(m times n)$ 与任意 $alpha in RR$，都有
  + $norm(mt(A)) >= 0$，且 $norm(mt(A)) = 0$ 当且仅当 $mt(A) = mt(O)$
  + $norm(alpha mt(A)) = abs(alpha) norm(mt(A))$
  + $norm(mt(A) + mt(B)) <= norm(mt(A)) + norm(mt(B))$
]

这一定义只是说：矩阵空间本身也是一个有限维向量空间，因此完全可以像研究向量那样研究矩阵的“长度”。

#note[两类常见矩阵范数][
  实际应用里，矩阵范数大致分成两类。

  + 元素型范数：直接由矩阵元素构造，把矩阵当成长度为 $m n$ 的向量。
  + 算子型范数：通过矩阵对向量的作用来定义，把矩阵当成线性映射。
]

第一类容易计算，第二类更能反映线性变换本身的几何与稳定性。数值分析、优化与机器学习里，算子型范数通常更核心。

#example[把矩阵当作向量得到的范数][
  设 $mt(A) = (a_(i j)) in RR^(m times n)$。常见的元素型范数包括
  + $ norm(mt(A))_"E,1" = sum_(i = 1)^m sum_(j = 1)^n abs(a_(i j)) $
  + $ norm(mt(A))_"F" = (sum_(i = 1)^m sum_(j = 1)^n abs(a_(i j))^2)^(1 / 2) $
  + $ norm(mt(A))_"max" = max_(1 <= i <= m, 1 <= j <= n) abs(a_(i j)) $
]

其中 $norm(mt(A))_"F"$ 称为 Frobenius范数。它就是把矩阵所有元素排成一个长向量以后得到的欧氏范数，所以它对每个元素一视同仁，几何上最自然，计算上也最方便。

#definition[诱导矩阵范数][
  设 $norm(·)_a$ 是 $RR^n$ 上的向量范数，$norm(·)_b$ 是 $RR^m$ 上的向量范数。对任意 $mt(A) in RR^(m times n)$，定义
  $
    norm(mt(A))_((b,a)) = max_(norm(vc(x))_a = 1) norm(mt(A) vc(x))_b
  $
  等价地，
  $
    norm(mt(A))_((b,a)) = max_(vc(x) != 0) (norm(mt(A) vc(x))_b) / (norm(vc(x))_a)
  $
  称之为由向量范数诱导出的矩阵范数。

  当 $m = n$ 且定义域、值域采用同一个向量范数 $norm(·)_p$ 时，常记为
  $
    norm(mt(A))_p = max_(vc(x) != 0) (norm(mt(A) vc(x))_p) / (norm(vc(x))_p)
  $
]

这个定义的含义非常直接：$norm(mt(A))_((b,a))$ 就是矩阵 $mt(A)$ 对单位向量可能产生的最大放大倍数。因此它天生适合回答如下问题：

+ 输入误差最多会被放大多少？
+ 迭代映射会不会爆炸？
+ 求解线性方程组时，系数矩阵会不会让扰动变得很敏感？

#intuition[诱导范数的几何意义][
  在诱导范数下，矩阵 $mt(A)$ 把定义域中的单位球
  $
    B_a = {vc(x) in RR^n : norm(vc(x))_a <= 1}
  $
  映到值域中的集合 $mt(A) B_a$。此时
  $
    norm(mt(A))_((b,a))
  $
  就是这个像集被 $norm(·)_b$ 度量时离原点最远的距离。
]

因此，诱导范数并不是在“统计矩阵元素”，而是在看这个矩阵能把整个单位球拉伸到什么程度。

#proposition[诱导范数的基本性质][
  对任意 $mt(A) in RR^(m times n)$ 与任意 $vc(x) in RR^n$，都有
  $
    norm(mt(A) vc(x))_b <= norm(mt(A))_((b,a)) norm(vc(x))_a
  $

  若 $mt(A), mt(B) in RR^(n times n)$ 且都由同一个向量范数 $norm(·)_a$ 诱导，则
  $
    norm(mt(A) mt(B))_a <= norm(mt(A))_a norm(mt(B))_a
  $
  并且
  $
    norm(mt(I))_a = 1
  $
]

第一条不等式其实就是定义本身的改写。若 $vc(x) = 0$，结论显然成立；若 $vc(x) != 0$，则
$
  (norm(mt(A) vc(x))_b) / (norm(vc(x))_a) <= max_(vc(y) != 0) (norm(mt(A) vc(y))_b) / (norm(vc(y))_a) = norm(mt(A))_((b,a))
$
两边同乘 $norm(vc(x))_a$ 即得。

第二条说明诱导范数与矩阵乘法天然相容，因为对任意 $vc(x) != 0$，
$
  norm(mt(A) mt(B) vc(x))_a
  <= norm(mt(A))_a norm(mt(B) vc(x))_a
  <= norm(mt(A))_a norm(mt(B))_a norm(vc(x))_a
$
再对所有非零 $vc(x)$ 取最大值即可。至于 $norm(mt(I))_a = 1$，则由
$
  norm(mt(I) vc(x))_a = norm(vc(x))_a
$
直接得到。

#theorem[诱导 $1$ 范数与 $oo$ 范数的显式公式][
  设 $mt(A) = (a_(i j)) in RR^(m times n)$，则
  $
    norm(mt(A))_1 = max_(1 <= j <= n) sum_(i = 1)^m abs(a_(i j))
  $
  也就是绝对值列和的最大值；并且
  $
    norm(mt(A))_oo = max_(1 <= i <= m) sum_(j = 1)^n abs(a_(i j))
  $
  也就是绝对值行和的最大值。
]

先证 $1$ 范数公式。对任意 $vc(x) in RR^n$，有
$
  norm(mt(A) vc(x))_1
  = sum_(i = 1)^m abs(sum_(j = 1)^n a_(i j) x_j)
  <= sum_(i = 1)^m sum_(j = 1)^n abs(a_(i j)) abs(x_j)
  = sum_(j = 1)^n (sum_(i = 1)^m abs(a_(i j))) abs(x_j)
$
记
$
  c = max_(1 <= j <= n) sum_(i = 1)^m abs(a_(i j))
$
则
$
  norm(mt(A) vc(x))_1 <= c sum_(j = 1)^n abs(x_j) = c norm(vc(x))_1
$
故 $norm(mt(A))_1 <= c$。

反过来，若第 $j_0$ 列达到最大列和，则取标准基向量 $vc(e)_(j_0)$，满足 $norm(vc(e)_(j_0))_1 = 1$，并且
$
  norm(mt(A) vc(e)_(j_0))_1 = sum_(i = 1)^m abs(a_(i j_0)) = c
$
因而 $norm(mt(A))_1 >= c$。于是 $norm(mt(A))_1 = c$。

$oo$ 范数完全类似。对任意 $vc(x)$，有
$
  abs((mt(A) vc(x))_i) <= sum_(j = 1)^n abs(a_(i j)) abs(x_j) <= (sum_(j = 1)^n abs(a_(i j))) norm(vc(x))_oo
$
再对 $i$ 取最大值可得
$
  norm(mt(A) vc(x))_oo <= (max_(1 <= i <= m) sum_(j = 1)^n abs(a_(i j))) norm(vc(x))_oo
$
反过来，若第 $i_0$ 行达到最大行和，就取 $vc(x)$ 满足每个分量 $x_j = 1$ 或 $-1$，并使得
$
  a_(i_0 j) x_j = abs(a_(i_0 j))
$
此时 $norm(vc(x))_oo = 1$，且
$
  (mt(A) vc(x))_(i_0) = sum_(j = 1)^n abs(a_(i_0 j))
$
故可以达到该上界。

#theorem[谱范数与 $mt(A)^"T" mt(A)$][
  设 $mt(A) in RR^(m times n)$，则由欧氏范数诱导出的矩阵范数满足
  $
    norm(mt(A))_2 = max_(norm(vc(x))_2 = 1) norm(mt(A) vc(x))_2
  $
  并且若 $mu_1$ 是对称半正定矩阵 $mt(A)^"T" mt(A)$ 的最大特征值，则
  $
    norm(mt(A))_2 = sqrt(mu_1)
  $

  特别地，若 $mt(A)$ 还是实对称矩阵，特征值为 $lambda_1, dots, lambda_n$，则
  $
    norm(mt(A))_2 = max_(1 <= i <= n) abs(lambda_i)
  $
]

证明并不复杂。对任意 $norm(vc(x))_2 = 1$，有
$
  norm(mt(A) vc(x))_2^2 = (mt(A) vc(x))^"T" (mt(A) vc(x)) = vc(x)^"T" mt(A)^"T" mt(A) vc(x)
$
由于 $mt(A)^"T" mt(A)$ 是实对称半正定矩阵，它可以正交对角化，且二次型在单位球面上的最大值恰好是其最大特征值 $mu_1$，因此
$
  max_(norm(vc(x))_2 = 1) norm(mt(A) vc(x))_2^2 = mu_1
$
取平方根便得到 $norm(mt(A))_2 = sqrt(mu_1)$。

若 $mt(A)$ 对称，则可正交对角化为
$
  mt(A) = mt(S) mt(D) mt(S)^"T"
$
其中 $mt(D) = diag{lambda_1, dots, lambda_n}$。于是
$
  mt(A)^"T" mt(A) = mt(A)^2 = mt(S) diag{lambda_1^2, dots, lambda_n^2} mt(S)^"T"
$
所以其最大特征值为 $max_i lambda_i^2$，从而
$
  norm(mt(A))_2 = max_(1 <= i <= n) abs(lambda_i)
$

这说明谱范数正是“沿某个方向的最大拉伸率”。在几何上，它最直接反映线性变换把欧氏球拉成长椭球以后，最长半轴有多长。

#example[同一个矩阵在不同范数下的大小][
  设
  $
    mt(A) = mat(1, 1; 0, 0)
  $
  则
  + 元素和范数：$norm(mt(A))_"E,1" = 2$
  + Frobenius范数：$norm(mt(A))_"F" = sqrt(2)$
  + 最大元素范数：$norm(mt(A))_"max" = 1$
  + 诱导 $1$ 范数：$norm(mt(A))_1 = 1$
  + 诱导 $oo$ 范数：$norm(mt(A))_oo = 2$
  + 谱范数：$norm(mt(A))_2 = sqrt(2)$
]

这个例子很能说明问题：不同范数测量的是不同侧面。有的更看重所有元素的总量，有的更看重最坏行或最坏列，有的更看重算子对向量的最大放大率。

#caveat[不是每个矩阵范数都与乘法相容][
  元素型范数一定是矩阵空间上的合法范数，但不一定满足
  $
    norm(mt(A) mt(B)) <= norm(mt(A)) norm(mt(B))
  $
  这样的次乘性。

  例如最大元素范数 $norm(·)_"max"$ 一般只满足带维数因子的估计，而不一定满足常数恰好为 $1$ 的次乘性。因此当我们关心矩阵连乘、幂迭代、稳定性与误差传播时，通常更偏爱诱导范数或 Frobenius范数。
]

#proposition[Frobenius范数的若干性质][
  对任意 $mt(A), mt(B) in RR^(m times n)$，都有
  + $norm(mt(A))_"F"^2 = sum_(i = 1)^m sum_(j = 1)^n abs(a_(i j))^2$
  + $norm(mt(A))_2 <= norm(mt(A))_"F"$
  + 若 $rank(mt(A)) = r$，则 $norm(mt(A))_"F" <= sqrt(r) norm(mt(A))_2$
]

这些关系说明：谱范数只关心最大的拉伸方向，而 Frobenius范数则把所有方向上的能量累加起来，因此通常更大，但又不会比谱范数大得没有边界。

如果记 $mt(A)^"T" mt(A)$ 的非零特征值为 $mu_1 >= dots >= mu_r > 0$，那么
$
  norm(mt(A))_2 = sqrt(mu_1), quad norm(mt(A))_"F" = (mu_1 + dots + mu_r)^(1 / 2)
$
于是立刻得到
$
  mu_1 <= mu_1 + dots + mu_r <= r mu_1
$
也就是
$
  norm(mt(A))_2 <= norm(mt(A))_"F" <= sqrt(r) norm(mt(A))_2
$

#connection[矩阵范数之间同样等价][
  因为 $RR^(m times n)$ 也是有限维向量空间，所以任意两个矩阵范数也是等价的。也就是说，对任意两个矩阵范数 $norm(·)_a$ 与 $norm(·)_b$，存在常数 $c, C > 0$，使得
  $
    c norm(mt(A))_a <= norm(mt(A))_b <= C norm(mt(A))_a
  $
  对所有 $mt(A) in RR^(m times n)$ 成立。
]

这告诉我们：在有限维情形下，范数的选择通常不会改变“是否收敛”“是否有界”这类定性结论，但会显著影响估计常数、几何图像与计算便利性。

#connection[条件数是矩阵范数的重要应用][
  若可逆矩阵 $mt(A) in RR^(n times n)$ 关于某个诱导范数的条件数定义为
  $
    kappa_p(mt(A)) = norm(mt(A))_p norm(mt(A)^(-1))_p
  $
  则它衡量的是线性方程组
  $
    mt(A) vc(x) = vc(b)
  $
  对数据扰动的敏感程度。
]

若 $kappa_p(mt(A))$ 很大，那么即使右端项 $vc(b)$ 或系数矩阵 $mt(A)$ 只发生很小变化，解 $vc(x)$ 也可能变化很大；若 $kappa_p(mt(A))$ 不大，则问题更稳定。于是矩阵范数不仅是“测大小”的工具，也是“测病态程度”的基础语言。

总结起来，向量范数回答的是“一个向量有多大”，矩阵范数回答的是“一个矩阵整体有多大，以及它会把向量放大多少”。前者是长度理论的起点，后者则是稳定性分析、误差估计、谱理论与数值计算的入口。
