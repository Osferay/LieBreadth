### Breadth.gi

DeclareInfoClass( "InfoLieBreadth" );
DeclareAttribute( "LieBreadth", IsLieNilpotent );

### Lie.gi

DeclareAttribute( "LieClass", IsLieNilpotent );
DeclareAttribute( "LieType", IsLieNilpotent );
DeclareProperty(  "IsOfMaximalClass", IsLieNilpotent );
DeclareAttribute( "StructureMatrices", IsLieAlgebra);
DeclareAttribute( "BasisLieCenter", IsLieAlgebra );
DeclareAttribute( "LieAdjointMatrix", IsLieAlgebra);