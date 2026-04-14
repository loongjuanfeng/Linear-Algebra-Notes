#import "../../libs.typ": *
#import "../syms.typ": *

#show: ilm.with(
  title: [Linear Algebra],
  date: datetime.today(),
  author: "Junfeng Lve",
  abstract: [Notes on Chapter 3 of _Linear Algebra for Artificial Intelligence_],
)
#show: setup

= 谱分解

#theorem[谱分解定理][
  设可对角化矩阵 $mt(A)$ 具有 $s$ 个互异特征值 $sigma(mt(A)) = {lambda_1, dots, lambda_s}$，其几何重数分别为 $n_i, (1 <= i <= s)$。则存在且仅存在矩阵 $mt(P)_1, dots, mt(P)_s$，使得
  $
    mt(A) = sum_(i = 1)^s lambda_i mt(P)_i
  $
  且满足如下性质：
  + $ sum_(i = 1)^s mt(P)_i = mt(I) $
  + $ mt(P)_i^2 = mt(P)_i $
  + $ mt(P)_i mt(P)_j = mt(O), i != j $
  + $ rank(mt(P)_i) = n_i $
  这些 $mt(P)_i$ 正是 $mt(A)$ 对应于特征值 $lambda_i$ 的谱投影。
]<谱分解定理>

#proof[谱分解定理][]
由于 $mt(A)$ 可对角化，存在可逆矩阵 $mt(S)$ 使得
$
  mt(A) = mt(S) mt(D) mt(S)^(-1)
$
其中
$
  mt(D) = diag{d_1, dots, d_n}
$
且对于每个 $1 <= i <= s$，特征值 $lambda_i$ 在 $mt(D)$ 的对角线上恰好出现 $n_i$ 次。对每个 $1 <= i <= s$，定义对角矩阵 $mt(E)_i$ 为：在所有满足 $d_k = lambda_i$ 的位置上取 $1$，其余对角元取 $0$。于是
$
  mt(D) = sum_(i = 1)^s lambda_i mt(E)_i
$
且立刻有
+ $ sum_(i = 1)^s mt(E)_i = mt(I) $
+ $ mt(E)_i^2 = mt(E)_i $
+ $ mt(E)_i mt(E)_j = mt(O), i != j $
+ $ rank(mt(E)_i) = n_i $

现在定义
$
  mt(P)_i = mt(S) mt(E)_i mt(S)^(-1)
$
则
$
  mt(A) = mt(S) mt(D) mt(S)^(-1)
  = sum_(i = 1)^s lambda_i mt(S) mt(E)_i mt(S)^(-1)
  = sum_(i = 1)^s lambda_i mt(P)_i
$
这就得到所需分解。

其余性质由相似变换直接得到：
$
  sum_(i = 1)^s mt(P)_i
  = mt(S) (sum_(i = 1)^s mt(E)_i) mt(S)^(-1)
  = mt(S) mt(I) mt(S)^(-1)
  = mt(I)
$
$
  mt(P)_i^2
  = mt(S) mt(E)_i mt(S)^(-1) mt(S) mt(E)_i mt(S)^(-1)
  = mt(S) mt(E)_i^2 mt(S)^(-1)
  = mt(P)_i
$
若 $i != j$，则
$
  mt(P)_i mt(P)_j
  = mt(S) mt(E)_i mt(E)_j mt(S)^(-1)
  = mt(O)
$
此外相似变换保持秩不变，因此
$
  rank(mt(P)_i) = rank(mt(E)_i) = n_i
$
最后，$mt(P)_i$ 的像空间恰为 $lambda_i$ 对应的特征子空间，所以这些谱投影由 $mt(A)$ 唯一确定。

#example[矩阵的指数函数][
  $
    e^mt(A) = & sum_(n = 0)^oo (mt(A)^n) / n! \
            = & sum_(n = 0)^oo 1/n! (sum_(i = 1)^s lambda_i mt(P)_i)^n \
            = & sum_(n = 0)^oo 1/n! sum_(i = 1)^s lambda_i^n mt(P)_i \
            = & sum_(i = 1)^s (sum_(n = 0)^oo lambda_i^n/n!) mt(P)_i \
            = & sum_(i = 1)^s e^lambda_i mt(P)_i
  $
]

