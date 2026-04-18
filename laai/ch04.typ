#import "../../libs.typ": *
#import "../syms.typ": *

#show: ilm.with(
  title: [Linear Algebra],
  date: datetime.today(),
  author: "Junfeng Lve",
  abstract: [Notes on Chapter 4 of _Linear Algebra for Artificial Intelligence_],
)
#show: setup

= 向量范数

在欧氏几何里，我们用长度描述向量有多大。在线性代数里，我们希望把“长度”抽象成一个满足少量公理的函数：它既保留几何直觉，又允许我们针对不同任务强调不同的“大小”概念。比如稀疏表示更关心非零分量是否多，鲁棒优化更关心最大坐标偏差，而最小二乘问题则天然偏向欧氏长度。

== 定义与常见例子

#definition[向量范数][
  设 $V$ 是定义在 $RR$ 上的向量空间。称函数
  $
    norm(·) : V -> RR
  $
  为 $V$ 上的一个向量范数，若对任意 $vc(x), vc(y) in V$ 与任意 $alpha in RR$，都有
  + $norm(vc(x)) >= 0$，且 $norm(vc(x)) = 0$ 当且仅当 $vc(x) = 0$
  + $ norm(alpha vc(x)) = abs(alpha) norm(vc(x)) $
  + $ norm(vc(x) + vc(y)) <= norm(vc(x)) + norm(vc(y)) $
]

这三个条件分别抓住了“长度”最基本的结构。

+ 第一条说的是：长度不能为负，而且只有零向量的长度为零。
+ 第二条说的是：把向量拉伸 $abs(alpha)$ 倍，它的长度也恰好拉伸 $abs(alpha)$ 倍。
+ 第三条就是三角不等式：走“折线”不会比走“直线”更短，因此两个向量合在一起的长度不会超过各自长度之和。

其中第三条最关键。许多分析性质，例如连续性、极限估计、误差传播控制，本质上都依赖于三角不等式。

#example[$RR^n$ 中的常见范数][
  对于 $vc(x) = (x_1, dots, x_n)^"T" in RR^n$，最常见的几种范数是
  + $ norm(vc(x))_1 = sum_(i = 1)^n abs(x_i) $
  + $ norm(vc(x))_2 = (sum_(i = 1)^n abs(x_i)^2)^(1 / 2) $
  + $ norm(vc(x))_oo = max_(1 <= i <= n) abs(x_i) $

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

== 基本性质与几何直觉

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

因此，在有限维线性代数里，我们往往可以按照计算方便、几何解释或应用场景来选择范数，而不必担心”换了范数以后整个理论就变了”。

= 向量范数不等式

== $p$ 范数不等式链

前面已经见过不少范数估计，但真正把 $p$ 范数理论串起来的是几条经典不等式。它们有一条很清楚的逻辑链：先用Young不等式控制两个非负数的乘积，再推广成Hölder不等式来控制求和，接着由此推出Cauchy-Schwarz不等式与Minkowski不等式，最后得到不同 $p$ 范数之间的系统比较。

如果从“要控制什么量”这个角度看，这一串不等式其实对应三种最基本的运算：

+ Young不等式处理单个乘积。
+ Hölder不等式处理一串乘积的求和。
+ Minkowski不等式处理两个向量的相加。

而范数之间的比较定理，则是在告诉我们：即使选择了不同的“大小标准”，这些标准在有限维里也可以彼此换算。

== 共轭指数与Young不等式

#definition[共轭指数][
  若 $1 < p < oo$，并且 $q$ 满足
  $
    1 / p + 1 / q = 1
  $
  则称 $p$ 与 $q$ 互为共轭指数。等价地，
  $
    q = p / (p - 1)
  $
  另外约定 $1$ 与 $oo$ 也互为共轭。
]

这个定义第一次看往往有点突然，但它其实非常自然。因为在很多估计里，我们都想把一个乘积拆成两个部分来分别控制，而
$
  1 / p + 1 / q = 1
$
恰好保证两个幂次在最后能重新拼回一次项。可以把它理解成：$p$ 与 $q$ 是两种互相补位的刻度，一个更偏向平均，另一个更偏向峰值。

例如：

+ 当 $p = 2$ 时，$q = 2$，两边地位完全对称。
+ 当 $p = 1$ 时，$q = oo$，一边统计总量，另一边只看最大项。
+ 当 $p$ 很大时，$q$ 很接近 $1$，说明“更关注最大坐标”的度量，天然对应着“更关注总和”的补偿方式。

#connection[共轭指数对应对偶几何][
  从几何上看，$p$ 与 $q$ 的共轭关系描述的是两类单位球之间的对偶性。对固定向量 $vc(y)$，线性函数
  $
    vc(x) mapsto sum_(i = 1)^n x_i y_i
  $
  在 $p$ 范数单位球上能取得多大的值，恰好由 $norm(vc(y))_q$ 决定。换句话说，$q$ 范数衡量的是：向量 $vc(y)$ 作为一个线性函数时，对 $p$ 单位球施加“拉伸”或“支撑”的能力有多强。
]

#proposition[Young不等式][
  设 $p, q > 1$ 互为共轭指数，且 $a, b >= 0$，则
  $
    a b <= a^p / p + b^q / q
  $
  等号当且仅当 $a^p = b^q$ 时成立。
]

