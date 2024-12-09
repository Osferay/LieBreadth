###############################################################
## Function to calculate the class of a Lie algebra 
###############################################################

InstallMethod( LieClass, [IsLieNilpotent], function(L)

    local   lcs;

    lcs := LieLowerCentralSeries( L );

    return( Length(lcs)-1 );

end);

###############################################################
## Function to calculate the type of a Lie algebra 
###############################################################

InstallMethod( LieType, [IsLieNilpotent], function(L)

    local   lcs,
            l,
            i;

    l   := [];
    lcs := LieLowerCentralSeries( L );

    for i in [1..Length(lcs)-1] do
        Add( l, Dimension( lcs[i] )-Dimension( lcs[i+1] ) );
    od;

    return l;

end);

###############################################################
## Function to calculate if a Lie algebra is of maximal class
###############################################################

InstallMethod( IsOfMaximalClass, [IsLieNilpotent], function( L ) 

    return LieClass(L) + 1 = Dimension(L);

end );

###############################################################
## Function to calculate the structure matrices of a Lie algebra 
###############################################################

InstallMethod( StructureMatrices, [IsLieAlgebra], function( L )

    local   SCT,
            d,
            SM,
            i,j,k;

    SCT := StructureConstantsTable( Basis ( L ) );
    d   := Dimension( L );
    SM  := ListWithIdenticalEntries( d, NullMat( d, d, LeftActingDomain( L ) ) );
    SM  := List( SM, x -> List( x, y -> ShallowCopy(y) ) );

    for i in [1..d-1] do 
        for j in [i+1..d] do
            for k in [1..Length(SCT[i][j][1])] do
                SM[SCT[i][j][1][k]][i][j] := SCT[i][j][2][k];
                SM[SCT[i][j][1][k]][j][i] := -SCT[i][j][2][k];
    od; od; od;

    return SM;
end); 

###############################################################
## Function to get the basis elements of a Lie algebra 
## that are in the center of L.
###############################################################

InstallMethod( BasisLieCenter, [IsLieAlgebra], function( L )

    local   B,
            C, 
            v,
            p,
            pos,
            res;

    B   := BasisVectors(Basis(L));
    C   := BasisVectors(Basis(LieCenter(L)));
    res := [];
    pos := [];

    for v in C do

        p := PositionProperty( B, x-> x = v);
        if not IsBool(p) then
            Add( res, B[p] );
            Add( pos, p );
    fi; od;

    return rec( vectors := res, pos := pos );

end );

###############################################################
## Function to get the basis elements of a Lie algebra 
## that are in the derived subalgebra of L.
###############################################################

InstallMethod( BasisLieDerived, [IsLieAlgebra], function( L )

    local   B,
            C, 
            v,
            p,
            pos,
            res;

    B   := BasisVectors(Basis(L));
    C   := BasisVectors(Basis(LieDerivedSubalgebra(L)));
    res := [];
    pos := [];

    for v in C do

        p := PositionProperty( B, x-> x = v);
        if not IsBool(p) then
            Add( res, B[p] );
            Add( pos, p );
    fi; od;

    return rec( vectors := res, pos := pos );

end );

###############################################################
## Function to calculate the adjoint matrix of a Lie algebra 
###############################################################

InstallMethod( LieAdjointMatrix, [IsLieAlgebra], function( L )

    local   d,
            a;

    d := Dimension(L);
    a := List( [1..d], x -> Indeterminate( LeftActingDomain(L), x ) );

    return List( StructureMatrices(L), x -> a*x );

end );

###############################################################
## Function to print the relaiions of a Lie algebra 
###############################################################

PrintLiePresentation := function( L )

    local   B,
            i,j;

    B := BasisVectors( Basis(L) );

    for i in [1..Length(B)-1] do
        for j in [i+1..Length(B)] do
            if B[i]*B[j] <> 0*B[i] then
            Print( StringFormatted( "[{1},{2}] = {3}\n", B[i], B[j], B[i]*B[j] ));
    fi; od; od;

end;