#intuition[矩阵的指数函数][]
标量函数 $e^x$ 刻画的是连续增长；矩阵函数 $e^mt(A)$ 则刻画由线性变换 $mt(A)$ 生成的连续演化。若向量 $x(t)$ 满足微分方程
$
  x'(t) = mt(A) x(t)
$
则其解为
$
  x(t) = e^(t mt(A)) x(0)
$
因而 $e^mt(A)$ 可以看成是把 $mt(A)$ 这个“无穷小作用规律”积累到时间 $t = 1$ 之后得到的总效果。

从谱分解
$
  mt(A) = sum_(i = 1)^s lambda_i mt(P)_i
$
来看，空间被拆成若干个特征子空间，而 $mt(A)$ 在第 $i$ 个特征子空间上的作用仅仅是乘上标量 $lambda_i$。因此 $e^mt(A)$ 在该子空间上的作用就是乘上 $e^lambda_i$，也即
$
  e^mt(A) = sum_(i = 1)^s e^lambda_i mt(P)_i
$
所以矩阵指数函数的直觉就是：先用谱投影把空间拆开，再在每个子空间上分别做普通指数函数。

#theorem[实对称矩阵的基本性质][
  设 $mt(A)$ 是实对称矩阵。

  + 若 $vc(x) != 0$ 且 $mt(A) vc(x) = lambda vc(x)$，则 $lambda in RR$。
  + 若 $vc(x), vc(y) != 0$ 分别是属于不同特征值 $lambda != mu$ 的特征向量，即
    $
      mt(A) vc(x) = lambda vc(x), quad mt(A) vc(y) = mu vc(y)
    $
    则 $ip(vc(x), vc(y)) = 0$。
]

#proof[实对称矩阵的基本性质][]
先证特征值是实数。若 $mt(A) vc(x) = lambda vc(x)$，则
$
  vc(x)^"T" mt(A) vc(x) = lambda vc(x)^"T" vc(x)
$
由于 $mt(A)$ 是实对称矩阵，$vc(x)^"T" mt(A) vc(x)$ 是实数；又因为 $vc(x) != 0$，所以
$
  vc(x)^"T" vc(x) > 0
$
从而
$
  lambda = (vc(x)^"T" mt(A) vc(x)) / (vc(x)^"T" vc(x)) in RR
$

再证不同特征值对应的特征向量正交。由
$
  mt(A) vc(x) = lambda vc(x), quad mt(A) vc(y) = mu vc(y)
$
可得
$
  lambda vc(x)^"T" vc(y)
  = (mt(A) vc(x))^"T" vc(y)
  = vc(x)^"T" mt(A)^"T" vc(y)
  = vc(x)^"T" mt(A) vc(y)
  = mu vc(x)^"T" vc(y)
$
因此
$
  (lambda - mu) vc(x)^"T" vc(y) = 0
$
而 $lambda != mu$，故
$
  vc(x)^"T" vc(y) = 0
$
也即 $ip(vc(x), vc(y)) = 0$。

#theorem[实对称矩阵的谱分解][
  设 $mt(A)$ 是实对称矩阵，则存在正交矩阵 $mt(S)$ 与实对角矩阵 $mt(D)$，使得
  $
    mt(A) = mt(S) mt(D) mt(S)^"T"
  $
  设 $lambda_1, dots, lambda_s$ 是 $mt(A)$ 的互异特征值，$mt(E)_i$ 是 $mt(D)$ 中对应于特征值 $lambda_i$ 的对角投影，则
  $
    mt(A) = sum_(i = 1)^s lambda_i mt(P)_i, quad mt(P)_i = mt(S) mt(E)_i mt(S)^"T"
  $
  并且
  $ mt(P)_i^"T" = mt(P)_i $

  因而对任意 $vc(alpha), vc(beta) in RR^n$，当 $i != j$ 时，
  $
    ip(mt(P)_i vc(alpha), mt(P)_j vc(beta))
    = vc(alpha)^"T" mt(P)_i^"T" mt(P)_j vc(beta)
    = 0
  $
  所以不同特征值对应的特征子空间两两正交。
]