这是最基础的一步，它把乘积 $a b$ 拆成了两个幂次项之和。

直觉上，它说的是：两个非负量相乘时，最危险的情形是它们的尺度刚好匹配；一旦一边特别大、另一边特别小，就可以被两边各自的幂次代价吸收掉。等号条件 $a^p = b^q$ 正是在说这两个量处于最“平衡”的状态。

证明可以直接用一元函数。固定 $b >= 0$，考虑
$
  f(t) = t b - t^p / p, quad t >= 0
$
则
$
  f'(t) = b - t^(p - 1)
$
所以极大值在 $t = b^(1 / (p - 1)) = b^(q - 1)$ 处取得。代回可得
$
  f(t) <= f(b^(q - 1)) = b^q - b^q / p = b^q / q
$
取 $t = a$，便得到
$
  a b - a^p / p <= b^q / q
$
也就是Young不等式。等号成立恰好对应于极大点条件 $a = b^(q - 1)$，等价于 $a^p = b^q$。

== Hölder与Cauchy-Schwarz不等式

#theorem[Hölder不等式][
  设 $1 <= p, q <= oo$ 互为共轭指数。对任意 $vc(x), vc(y) in RR^n$，都有
  $
    sum_(i = 1)^n abs(x_i y_i) <= norm(vc(x))_p norm(vc(y))_q
  $
]

这个不等式说明：一个“内积型求和”可以由两个向量在互补范数下的大小来控制。它是很多估计的出发点。

更具体地说，Hölder不等式告诉我们：当你想估计
$
  sum_(i = 1)^n x_i y_i
$
这种“逐项配对以后再求和”的量时，不需要逐项精确分析，只要分别知道 $vc(x)$ 与 $vc(y)$ 在一对互补范数下有多大就够了。这正是它在分析、概率、优化里不断出现的原因。

其中最容易形成直觉的是端点情形 $p = 1, q = oo$。这时不等式变成
$
  sum_(i = 1)^n abs(x_i y_i) <= norm(vc(x))_1 norm(vc(y))_oo
$
它的意思非常朴素：每一项 $abs(y_i)$ 都不会超过最大值 $norm(vc(y))_oo$，所以整串加权和最多就是“总权重”乘上“最坏幅度”。

先看端点情形。若 $p = 1, q = oo$，则对每个 $i$ 都有
$
  abs(x_i y_i) <= abs(x_i) norm(vc(y))_oo
$
求和得到
$
  sum_(i = 1)^n abs(x_i y_i) <= norm(vc(y))_oo sum_(i = 1)^n abs(x_i) = norm(vc(x))_1 norm(vc(y))_oo
$
而当 $p = oo, q = 1$ 时，只要交换 $vc(x), vc(y)$ 的角色即可。

下面设 $1 < p < oo$，因此 $1 < q < oo$。若 $vc(x) = 0$ 或 $vc(y) = 0$，结论显然成立。否则令
$
  u_i = abs(x_i) / norm(vc(x))_p, quad v_i = abs(y_i) / norm(vc(y))_q
$
则
$
  sum_(i = 1)^n u_i^p = 1, quad sum_(i = 1)^n v_i^q = 1
$
对每个 $i$ 应用Young不等式，得
$
  u_i v_i <= u_i^p / p + v_i^q / q
$
求和后得到
$
  sum_(i = 1)^n u_i v_i <= 1 / p + 1 / q = 1
$
两边再乘上 $norm(vc(x))_p norm(vc(y))_q$，便得到Hölder不等式。

从证明也能看出它的内核：先把两个向量都归一化到各自单位球面上，再证明归一化后的逐项乘积总和不超过 $1$。因此Hölder不等式本质上是在说：互为共轭的两个单位球之间，存在一种恰好匹配的配对规则。

几何上还可以把它看成“支撑超平面”的问题。固定 $vc(y)$ 以后，集合
$
  {vc(x) in RR^n : sum_(i = 1)^n x_i y_i = c}
$
是一族彼此平行的超平面。随着 $c$ 增大，这族超平面向外平移；而Hölder不等式说明，当 $vc(x)$ 被限制在 $p$ 单位球内时，能够碰到的最大 $c$ 正好是 $norm(vc(y))_q$。也就是说，$q$ 范数正是在测量这个超平面能把 $p$ 单位球“顶”到多远。

#corollary[Cauchy-Schwarz不等式][
  对任意 $vc(x), vc(y) in RR^n$，都有
  $
    sum_(i = 1)^n abs(x_i y_i) <= norm(vc(x))_2 norm(vc(y))_2
  $
]

它只是Hölder不等式在 $p = q = 2$ 时的特例，但因为最常用，所以通常单独命名。在线性代数里，几乎所有与内积、投影、正交分解有关的基本估计，都会反复用到它。

几何上，Cauchy-Schwarz不等式说明：两个向量的内积不会超过它们长度的乘积。也就是说，内积真正测到的是“长度乘上方向对齐程度”。当两个向量同向或反向时，对齐程度最大，于是最接近等号；当它们正交时，内积则降到 $0$。

在欧氏空间里，这一点还能写成熟悉的公式
$
  vc(x)^"T" vc(y) = norm(vc(x))_2 norm(vc(y))_2 cos theta
