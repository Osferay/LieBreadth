### Lie.gi

DeclareAttribute( "LieClass", IsLieNilpotent );
DeclareAttribute( "LieType", IsLieNilpotent );
DeclareProperty(  "IsOfMaximalClass", IsLieNilpotent );
DeclareAttribute( "StructureMatrices", IsLieAlgebra);
DeclareAttribute( "BasisLieCenter", IsLieAlgebra );
DeclareAttribute( "BasisLieDerived", IsLieAlgebra );
DeclareAttribute( "LieAdjointMatrix", IsLieAlgebra);

### Breadth.gi

DeclareInfoClass( "InfoLieBreadth" );
DeclareAttribute( "LieBreadth", IsLieNilpotent );
DeclareProperty(  "IsTrueClassBreadth", IsLieNilpotent );