#proof[实对称矩阵的谱分解][]
由上一定理可知：$mt(A)$ 的特征值全为实数，且属于不同特征值的特征向量彼此正交。设 $lambda_1, dots, lambda_s$ 是 $mt(A)$ 的互异特征值，$V_i$ 是对应的特征子空间，$dim V_i = n_i$。

在每个 $V_i$ 中取一组标准正交基
$
  vc(q)_(i,1), dots, vc(q)_(i,n_i)
$
由于不同特征子空间彼此正交，把这些向量合在一起便得到 $RR^n$ 的一组标准正交基。令
$
  mt(S) = [vc(q)_(1,1), dots, vc(q)_(1,n_1), vc(q)_(2,1), dots, vc(q)_(s,n_s)]
$
则 $mt(S)$ 是正交矩阵。再令
$
  mt(D) = diag{d_1, dots, d_n}
$
其中每个特征值 $lambda_i$ 在对角线上恰好重复 $n_i$ 次。因为每一列都是 $mt(A)$ 的特征向量，所以
$
  mt(A) mt(S) = mt(S) mt(D)
$
右乘 $mt(S)^"T"$，便得到
$
  mt(A) = mt(S) mt(D) mt(S)^"T"
$
这就说明实对称矩阵可以正交对角化。

对每个 $1 <= i <= s$，令 $mt(E)_i$ 为 $mt(D)$ 中对应于特征值 $lambda_i$ 的对角投影，则
$
  mt(D) = sum_(i = 1)^s lambda_i mt(E)_i
$
从而
$
  mt(A) = mt(S) mt(D) mt(S)^"T"
  = sum_(i = 1)^s lambda_i mt(S) mt(E)_i mt(S)^"T"
  = sum_(i = 1)^s lambda_i mt(P)_i
$
其中
$
  mt(P)_i = mt(S) mt(E)_i mt(S)^"T"
$
因此 $mt(A)$ 具有谱分解。

又因为 $mt(E)_i^"T" = mt(E)_i$，故
$
  mt(P)_i^"T"
  = (mt(S) mt(E)_i mt(S)^"T")^"T"
  = mt(S) mt(E)_i^"T" mt(S)^"T"
  = mt(P)_i
$
所以每个谱投影都是对称矩阵。并且当 $i != j$ 时，$mt(E)_i mt(E)_j = mt(O)$，于是
$
  mt(P)_i mt(P)_j
  = mt(S) mt(E)_i mt(E)_j mt(S)^"T"
  = mt(O)
$
故对任意 $vc(alpha), vc(beta) in RR^n$，有
$
  ip(mt(P)_i vc(alpha), mt(P)_j vc(beta))
  = vc(alpha)^"T" mt(P)_i^"T" mt(P)_j vc(beta)
  = vc(alpha)^"T" mt(P)_i mt(P)_j vc(beta)
  = 0
$
这说明不同特征值对应的特征子空间两两正交。

#definition[广义对角阵][
  称
  $
    mat(d_1; , dots.down; , , d_n; , mt(O))_(m times n) = diag{d_1, dots, d_n}_(m times n), m >= n \
    mat(d_1; , dots.down, , mt(O); , , d_m)_(m times n) = diag{d_1, dots, d_n}_(m times n), m <= n
  $
  为广义对角阵。
]

#theorem[关于矩阵的秩][
  + $ rank(mt(A)) = rank(mt(A)^"T") = rank(mt(A) mt(A)^"T") = rank(mt(A)^"T" mt(A)) $
  + $
      det(lambda mt(I)_m - mt(A)_(m times n) mt(B)_(n times m)) lambda^n = det(lambda mt(I)_n - mt(B)_(n times m) mt(A)_(m times n)) lambda^m
    $
]

