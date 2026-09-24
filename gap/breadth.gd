#! @Chapter Preface
#! @ChapterLabel preface
#! @ChapterTitle Preface

#! In this package we compute the breadth of Lie algebras.
#! The details of the algorithms are available in <Cite Key="breadth" />.
#! This package also includes functions to compute covered Lie algebras of maximal class using a process called
#! inflation, which is described by Caranti, Mattarei, and Newman <Cite Key="inflation" />.
	
#! @Section Introduction
#! Given a finite-dimensional algebra $L$, we define its lower central series as $L = L^1 > L^2 > \dots$, where $L^{i+1} = L^i L$.
#! The algebra $L$ is nilpotent if there exists $c \in \mathbb{N}$ such that $L^{c+1} = \{0\}$, and the minimal such $c$ 
#! is called the class $\mathrm{cl}(L)$ of $L$. For a nilpotent algebra $L$, the type of $L$
#! is the vector $(d_1,\dots,d_c)$, where $d_i = \dim L^i$. A nilpotent algebra $L$ is said to be of maximal class if
#! the type of $L$ is $(2,1,\dots,1)$. The centralizer of $x \in L$ is the subspace of $L$ 
#! defined by $C_L(x) = \{a \in L \mid ax = 0\}$. For an algebra $L$, we define 
#! $$ \mathrm{br}(L) = \max \{ \mathrm{br}(x) \mid x \in L\}, \;\; \mbox{ where } \;\; \mathrm{br}(x) = \dim(L) - \dim(C_L(x)). $$
#! The class-breadth conjecture asserts that $\mathrm{cl}(L) \leq \mathrm{br}(L)+1$ for an algebra $L$.
#! The conjecture holds for nilpotent Lie algebras over infinite fields and for nilpotent associative algebras over arbitrary fields. 
#!
#! Let $L$ be a Lie algebra over a field $K$, and let $B = \{ b_1, \ldots, b_n \}$ be a basis of $L$. 
#! The multiplication in $L$ is described by structure constants defined by
#! $$ b_i \cdot b_j = \sum_{k=1}^n c_{ijk} b_k \quad\mbox{ for } 1\leq i,j \leq n. $$
#! For each $k$, write $C_k = (c_{ijk})_{1 \leq i,j \leq n}$ for the $n \times n$ matrix over $K$ 
#! with entries $c_{ijk}$, and these matrices are the structure matrices of $L$. For $x = x_1 b_1 + \ldots + x_n b_n \in L$,
#! let $\overline{x} = (x_1, \ldots, x_n) \in K^n$ denote the coefficient vector of $x$. 
#! Then $C_k \overline{x}^{tr}$ is a column vector over $K$. We write $M_B(x)$ for the 
#! $n \times n$ matrix over $K$ whose $k$-th column is $C_k \overline{x}^{\mathrm{tr}}$, which is the adjoint matrix of $L$ with respect to the basis $B$. 

### Lie.gi
#! @Chapter Lie algebras and breadth
#! @ChapterLabel lie
#! @ChapterTitle Lie algebras and breadth

#! @Section Attributes
#! @Description
#! Computes the class of the nilpotent Lie algebra $L$.
#! @Arguments L
DeclareAttribute( "LieClass", IsLieNilpotent );
#! @Description
#! Computes the type of the nilpotent Lie algebra $L$.
#! @Arguments L
DeclareAttribute( "LieType", IsLieNilpotent );
#! @Description
#! Returns whether the nilpotent Lie algebra $L$ is of maximal class or not.
#! @Arguments L
DeclareProperty(  "IsOfMaximalClass", IsLieNilpotent );
#! @Description
#! Computes the structure matrices of the nilpotent Lie algebra $L$.
#! @Arguments L
DeclareAttribute( "StructureMatrices", IsLieAlgebra);
#! @Description
#! Returns the basis elements of the Lie algebra $L$ that are contained in the center of $L$.
#! @Arguments L
DeclareAttribute( "BasisLieCenter", IsLieAlgebra );
#! @Description
#! Returns the basis elements of the Lie algebra $L$ that are contained in the derived subalgebra of $L$.
#! @Arguments L
DeclareAttribute( "BasisLieDerived", IsLieAlgebra );
#! @Description
#! Computes the adjoint matrix of the Lie algebra $L$.
#! @Arguments L
DeclareAttribute( "LieAdjointMatrix", IsLieAlgebra);
#! @Description
#! Prints the Lie presentation of the Lie algebra $L$.
#! @Arguments L
DeclareAttribute( "PrintLiePresentation", IsLieAlgebra );

### Breadth.gi
#! @Section Breadth

