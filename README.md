# Introduction

Functions to calculate the breadth of a Lie algebra. This code complements paper [2]
To install the functions save the files inside the GAP directory/pkg/LieBreadth and then run in GAP.
```
Read( "*Gap Directory*/pkg/LieBreadth/read.g");
```

# Contents

### read.g:       File to read in gap.

### breadth.gd:      Definition of the functions.

### lie.gi:      Functions to generate the groups used in experiments.
  - *LieClass( L )* : Retruns the class of the nilpotent Lie algebra L.
  - *LieType( L )* : Retruns the type of the nilpotent Lie algebra L.
  - *IsOfMaximalClass( L )* : Retruns whether if the nilpotent Lie algebra L is of maximal class.
  - *StructureMatrices( L )* : Retruns the structure matrices of the Lie algebra L.
  - *BasisLieCenter( L )* : Retruns the elements of the basis of L that are in center of L.
  - *BasisLieDerived( L )* : Retruns the elements of the basis of L that are in the derived subalgebra of L.
  - *LieAdjointMatrix( L )* : Retruns the adjoint matrix of the Lie algebra L.

### breadth.gi: Functions to calculate the extended isolator series:
- *InfoBreadth* : InfoClass of the function Lie breadth.
- *LieBreadth( L )* : Returns the breadth of the nilpotent Lie algebra.
- *IsTrueClassBreadth( L )* : Returns if the class-breadth conjecture is true without calculating the breadth.

### Inflation.gi: Functions to calculate the construct Lie covered algebras via inflation:
**Warning: These are experimental functions.** For definitions see [1].
- *InfoInflation* : InfoClass of the function LieInflation.
- *LieNilpotentGrading( L )* : Returns a grading resprect to the lower central series of the nilpotent Lie algebra.
- *LieTwoStepCentralizers( L )* : Returns the two step centralizers of the nilpotent Lie algebra.
- *IsLieCovered(L)* : Returns whether if the nilpotent Lie algebra is covered.
- *PolynomialAlgebra(F)* : Returns a polynomial algebra of dimension p-1 for a finite field of dimension p.
- *LieCoveredInflated(n)* : For n=2,3 returns a covered algebra constructed by inflting all one dimensional subspaces of L1.
- *LieMinimalQuotientClassBreadth(L)* : Returns the minimal covered Lie algebra constructed by a qoutient of a Lie covered Lie algebra L.

# Cites

1. A. Caranti, S. Mattarei, and M. F. Newman. Graded Lie algebras of maximal class. Trans. Amer. Math. Soc., 349(10):4021–4051, 1997.
2. B. Eick and O. Fernández Ayala. On the class-breadth conjecture for algebras and T-groups. Submitted.