#motivation[Schur 补有什么用][
  当矩阵天然写成分块形式时，我们常常希望把对整个大矩阵的研究化简为对某个较小矩阵的研究。Schur 补正是完成这种“降维”的工具：它能把分块矩阵的行列式、可逆性乃至很多谱性质，转化为某个角块及其补块的性质。

  在本节中引入Schur补，主要是为了处理
  $
    mat(mt(I)_m, mt(A); mt(B), lambda mt(I)_n)
  $
  这样的分块矩阵，并由此比较 $mt(A) mt(B)$ 与 $mt(B) mt(A)$ 的特征多项式。这样就能说明它们具有相同的非零特征值，这正是后面奇异值分解的重要基础。
]

#definition[Schur补][
  设分块矩阵
  $
    mt(M) = mat(mt(X), mt(Y); mt(Z), mt(W)) = mat(mt(I), mt(O); mt(Z) mt(X)^(-1), mt(I)) mat(mt(X), mt(O); mt(O), mt(W) - mt(Z) mt(X)^(-1) mt(Y)) mat(mt(I), mt(Y) mt(X)^(-1); mt(O), mt(I))
  $
  其中 $mt(X)$ 可逆，则称
  $
    mt(W) - mt(Z) mt(X)^(-1) mt(Y)
  $
  为 $mt(X)$ 在 $mt(M)$ 中的Schur补。类似地，若 $mt(W)$ 可逆，则
  $
    mt(X) - mt(Y) mt(W)^(-1) mt(Z)
  $
  称为 $mt(W)$ 在 $mt(M)$ 中的Schur补。

  相应地有行列式公式
  $
    det(mt(M)) = det(mt(X)) det(mt(W) - mt(Z) mt(X)^(-1) mt(Y))
  $
  与
  $
    det(mt(M)) = det(mt(W)) det(mt(X) - mt(Y) mt(W)^(-1) mt(Z))
  $
]

#proof[关于矩阵的秩][]
对于第一条结论，先证明
$
  rank(mt(A)^"T" mt(A)) = rank(mt(A))
$
对任意向量 $vc(x)$，若 $mt(A)^"T" mt(A) vc(x) = 0$，则
$
  vc(x)^"T" mt(A)^"T" mt(A) vc(x) = (mt(A) vc(x))^"T" (mt(A) vc(x)) = 0
$
从而 $mt(A) vc(x) = 0$。反过来若 $mt(A) vc(x) = 0$，则显然 $mt(A)^"T" mt(A) vc(x) = 0$。因此 $mt(A)^"T" mt(A)$ 与 $mt(A)$ 的零空间相同。由于它们都有 $n$ 列，由秩-零化度定理可知
$
  rank(mt(A)^"T" mt(A)) = rank(mt(A))
$
将上式中的 $mt(A)$ 换成 $mt(A)^"T"$，便得到
$
  rank(mt(A) mt(A)^"T") = rank(mt(A)^"T")
$
而 $rank(mt(A)) = rank(mt(A)^"T")$ 是行秩等于列秩这一基本事实，所以
$
  rank(mt(A)) = rank(mt(A)^"T") = rank(mt(A) mt(A)^"T") = rank(mt(A)^"T" mt(A))
$

对于第二条结论，考虑分块矩阵
$
  mt(M) = mat(mt(I)_m, mt(A); mt(B), lambda mt(I)_n)
$
先把左上角的 $mt(I)_m$ 作为Schur补的基块，则
$
  det(mt(M)) = det(mt(I)_m) det(lambda mt(I)_n - mt(B) mt(A)) = det(lambda mt(I)_n - mt(B) mt(A))
$
再把右下角的 $lambda mt(I)_n$ 作为基块。对 $lambda != 0$，有
$
  det(mt(M)) = det(lambda mt(I)_n) det(mt(I)_m - mt(A) (lambda mt(I)_n)^(-1) mt(B))
$
于是
$
  det(mt(M)) = lambda^n det(mt(I)_m - lambda^(-1) mt(A) mt(B)) = lambda^(n - m) det(lambda mt(I)_m - mt(A) mt(B))
$
将两次计算所得的 $det(mt(M))$ 相等，便有
$
  det(lambda mt(I)_n - mt(B) mt(A)) = lambda^(n - m) det(lambda mt(I)_m - mt(A) mt(B))