$
所以Cauchy-Schwarz不等式其实只是
$
  abs(cos theta) <= 1
$
的代数版本。正因为 $2$ 范数与内积完全兼容，欧氏几何里的角度、投影、正交这些概念才会如此自然。

== Minkowski不等式与单位球凸性

#theorem[Minkowski不等式][
  对任意 $1 <= p <= oo$ 与任意 $vc(x), vc(y) in RR^n$，都有
  $
    norm(vc(x) + vc(y))_p <= norm(vc(x))_p + norm(vc(y))_p
  $
]

这就是 $p$ 范数的三角不等式。前面虽然已经把 $norm(·)_p$ 当作常见范数使用，但真正支撑这一点的正是Minkowski不等式。

如果把 $norm(vc(x))_p$ 看成向量 $vc(x)$ 的长度，那么Minkowski不等式表达的仍然是最熟悉的几何直觉：两段位移首尾相接以后，总长度不会超过分别走这两段的长度之和。区别只在于，这里的“长度”未必是欧氏长度，而是更一般的 $p$ 长度。

当 $p = 1$ 时，结论就是
$
  sum_(i = 1)^n abs(x_i + y_i) <= sum_(i = 1)^n (abs(x_i) + abs(y_i)) = norm(vc(x))_1 + norm(vc(y))_1
$
当 $p = oo$ 时，则直接由逐坐标估计
$
  abs(x_i + y_i) <= abs(x_i) + abs(y_i)
$
得到
$
  norm(vc(x) + vc(y))_oo <= norm(vc(x))_oo + norm(vc(y))_oo
$

下面设 $1 < p < oo$。若 $vc(x) + vc(y) = 0$，结论显然成立。记与 $p$ 共轭的指数为 $q$，并令
$
  z_i = abs(x_i + y_i)^(p - 1)
$
则
$
  norm(vc(x) + vc(y))_p^p = sum_(i = 1)^n abs(x_i + y_i)^p = sum_(i = 1)^n abs(x_i + y_i) z_i
$
再用三角不等式与Hölder不等式，得到
$
  norm(vc(x) + vc(y))_p^p
  <= sum_(i = 1)^n abs(x_i) z_i + sum_(i = 1)^n abs(y_i) z_i
  <= norm(vc(x))_p norm(vc(z))_q + norm(vc(y))_p norm(vc(z))_q
$
而由于 $q (p - 1) = p$，有
$
  norm(vc(z))_q = (sum_(i = 1)^n abs(x_i + y_i)^(q (p - 1)))^(1 / q) = (sum_(i = 1)^n abs(x_i + y_i)^p)^(1 / q) = norm(vc(x) + vc(y))_p^(p - 1)
$
因此
$
  norm(vc(x) + vc(y))_p^p <= (norm(vc(x))_p + norm(vc(y))_p) norm(vc(x) + vc(y))_p^(p - 1)
$
若 $norm(vc(x) + vc(y))_p != 0$，两边约去 $norm(vc(x) + vc(y))_p^(p - 1)$，便得到结论。

从几何上看，Minkowski不等式还在说明一件更深的事：当 $p >= 1$ 时，$p$ 范数的单位球是凸的。因为若 $norm(vc(x))_p <= 1$ 且 $norm(vc(y))_p <= 1$，那么对任意 $0 <= theta <= 1$，由Minkowski不等式与齐次性可得
$
  norm(theta vc(x) + (1 - theta) vc(y))_p <= theta norm(vc(x))_p + (1 - theta) norm(vc(y))_p <= 1
$
这说明连接单位球内任意两点的线段仍留在单位球内。也正因为如此，$p >= 1$ 时得到的才是真正的范数几何；而 $0 < p < 1$ 时，单位球会失去凸性，三角不等式也会失败。

在 $RR^2$ 里，这种几何差别尤其直观：

+ $p = 1$ 时，单位球是菱形，尖角正对坐标轴。
+ $p = 2$ 时，单位球是圆盘，完全各向同性。
+ $p = oo$ 时，单位球是正方形，边与坐标轴平行。
+ 当 $1 < p < 2$ 时，边界比圆更“尖”；当 $2 < p < oo$ 时，边界比圆更“平”。

因此，改变 $p$ 的过程，可以理解成单位球在菱形、圆盘、正方形之间连续变形的过程。Minkowski不等式说的就是：这些形状虽然不同，但只要它们仍然凸，就还能担当“长度”的角色。

== 范数与凸体的对应

#theorem[有限维空间里范数对应中心对称凸体][
  设 $V$ 是有限维实向量空间。

  + 若 $norm(·)$ 是 $V$ 上的范数，则其单位球
    $
      B = {vc(x) in V : norm(vc(x)) <= 1}
    $
    是一个以原点为中心的凸体：它是凸的、中心对称的，并且原点是其内点。

  + 反过来，若 $K subset V$ 是一个以原点为中心的凸体，即 $K$ 是凸集、$K = -K$，并且 $0$ 是其内点，则
    $
      norm(vc(x))_K = inf {t > 0 : vc(x) in t K}
    $
    定义了 $V$ 上的一个范数。
]

