# Introduction

Functions to calculate the breadth of a Lie algebra.
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

# Cites

> - B. Eick and O. F. Ayala. 