$
两边同乘 $lambda^m$，得到
$
  det(lambda mt(I)_m - mt(A) mt(B)) lambda^n = det(lambda mt(I)_n - mt(B) mt(A)) lambda^m
$
该等式对一切 $lambda != 0$ 成立，而两边都是关于 $lambda$ 的多项式，因此它对所有 $lambda$ 都成立。

#idea[奇异值分解][
  对一般实矩阵 $mt(A)$，虽然它未必能像对称矩阵那样直接正交对角化，但可以先研究
  $
    mt(A)^"T" mt(A)
  $
  它总是实对称半正定矩阵，因此可以谱分解。设其正特征值为 $lambda_1, dots, lambda_r$，对应标准正交特征向量为 $vc(v)_1, dots, vc(v)_r$，再令
  $
    sigma_i = sqrt(lambda_i), quad vc(u)_i = 1/sigma_i mt(A) vc(v)_i
  $
  就能在值域一侧得到另一组标准正交向量。这样便把 $mt(A)$ 分解成：先用 $mt(V)^"T"$ 在定义域中选取合适的正交坐标，再用对角矩阵 $mt(Sigma)$ 沿坐标轴伸缩，最后用 $mt(U)$ 把结果旋转到陪域中的正确方向。
]

#intuition[奇异值分解][]
谱分解适用于“同一个空间上的对称作用”，而奇异值分解处理的是更一般的线性映射 $mt(A): RR^n -> RR^m$。它告诉我们：任意线性映射都可以拆成三个步骤——先在输入空间做一次正交变换，把最重要的方向对齐；再沿这些互相正交的方向分别拉伸或压缩，拉伸倍数就是奇异值；最后在输出空间再做一次正交变换。

所以奇异值分解的几何图像是：单位球先被旋转，再被压成一个主轴互相正交的椭球，最后再整体旋转到输出空间中。奇异值越大，说明 $mt(A)$ 在对应方向上的放大作用越强；奇异值为 $0$ 的方向则被压扁到零，这些方向正对应于零空间。

#theorem[矩阵的奇异值分解（singular value decomposition）][
  设 $mt(A)$ 是 $m times n$ 实矩阵，$rank(mt(A)) = r$。则存在正交矩阵
  $
    mt(U) in RR^(m times m), quad mt(V) in RR^(n times n)
  $
  与广义对角阵
  $
    mt(Sigma) = diag{sigma_1, dots, sigma_r}_(m times n), quad sigma_1 >= dots >= sigma_r > 0
  $
  使得
  $
    mt(A) = mt(U) mt(Sigma) mt(V)^"T"
  $

  其中 $sigma_1, dots, sigma_r$ 称为 $mt(A)$ 的奇异值，它们恰好是 $mt(A)^"T" mt(A)$ 的全部正特征值的平方根；等价地，也是 $mt(A) mt(A)^"T"$ 的全部正特征值的平方根。

  若把零也补到对角线上，则可写成
  $
    mt(Sigma) = diag{sigma_1, dots, sigma_r, 0, dots, 0}_(m times n)
  $
  从而任意实矩阵都可以分解为两个正交变换与一个非负广义对角阵的乘积。
]

#proof[矩阵的奇异值分解（singular value decomposition）][]
若 $r = 0$，则 $mt(A) = mt(O)$，任取正交矩阵 $mt(U), mt(V)$，再取 $mt(Sigma) = mt(O)$ 即可。以下设 $r > 0$。

先考虑矩阵 $mt(A)^"T" mt(A)$。它是实对称矩阵，且对任意 $vc(x) in RR^n$，有
$
  vc(x)^"T" mt(A)^"T" mt(A) vc(x) = (mt(A) vc(x))^"T" (mt(A) vc(x)) >= 0
$
因此 $mt(A)^"T" mt(A)$ 的特征值全为非负实数。由实对称矩阵的谱分解定理，存在正交矩阵 $mt(V)$ 与对角矩阵
$
  mt(D) = diag{lambda_1, dots, lambda_n}, quad lambda_1 >= dots >= lambda_n >= 0