这一定理非常重要，因为它告诉我们：在有限维空间里，研究范数与研究“原点附近长什么样的中心对称凸体”本质上是同一回事。范数给出单位球，单位球反过来又决定范数。

先看第一部分。单位球的凸性已经由Minkowski不等式说明了。中心对称性则来自齐次性，因为
$
  norm(- vc(x)) = abs(-1) norm(vc(x)) = norm(vc(x))
$
所以 $vc(x) in B$ 当且仅当 $- vc(x) in B$。而 $0$ 是内点，则是因为有限维空间里范数连续；若取任意基并与 $RR^n$ 识别，便可知存在常数 $C > 0$ 使得
$
  norm(vc(x)) <= C norm(vc(x))_2
$
于是只要 $norm(vc(x))_2 < 1 / C$，就有 $norm(vc(x)) < 1$，说明原点附近一整团欧氏小球都落在 $B$ 内。

第二部分说明怎样从几何形状反推出范数。定义中的 $norm(·)_K$ 称为 $K$ 的Minkowski泛函，也叫规范函数。它的意义是：从原点出发，沿着向量 $vc(x)$ 的方向走出去，要把单位凸体 $K$ 放大多少倍，才刚好能碰到 $vc(x)$。因此 $norm(vc(x))_K$ 不是在“算公式”，而是在测量 $vc(x)$ 相对于几何体 $K$ 的径向位置。

这个定义为什么自然，可以直接从几个简单形状看出来：

+ 若 $K$ 是欧氏圆盘，那么 $norm(·)_K$ 就是 $2$ 范数。
+ 若 $K$ 是菱形，那么 $norm(·)_K$ 就是 $1$ 范数。
+ 若 $K$ 是与坐标轴平行的正方形，那么 $norm(·)_K$ 就是 $oo$ 范数。

因此，选择范数其实就是选择单位球的形状；而改变范数，就是在改变空间里“哪个方向更贵、哪个方向更便宜”的几何规则。

#connection[范数由单位球唯一决定][
  只要知道单位球 $B$，就能通过
  $
    norm(vc(x)) = inf {t > 0 : vc(x) in t B}
  $
  恢复原来的范数。因此有限维空间中的范数，不妨直接看成一类以原点为中心的凸体。
]

这也解释了为什么前面会反复强调单位球的形状。圆盘、菱形、正方形看起来只是三种不同图形，但在线性代数里，它们其实代表了三种不同的长度理论。很多优化问题之所以呈现出不同的稀疏性、角点结构或稳定性，本质上就是因为背后的单位球几何不同。

#connection[$p$ 范数确实满足三条公理][
  对 $1 <= p <= oo$，函数 $norm(·)_p$ 的非负性与齐次性都是直接可见的，而三角不等式正由Minkowski不等式给出。因此 $RR^n$ 上的 $p$ 范数确实都是合法的向量范数。
]

== $p$ 范数的比较与单调性

#theorem[$p$ 范数的单调性与维数估计][
  设 $1 <= p <= q <= oo$，则对任意 $vc(x) in RR^n$ 都有
  $
    norm(vc(x))_q <= norm(vc(x))_p <= n^(1 / p - 1 / q) norm(vc(x))_q
  $
  其中约定 $1 / oo = 0$。
]

第一条不等式说明：当 $p$ 增大时，$p$ 范数不会变大；第二条不等式说明：在有限维空间里，它们虽不相等，但至多差一个显式的维数因子。

这两条结论背后的直觉非常值得记住。$p$ 越小，越倾向于把许多坐标的贡献累加起来，所以更“在意整体总量”；$p$ 越大，越倾向于让最大的那几个坐标主导结果，所以更“在意峰值”。因此当 $p$ 从 $1$ 增长到 $oo$ 时，范数会逐渐从“总和视角”过渡到“最大值视角”。

如果把这个结论翻译成几何语言，那就是：随着 $p$ 增大，单位球
$
  B_p = {vc(x) in RR^n : norm(vc(x))_p <= 1}
$
会逐渐变大。因为 $norm(vc(x))_q <= norm(vc(x))_p$ 意味着
$
  B_p subset.eq B_q quad (1 <= p <= q <= oo)
$
所以在二维里就会看到
$
  B_1 subset.eq B_2 subset.eq B_oo
$
也就是菱形包含在圆盘内，圆盘又包含在正方形内。范数数值越大，对应的单位球反而越小；范数数值越小，对应的单位球反而越大。这两种说法是同一件事的代数与几何两面。

先证
$
  norm(vc(x))_q <= norm(vc(x))_p
$
若 $q < oo$ 且 $vc(x) != 0$，令
$
  a_i = abs(x_i) / norm(vc(x))_p
$
则 $0 <= a_i <= 1$，并且
$
  sum_(i = 1)^n a_i^p = 1
$
由于 $p <= q$ 且 $0 <= a_i <= 1$，有 $a_i^q <= a_i^p$，于是
$
  sum_(i = 1)^n a_i^q <= 1
$
也就是
$
  norm(vc(x))_q <= norm(vc(x))_p
$
若 $q = oo$，则每个分量都满足 $abs(x_i) <= norm(vc(x))_p$，所以也有
$
  norm(vc(x))_oo <= norm(vc(x))_p
$

