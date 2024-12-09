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

### Infaltion.gi

DeclareInfoClass( "InfoInflation" );
DeclareAttribute( "LieNilpotentGrading", IsLieNilpotent );
DeclareAttribute( "LieTwoStepCentralizers", IsLieNilpotent );
DeclareProperty(  "IsLieCovered", IsLieNilpotent );
DeclareAttribute( "PolynomialAlgebra", IsField and IsFinite );