$
使得
$
  mt(A)^"T" mt(A) = mt(V) mt(D) mt(V)^"T"
$

又由前面的秩定理，
$
  rank(mt(A)^"T" mt(A)) = rank(mt(A)) = r
$
所以 $mt(D)$ 恰有 $r$ 个正对角元，即
$
  lambda_1 >= dots >= lambda_r > 0, quad lambda_(r+1) = dots = lambda_n = 0
$

#insight[为什么定义 $vc(u)_i = 1/sigma_i mt(A) vc(v)_i$][
  向量 $vc(v)_i$ 已经是在定义域中选好的标准正交方向，而
  $
    mt(A)^"T" mt(A) vc(v)_i = lambda_i vc(v)_i
  $
  说明 $mt(A)$ 把这个方向送到陪域后，其长度平方正好是 $lambda_i$：
  $
    (mt(A) vc(v)_i)^"T" (mt(A) vc(v)_i)
    = vc(v)_i^"T" mt(A)^"T" mt(A) vc(v)_i
    = lambda_i
  $
  因此当 $lambda_i > 0$ 时，$mt(A) vc(v)_i$ 非零，而且它的长度正好是 $sqrt(lambda_i)$。于是把它除以 $sigma_i = sqrt(lambda_i)$，就得到单位向量 $vc(u)_i$。这种定义的关键好处是：它既保留了 $mt(A)$ 在方向上的真实作用，又把长度因素单独提取为奇异值 $sigma_i$，从而自然得到
  $
    mt(A) vc(v)_i = sigma_i vc(u)_i
  $
  这正是奇异值分解所需的形式。
]

令
$
  sigma_i = sqrt(lambda_i), quad 1 <= i <= r
$
并记 $mt(V)$ 的列向量为 $vc(v)_1, dots, vc(v)_n$，则
$
  mt(A)^"T" mt(A) vc(v)_i = lambda_i vc(v)_i
$

对每个 $1 <= i <= r$，定义
$
  vc(u)_i = 1/sigma_i mt(A) vc(v)_i
$
则对任意 $1 <= i, j <= r$，有
$
  vc(u)_i^"T" vc(u)_j
  = 1/(sigma_i sigma_j) vc(v)_i^"T" mt(A)^"T" mt(A) vc(v)_j
  = lambda_j/(sigma_i sigma_j) vc(v)_i^"T" vc(v)_j
  = cases(
    1\, & i = j,
    0\, & i != j
  )
$
故 $vc(u)_1, dots, vc(u)_r$ 是一组标准正交向量。将它们扩充为 $RR^m$ 的一组标准正交基
$
  vc(u)_1, dots, vc(u)_m
$
并令
$
  mt(U) = [vc(u)_1, dots, vc(u)_m]
$
则 $mt(U)$ 是正交矩阵。

再令
$
  mt(Sigma) = diag{sigma_1, dots, sigma_r}_(m times n)
$
由于当 $i > r$ 时 $lambda_i = 0$，故
$
  0 = vc(v)_i^"T" mt(A)^"T" mt(A) vc(v)_i = (mt(A) vc(v)_i)^"T" (mt(A) vc(v)_i)
$
从而 $mt(A) vc(v)_i = 0$。于是对一切 $1 <= i <= n$，都有
$
  mt(A) vc(v)_i = cases(
    sigma_i vc(u)_i\, & 1 <= i <= r,
    0\, & r < i <= n
  )
$
这正说明
$
  mt(A) mt(V) = mt(U) mt(Sigma)
$
两边右乘 $mt(V)^"T"$，得到
$
  mt(A) = mt(U) mt(Sigma) mt(V)^"T"
$
这就得到了奇异值分解。

最后，由前面的行列式公式可知 $mt(A)^"T" mt(A)$ 与 $mt(A) mt(A)^"T"$ 具有相同的非零特征值，因此 $sigma_1, dots, sigma_r$ 也恰好是 $mt(A) mt(A)^"T"$ 的全部正特征值的平方根。