再证
$
  norm(vc(x))_p <= n^(1 / p - 1 / q) norm(vc(x))_q
$
若 $p = q$，这就是恒等式。下面只需讨论 $p < q$ 的情形。

先设 $p < q < oo$，并把Hölder不等式应用于向量
$
  (abs(x_1)^p, dots, abs(x_n)^p)
$
与
$
  (1, dots, 1)
$
取指数
$
  r = q / p, quad s = q / (q - p)
$
可知 $1 / r + 1 / s = 1$，因此
$
  sum_(i = 1)^n abs(x_i)^p <= (sum_(i = 1)^n abs(x_i)^(p r))^(1 / r) (sum_(i = 1)^n 1^s)^(1 / s)
$
也就是
$
  norm(vc(x))_p^p <= norm(vc(x))_q^p n^(1 - p / q)
$
两边取 $p$ 次方根便得
$
  norm(vc(x))_p <= n^(1 / p - 1 / q) norm(vc(x))_q
$
若 $q = oo$，则由 $abs(x_i) <= norm(vc(x))_oo$ 可得
$
  norm(vc(x))_p^p = sum_(i = 1)^n abs(x_i)^p <= sum_(i = 1)^n norm(vc(x))_oo^p = n norm(vc(x))_oo^p
$
故同样成立。

维数因子 $n^(1 / p - 1 / q)$ 也不是凭空冒出来的，它正是在衡量“许多坐标一起贡献”与“只有最大坐标贡献”之间的差距。最典型的例子是
$
  vc(x) = (1, dots, 1)^"T" in RR^n
$
这时
$
  norm(vc(x))_p = n^(1 / p), quad norm(vc(x))_q = n^(1 / q)
$
所以
$
  norm(vc(x))_p = n^(1 / p - 1 / q) norm(vc(x))_q
$
恰好达到上界。这说明定理中的常数不仅正确，而且通常已经是最好的量级。

把这一定理代入 $p = 1, q = 2$ 或 $p = 2, q = oo$，就立刻恢复前面已经见过的
$
  norm(vc(x))_2 <= norm(vc(x))_1 <= sqrt(n) norm(vc(x))_2
$
与
$
  norm(vc(x))_oo <= norm(vc(x))_2 <= sqrt(n) norm(vc(x))_oo
$
等比较式。也就是说，前面那些常见不等式其实只是一般 $p$ 范数比较定理的低维截面。

换个角度看，同一个向量如果有很多个中等大小的坐标，那么 $norm(·)_1$ 往往明显大于 $norm(·)_2$，而 $norm(·)_2$ 又往往大于 $norm(·)_oo$；如果向量几乎只有一个坐标特别大，其余都很小，那么这几种范数就会彼此接近。因此不同范数的差异，本质上反映的是“能量分布得有多分散”。

#connection[这些不等式为什么重要][
  Young不等式负责处理乘积，Hölder不等式负责处理求和，Minkowski不等式负责处理加法，而 $p$ 范数比较定理则告诉我们不同范数之间可以怎样换算。后面研究诱导矩阵范数、条件数、误差传播以及最优化中的正则项时，这条逻辑链会不断重复出现。
]

= 矩阵范数

向量范数衡量的是”一个向量有多大”，矩阵范数则衡量”一个线性变换有多强”或者”一个矩阵的整体规模有多大”。这两种说法看似不同，其实对应着看矩阵的两种基本视角：

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
  + $ norm(alpha mt(A)) = abs(alpha) norm(mt(A)) $
  + $ norm(mt(A) + mt(B)) <= norm(mt(A)) + norm(mt(B)) $
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

其中 $norm(mt(A))_"F"$ 称为Frobenius范数。它就是把矩阵所有元素排成一个长向量以后得到的欧氏范数，所以它对每个元素一视同仁，几何上最自然，计算上也最方便。

== 诱导矩阵范数

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

== 常见诱导范数与谱范数

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

== 其他常见性质

#caveat[不是每个矩阵范数都与乘法相容][
  元素型范数一定是矩阵空间上的合法范数，但不一定满足
  $
    norm(mt(A) mt(B)) <= norm(mt(A)) norm(mt(B))
  $
  这样的次乘性。

  例如最大元素范数 $norm(·)_"max"$ 一般只满足带维数因子的估计，而不一定满足常数恰好为 $1$ 的次乘性。因此当我们关心矩阵连乘、幂迭代、稳定性与误差传播时，通常更偏爱诱导范数或Frobenius范数。
]

#proposition[Frobenius范数的若干性质][
  对任意 $mt(A), mt(B) in RR^(m times n)$，都有
  + $ norm(mt(A))_"F"^2 = sum_(i = 1)^m sum_(j = 1)^n abs(a_(i j))^2 $
  + $ norm(mt(A))_2 <= norm(mt(A))_"F" $
  + 若 $rank(mt(A)) = r$，则 $norm(mt(A))_"F" <= sqrt(r) norm(mt(A))_2$
]

这些关系说明：谱范数只关心最大的拉伸方向，而Frobenius范数则把所有方向上的能量累加起来，因此通常更大，但又不会比谱范数大得没有边界。

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

= 矩阵范数不等式