#! @Description
#! Info class for the functions of the breadth of Lie algebras.
DeclareInfoClass( "InfoLieBreadth" );
#! @Description
#! Computes the breadth of the Lie algebra $L$.
#! @Arguments L
DeclareAttribute( "LieBreadth", IsLieNilpotent );
#! @Description
#! Returns whether the class-breadth conjecture holds for the Lie algebra $L$.
#! @Arguments L
DeclareProperty(  "IsTrueClassBreadth", IsLieNilpotent );
#! @Description
#! Computes the breadth of the $\mathcal{T}$-group $G$.
#! @Arguments G
DeclareGlobalFunction( "TGroupBreadth" );

### Inflation.gi
#! @Section Inflation of Lie algebras

#! A grading for a Lie algebra $L$ is a decomposition $L = \bigoplus_{i=1}^n L_i$ that respects the Lie bracket,
#! **i.e.** $[L_i,L_j]\subseteq L_{i+j}$. All nilpotent Lie algebras can be graded by taking $L_i = \gamma_i(L)/\gamma_{i+1}(L)$.
#! Let $L$ be a nilpotent Lie algebra of maximal class. The two-step centralizers are the sets 
#! $C_i = C_{L_1}(L_i) = \{x \in L_1 \mid [x,L_i] = 0 \}$ for all $2\leq i \leq c$.
#! Let $\mathcal{C}=\{C_i\}\setminus L_1$. We say that a Lie algebra of maximal class is covered if the 
#! set $\mathcal{C}$ consist of all one-dimensional subspaces of $L_1$.
#!
#! Let $L = \bigoplus_{i=1}^n L_i$ be a graded Lie algebra over $K=\mathbb{F}_q$ for some prime power $q=p^n$. 
#! Consider the field extension $A=K[\varepsilon]/\langle \varepsilon^p \rangle$ which is a vector space over $K$ of 
#! dimension $p$. The algebra $A$ is an associative, commutative algebra with a unit. The algebra $L\otimes A$ over $K$, 
#! defined by $[x\otimes a, y\otimes b] = [x,y]\otimes ab$, is a graded Lie algebra. Let $M$ be a maximal 
#! ideal of $L$ and consider the Lie subalgebra $M^\uparrow = M\otimes A$. Let $D$ be a derivation of $L$ 
#! of degree 1. Define $D^\uparrow$ by: $D^\uparrow(x\otimes \varepsilon^i)=D(x)\otimes \varepsilon^i$, which is a 
#! derivation of $M^\uparrow$ of degree 1. Define the derivation $E\in \mathrm{Der} M^\uparrow$ by 
#! $E(x\otimes \varepsilon^i) = D^\uparrow(x\otimes\varepsilon^i\cdot\varepsilon^{p-1})+1\otimes\partial_\varepsilon(\varepsilon^i)$.
#! For $s\in L_1\setminus M$, take $D=\mathrm{ad}_s$, and extend it naturally to 
#! $M^\uparrow$. Denote $E_{s^\prime}$ the derivation defined above. The **inflation** ${}^{M}L$ of $L$ at $M$ by 
#! $s\in L_1\setminus M$ is the graded Lie algebra obtained as an extension of $M^\uparrow$ by an element 
#! $s^\prime$, which is the extension of $s$ that induces the derivation $E_{s^\prime}$, that is,
#! $$ [x\otimes a, s^\prime] = E_{s^\prime}(x\otimes a) = \mathrm{ad}_{s^\prime}(x\otimes\varepsilon^i)+x\otimes\partial_\varepsilon(\varepsilon^i). $$

#! @Description
#! Info class for the functions of the inflation of Lie algebras.
DeclareInfoClass( "InfoInflation" );
#! @Description
#! Computes a grading of the nilpotent Lie algebra $L$ using the lower central series.
#! @Arguments L
DeclareAttribute( "LieNilpotentGrading", IsLieNilpotent );
#! @Description
#! Computes the two-step centralizers of the Lie algebra $L$.
#! @Arguments L
DeclareAttribute( "LieTwoStepCentralizers", IsLieNilpotent );
#! @Description
#! Returns whether the Lie algebra $L$ is covered or not.
#! @Arguments L
DeclareProperty(  "IsLieCovered", IsLieNilpotent );
#! @Description
#! For a finite field $F$, computes the polynomial algebra $F[x]$.
#! @Arguments F
DeclareAttribute( "PolynomialAlgebra", IsField and IsFinite );
#! @Description
#! For $n=2,3,4$, computes the covered Lie algebras of maximal class using the polynomial algebra of dimension $n$.
#! For $n=3$, one can directly load the Lie algebra by reading the file \texttt{inflation\_3.g}.
#! @Arguments n
DeclareAttribute( "LieCoveredInflated", IsInt );
#! @Description
#! Given a covered Lie algebras of maximal class $L$, computes the minimal quotient for which the class-breadth conjecture does not hold.
#! @Arguments L
DeclareAttribute( "LieMinimalQuotientClassBreadth", IsLieAlgebra );