向量范数那一节的主线是：先控制乘积，再控制求和，再控制加法。到了矩阵这里，这条主线并没有中断，只是换了一种外形。因为矩阵本质上是在把一个向量变成另一个向量，所以绝大多数矩阵范数不等式，最终都可以追溯到前面已经建立的向量不等式：

+ Hölder不等式控制双线性型 $vc(y)^"T" mt(A) vc(x)$。
+ Minkowski不等式保证诱导范数与乘法、加法相容。
+ $p$ 范数比较定理把不同诱导范数之间联系起来。
+ Cauchy-Schwarz不等式在矩阵层面则变成了Frobenius内积的不等式。

因此，矩阵范数的不等式并不是一套全新的技术，而更像是把前面的向量理论“升维”到线性变换上的结果。

== 对偶范数与对偶表示

#definition[对偶范数][
  设 $norm(·)_a$ 是 $RR^n$ 上的向量范数。定义它的对偶范数为
  $
    norm(vc(y))_(a^*) = max_(norm(vc(x))_a = 1) abs(vc(y)^"T" vc(x))
  $
  也可等价写成
  $
    norm(vc(y))_(a^*) = max_(vc(x) != 0) abs(vc(y)^"T" vc(x)) / (norm(vc(x))_a)
  $
]

这一定义正是前面Hölder不等式的抽象版本。它在问：当 $vc(y)$ 被看成线性函数
$
  vc(x) mapsto vc(y)^"T" vc(x)
$
时，它在 $a$ 范数单位球上能取到多大的值。

在 $p$ 范数情形，这个定义会回到熟悉的结论：若 $1 <= p <= oo$ 与 $q$ 互为共轭指数，则
$
  norm(·)_(p^*) = norm(·)_q
$
也就是说，前一节里的Hölder不等式，本质上就是“线性函数在单位球上的最大值由对偶范数给出”。

#theorem[诱导矩阵范数的对偶表示][
  设 $norm(·)_a$ 是 $RR^n$ 上的范数，$norm(·)_b$ 是 $RR^m$ 上的范数，它们的对偶范数分别记为 $norm(·)_(a^*)$ 与 $norm(·)_(b^*)$。则对任意 $mt(A) in RR^(m times n)$，都有
  $
    norm(mt(A))_((b,a)) = max_(norm(vc(x))_a = 1, norm(vc(y))_(b^*) = 1) abs(vc(y)^"T" mt(A) vc(x))
  $
  并且
  $
    norm(mt(A))_((b,a)) = norm(mt(A)^"T")_((a^*, b^*))
  $
]

这个公式非常重要，因为它把“矩阵作用于向量”的问题，转成了“矩阵夹在两个向量之间”的双线性型问题。于是前面关于Hölder与对偶单位球的几何直觉，就可以直接搬到矩阵上来。

证明从对偶范数定义出发即可。对任意固定的 $vc(x)$，有
$
  norm(mt(A) vc(x))_b = max_(norm(vc(y))_(b^*) = 1) abs(vc(y)^"T" mt(A) vc(x))
$
因此
$
  norm(mt(A))_((b,a))
  = max_(norm(vc(x))_a = 1) norm(mt(A) vc(x))_b
  = max_(norm(vc(x))_a = 1, norm(vc(y))_(b^*) = 1) abs(vc(y)^"T" mt(A) vc(x))
$
再把 $vc(y)^"T" mt(A) vc(x)$ 改写成 $(mt(A)^"T" vc(y))^"T" vc(x)$，并再次使用对偶范数定义，就得到
$
  norm(mt(A))_((b,a)) = max_(norm(vc(y))_(b^*) = 1) norm(mt(A)^"T" vc(y))_(a^*) = norm(mt(A)^"T")_((a^*, b^*))
$

#corollary[转置与常见诱导范数][
  对任意矩阵 $mt(A)$，都有
  $
    norm(mt(A))_1 = norm(mt(A)^"T")_oo, quad
    norm(mt(A))_oo = norm(mt(A)^"T")_1, quad
    norm(mt(A))_2 = norm(mt(A)^"T")_2
  $
]

这说明列和范数与行和范数本来就是一对对偶量，而谱范数之所以在转置下不变，本质上是因为欧氏几何本身就是自对偶的。

#intuition[矩阵不等式的几何图景][
  在诱导范数下，$mt(A)$ 把定义域单位球 $B_a$ 映成值域中的凸体 $mt(A) B_a$。此时 $norm(mt(A))_((b,a))$ 测量的是这个像集在 $b$ 几何下离原点最远的距离，而对偶表示则在说：这个最远距离也可以由支撑超平面去测量。换句话说，一个矩阵有多大，既可以看它把球拉到了多远，也可以看哪些线性函数能把这个像集“顶”到多远。
]

== 次乘性、谱半径与Neumann级数

#theorem[次乘性、幂与条件数的第一层估计][
  设 $norm(·)$ 是一个与矩阵乘法相容的矩阵范数，即满足
  $
    norm(mt(A) mt(B)) <= norm(mt(A)) norm(mt(B))
  $
  则对任意正整数 $k$ 都有
  $
    norm(mt(A)^k) <= norm(mt(A))^k
  $
  若 $mt(A)$ 可逆，则
  $
    1 = norm(mt(I)) <= norm(mt(A)) norm(mt(A)^(-1))
  $
  因而
  $
    kappa(mt(A)) = norm(mt(A)) norm(mt(A)^(-1)) >= 1
  $
]

这组结论是矩阵估计里最基础的一层。它说：若一个矩阵一次作用最多放大 $norm(mt(A))$ 倍，那么连续作用 $k$ 次，最多就放大 $norm(mt(A))^k$ 倍；而一个矩阵与它的逆矩阵不可能同时都很“小”，因为它们合起来必须恢复恒等映射。

对诱导范数来说，$norm(mt(A)^k) <= norm(mt(A))^k$ 的意义尤其直接：每作用一次都至多拉伸 $norm(mt(A))$ 倍，所以连续迭代的最坏放大率至多按指数增长。这正是研究迭代法、离散动力系统与稳定性时最先要看的量。

#theorem[谱半径受次乘性矩阵范数控制][
  设 $norm(·)$ 是任意次乘性矩阵范数，$rho(mt(A))$ 表示 $mt(A)$ 的谱半径，则
  $
    rho(mt(A)) <= norm(mt(A))
  $
]

证明非常短。若 $lambda$ 是 $mt(A)$ 的一个特征值，$vc(x) != 0$ 是对应特征向量，则
$
  abs(lambda) norm(vc(x)) = norm(lambda vc(x)) = norm(mt(A) vc(x)) <= norm(mt(A)) norm(vc(x))
$
故 $abs(lambda) <= norm(mt(A))$。再对所有特征值取最大值即可。

这说明范数给出的不是某个特殊方向上的拉伸，而是对所有特征值的统一上界。特别地，若 $norm(mt(A)) < 1$，那么所有特征值都落在单位圆盘内，矩阵幂 $mt(A)^k$ 就有衰减的可能；因此范数估计常被用来快速判断稳定性。

#theorem[Neumann级数与逆矩阵估计][
  设 $norm(·)$ 是次乘性矩阵范数。若
  $
    norm(mt(A)) < 1
  $
  则 $mt(I) - mt(A)$ 可逆，并且
  $
    (mt(I) - mt(A))^(-1) = sum_(k = 0)^oo mt(A)^k
  $
  同时有估计
  $
    norm((mt(I) - mt(A))^(-1)) <= 1 / (1 - norm(mt(A)))
  $
  与
  $
    norm((mt(I) - mt(A))^(-1) - mt(I)) <= norm(mt(A)) / (1 - norm(mt(A)))
  $
]

这正是标量几何级数
$
  1 + t + t^2 + dots = 1 / (1 - t)
$
在矩阵世界里的对应物。不同之处只在于，标量时只需关心一个数是否小于 $1$，矩阵时则要用范数来统一控制所有方向上的放大效应。

证明思路也完全平行于标量情形。记
$
  mt(S)_N = mt(I) + mt(A) + dots + mt(A)^N
$
则
$
  (mt(I) - mt(A)) mt(S)_N = mt(I) - mt(A)^(N + 1)
$
由次乘性与前面的幂估计可得
$
  norm(mt(A)^(N + 1)) <= norm(mt(A))^(N + 1) -> 0
$
故 $mt(S)_N$ 收敛到逆矩阵。再对级数逐项估计，便得到
$
  norm((mt(I) - mt(A))^(-1)) <= sum_(k = 0)^oo norm(mt(A))^k = 1 / (1 - norm(mt(A)))
$
以及第二个不等式。

== Frobenius内积与乘积估计

#proposition[Frobenius内积与矩阵版Cauchy-Schwarz][
  对任意 $mt(A), mt(B) in RR^(m times n)$，令
  $
    ip(mt(A), mt(B)) = tr(mt(A)^"T" mt(B)) = sum_(i = 1)^m sum_(j = 1)^n a_(i j) b_(i j)
  $
  则
  $
    abs(tr(mt(A)^"T" mt(B))) <= norm(mt(A))_"F" norm(mt(B))_"F"
  $
]

这就是矩阵空间里的Cauchy-Schwarz不等式。它并没有什么神秘之处，因为把矩阵按元素排成一个长向量以后，Frobenius内积就是普通内积，Frobenius范数就是普通欧氏范数。

证明只需把矩阵拉直成向量，直接应用前一节的Cauchy-Schwarz不等式即可。也可以从
$
  norm(mt(A))_"F"^2 = tr(mt(A)^"T" mt(A))
$
出发，把 $RR^(m times n)$ 看成一个欧氏空间。

#proposition[Frobenius范数与矩阵乘积][
  对任意可乘矩阵 $mt(A), mt(B)$，都有
  $
    norm(mt(A) mt(B))_"F" <= norm(mt(A))_2 norm(mt(B))_"F"
  $
  与
  $
    norm(mt(A) mt(B))_"F" <= norm(mt(A))_"F" norm(mt(B))_2
  $
  因而特别有
  $
    norm(mt(A) mt(B))_"F" <= norm(mt(A))_"F" norm(mt(B))_"F"
  $
]

第一条不等式最能体现“矩阵不等式来自向量不等式”的思路。若把 $mt(B)$ 的各列记为 $vc(b)_1, dots, vc(b)_n$，则 $mt(A) mt(B)$ 的各列就是 $mt(A) vc(b)_1, dots, mt(A) vc(b)_n$，所以
$
  norm(mt(A) mt(B))_"F"^2 = sum_(j = 1)^n norm(mt(A) vc(b)_j)_2^2
  <= sum_(j = 1)^n norm(mt(A))_2^2 norm(vc(b)_j)_2^2
  = norm(mt(A))_2^2 norm(mt(B))_"F"^2
$
取平方根便得第一条。第二条只要对转置后的乘积使用第一条即可。

几何上，这说明谱范数控制的是“每一个方向最多被拉长多少”，而Frobenius范数控制的是“所有列向量总能量有多少”。因此用谱范数乘Frobenius范数，就能同时控制单方向放大率与整体能量。

== 常见诱导范数之间的比较

#theorem[常见诱导矩阵范数之间的比较][
  对任意 $mt(A) in RR^(n times n)$，都有
  $
    1 / sqrt(n) norm(mt(A))_oo <= norm(mt(A))_2 <= sqrt(n) norm(mt(A))_oo
  $
  与
  $
    1 / sqrt(n) norm(mt(A))_1 <= norm(mt(A))_2 <= sqrt(n) norm(mt(A))_1
  $
  另外还有
  $
    norm(mt(A))_2 <= sqrt(norm(mt(A))_1 norm(mt(A))_oo)
  $
]

这组不等式正是前一节向量 $1, 2, oo$ 范数比较在矩阵层面的延续。原因也完全一样：先把 $mt(A)$ 作用到向量上，再对输入和输出同时使用向量范数比较。

例如，为证
$
  norm(mt(A))_2 <= sqrt(n) norm(mt(A))_oo
$
对任意 $vc(x) != 0$，由向量范数比较有
$
  norm(mt(A) vc(x))_2 <= sqrt(n) norm(mt(A) vc(x))_oo <= sqrt(n) norm(mt(A))_oo norm(vc(x))_oo <= sqrt(n) norm(mt(A))_oo norm(vc(x))_2
$
再对所有非零 $vc(x)$ 取上确界即可。其余几个比较式同理。

最后一个不等式则可以由前面的转置公式、次乘性与谱半径估计得到：
$
  norm(mt(A))_2^2 = rho(mt(A)^"T" mt(A)) <= norm(mt(A)^"T" mt(A))_1 <= norm(mt(A)^"T")_1 norm(mt(A))_1 = norm(mt(A))_oo norm(mt(A))_1
$
再取平方根便得结论。

如果翻译成几何语言，那么它说的是：虽然用列和、行和、欧氏最长半轴来度量同一个线性变换，看起来像在测三件不同的事，但这些量在有限维里始终不会差得太离谱。前一节里单位球之间的包含关系，在矩阵层面就表现为这些算子范数之间的显式常数比较。

== 残差、误差与条件数

#theorem[残差、误差与条件数][
  设 $mt(A) in RR^(n times n)$ 可逆，精确解 $vc(x)$ 满足
  $
    mt(A) vc(x) = vc(b)
  $
  近似解 $vc(x)_0$ 的残差定义为
  $
    vc(r) = vc(b) - mt(A) vc(x)_0
  $
  则对任意诱导范数都有
  $
    (norm(vc(x) - vc(x)_0)) / (norm(vc(x))) <= kappa(mt(A)) (norm(vc(r))) / (norm(vc(b)))
  $
]

这个不等式几乎把前面所有内容都串了起来。它告诉我们：残差只是方程没有满足到什么程度，而真正关心的解误差，还要再乘上一个由矩阵本身决定的放大因子 $kappa(mt(A))$。因此“残差很小”并不自动意味着“解很准”；只有在条件数不大时，二者才会同步。

证明很直接。由
$
  mt(A) (vc(x) - vc(x)_0) = vc(r)
$
可得
$
  vc(x) - vc(x)_0 = mt(A)^(-1) vc(r)
$
故
$
  norm(vc(x) - vc(x)_0) <= norm(mt(A)^(-1)) norm(vc(r))
$
另一方面，由 $vc(b) = mt(A) vc(x)$ 得
$
  norm(vc(b)) <= norm(mt(A)) norm(vc(x))
$
即
$
  1 / norm(vc(x)) <= norm(mt(A)) / norm(vc(b))
$
两式相乘便得到结论。

== 与向量范数理论的对应

#connection[这一节与向量不等式的对应关系][
  若把前一节和这一节并排看，可以看到非常清楚的对应：

  + Hölder不等式对应双线性型 $vc(y)^"T" mt(A) vc(x)$ 的控制。
  + Cauchy-Schwarz不等式对应Frobenius内积的控制。
  + Minkowski不等式对应诱导范数的三角不等式与次乘性。
  + $p$ 范数比较定理对应不同诱导矩阵范数之间的显式换算。

  也就是说，矩阵范数理论并不是脱离向量范数另起炉灶，而是在“矩阵是线性变换”这个视角下，把前面的几何与估计完整延伸了一遍。
]

因此，研究矩阵范数不等式的核心，不是死记若干公式，而是始终记住两个动作：先用向量不等式控制 $mt(A) vc(x)$ 或 $vc(y)^"T" mt(A) vc(x)$，再对所有可能的方向取最坏情况。这个过程一旦看清楚，许多矩阵估计都会显得顺理成章。
