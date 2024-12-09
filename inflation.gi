###############################################################
## All this methods are completely experimental 
###############################################################

###############################################################
## Function to get a grading over a nilpotent Lie algebra
## given by the lower central series.
###############################################################

InstallMethod( LieNilpotentGrading, [IsLieNilpotent], function( L )

    local   lcs,    #Lower central series
            grad,   #Grading
            i,      #Bucle variable
            B,      #Basis of L^i
            C;      #Basis of L^i+1

    lcs  := LieLowerCentralSeries( L );
    grad := [];
    for i in [1..Length(lcs)-1] do

        B  := AsSSortedList( BasisVectors( Basis( lcs[i] ) ) );
        C  := AsSSortedList( BasisVectors( Basis( lcs[i+1] ) ) );
        Add( grad, Difference( B, C ) );
    od;

    return grad;

end);

###############################################################
## Function rewrite the lie algebra to a nice presentation
## based on the grading
###############################################################

LieGradedPresentation := function(L)

    local   F,      #Field in which the lie algebra is defined.
            grad,   #Grading of L
            base,   #Basis of L
            ord,    #Permutation of the basis
            i, j, k,#Bucle variables
            mat,    #
            x,      #Vector variable
            SM,     #Structure matrices
            TM,     #Transformed matrices
            T;      #Table of structure constrants

    F    := LeftActingDomain( L );
    grad := LieNilpotentGrading( L );
    base := BasisVectors( Basis(L) );

    #Find the orders in which the basis vectors appear in the grading
    # and construct the matrix of transformation
    ord := [ Position( base, grad[1][1]), Position( base, grad[1][2]) ];
    mat := [ List( [1..Length(base)], x -> 0 ), List( [1..Length(base)], x -> 0 )];
    mat[1][ord[1]] := 1;
    mat[2][ord[2]] := 1;

    for i in [2..Length(grad)] do
        ord[i+1] := Position( base, grad[i][1] );

        x := List( [1..Length(base)], x -> 0 );
        x[ ord[i+1] ] := 1;
        mat[ i+1 ] := x;

    od;

    ord := [ ord, [1..Length(ord) ] ];

    #Transform the structure matrices
    SM := StructureMatrices( L );
    TM := ShallowCopy( SM );
    TM := [];

    for i in [1..Length(SM)] do
        TM[i] := List( SM[i], x -> List( x, y -> Int(y) ) );
        TM[i] := mat*TM[i]*Inverse( mat );
    od;

    #Reorder the structure matrices
    SM := [];
    for i in [1..Length(TM)] do
        SM[ ord[2][i] ] := TM[ ord[1][i] ];
    od;
    # Rewrite the SC table

    T := EmptySCTable( Length(base), Zero(F), "antisymmetric");

    for k in [3..Length(SM)] do
        for i in [1..Length(base)-1] do
            for j in [i+1..Length(base)] do
                if SM[k][i][j] <> 0 then
                    SetEntrySCTable( T, i , j, [ SM[k][i][j], k ] );
    fi; od; od; od;
    
    return LieAlgebraByStructureConstants( F, T );

end;

###############################################################
## Function to calculate all two-step centralizers
###############################################################

InstallMethod( LieTwoStepCentralizers, [IsLieNilpotent], function( L )

    local   grad,   #Grading for L
            B,      #Basis of L
            C,      #Two-step Centralizers
            i,      #Bucle variable
            null;   #Two step centralizer for each step

    grad := LieNilpotentGrading( L );
    B    := Basis(L);
    C    := [];

    for i in [2..Length(grad)] do
        null := [ Coefficients(B, grad[1][1]*grad[i][1]), Coefficients(B, grad[1][2]*grad[i][1]) ];
        null := NullspaceMat( null );
        Add( C, null*[ grad[1][1], grad[1][2] ] );
    od;

    return C;

end );

###############################################################
## Function to calculate if L is covered
###############################################################

InstallMethod( IsLieCovered, [IsLieNilpotent], function( L )

    local   2C, #Two step centralizers
            L1; #First element of the grading of L

    L1 := LieNilpotentGrading(L)[1];

    2C := AsSet(LieTwoStepCentralizers( L ));
    2C := Difference( 2C, [L1] );

    if Length( 2C ) = Size(LeftActingDomain(L)) + 1 and IsEmpty( Filtered( 2C, x -> Length(x) <> 1 ) ) then
        return true;
    fi;

    return false;

end );

###############################################################
## Function to create the polynomial algebra of F 
###############################################################

InstallMethod(PolynomialAlgebra, [IsField and IsFinite], function( F )

    local   T,      #Structure table of the polynomial algebra
            B,      #Basis strings
            i,j;    #Bucle variables

    T := EmptySCTable( Size(F), Zero(F), "symmetric" );
    B := [];

    for i in [1..Size(F)] do
        for j in [i..Size(F)] do
            if i+j-1 <= Size(F) then
            SetEntrySCTable( T, i, j, [1, i+j-1]);
    fi; od;
        Add( B, StringFormatted( "e^{}", i-1 ) );
    od;

    return AlgebraByStructureConstants( F, T, B );
end );

###############################################################
## Function to create the Lie algebra of M extended by A
###############################################################

LieExtendedIdeal := function( M, A)

    local   Mup,    #Extended lie algebra
            B,      #Basis of A
            i,j;    #Bucle variables

    Mup := [];
    B := BasisVectors( Basis(A) );

    for i in [1..Length(M)] do
        for j in [1..Length(B)] do
            Add( Mup, [M[i], B[j]]);
    od; od;

    return Mup;

end;

###############################################################
## Muliplication of elements in the extension of M
###############################################################

PointwiseMultiplication := function( Mup )

    local   i,j,    #Bucle variable
            m,      #Multiplication in each step
            pwm;    #Point wise multiplication

    pwm := [];

    for i in [1..Length(Mup)-1] do
        for j in [i..Length(Mup)] do

            m := [ Mup[i][1]* Mup[j][1], Mup[i][2] * Mup[j][2] ];


            if m[1] <> 0*m[1] and m[2] <> 0*m[2] then

                Info( InfoInflation, 2, StringFormatted( "Tensor product of {} and {} is {}", Mup[i], Mup[j], m) );
                if Position( Mup, m) = fail then
                    m := [ -1*m[1] , m[2] ];
                    m := Position( Mup, m);
                    Add( pwm, [j, i, [1, m] ] );
                else
                    m := Position( Mup, m);
                    Add( pwm, [i, j, [1, m] ] );
    fi; fi; od; od;

    return pwm;
end;

###############################################################
## Usual derivate of a monomialpolynomial in the algebra of polynomials
###############################################################

Usualderivate := function( p, B )

    local i; #Bucle variable

    i := Position( B, p);

    if i = 1 then
        return 0*p;
    else
        return B[i-1];
    fi;

end;

###############################################################
## Multiplication induced in the extension of M by s
###############################################################

DerivateTensorProduct := function( Mup, B, s)
    
    local   dtp,    #Derivate tensor product
            der,    #Derivate in each step
            mm,     #maximal monomial in the polynomial algebra
            i,      #Bucle variable
            n;      #Length of the basis of the polynomial algebra

    dtp := [];
    mm  := B[ Length(B) ];
    n   := Length( Mup )+1;

    for i in [1..Length(Mup)] do

        if Mup[i][2]*mm = mm then 
            der := [ s*Mup[i][1], Mup[i][2]*mm ];
        else 
        der := [ Mup[i][1], Usualderivate( Mup[i][2], B ) ];
        fi;
        
        Info( InfoInflation, 2, StringFormatted( "Derivation product of {} is {}", Mup[i], der) );

        if der[1] <> 0*der[1] and der[2] <> 0*der[2] then

            if Position( Mup, der) = fail then 
                der := [ -1*der[1], der[2]];
                der := Position( Mup, der);
                Add( dtp, [n, i, [1, der] ] );
            else
                der := Position( Mup, der);
                Add( dtp, [i, n, [1, der] ] );
            fi;
    fi; od;

    return dtp;

end;

###############################################################
## Inflation of L by the extension of M and s
###############################################################

Inflation := function( L, M, s )

    local   F,      #Field where L is defined
            Mup,    #Extension of M by A
            A,      #Polynomial algebra of F
            B,      #Basis of A
            i,j,    #Bucle variables
            dim,    #Dimension of the inflated algebra
            T,      #Structure table 
            pwm,    #Point wise multiplication
            dtp;    #Derivate tensor product

    F := LeftActingDomain( L );
    A := PolynomialAlgebra( F );
    B := BasisVectors( Basis(A) );
    Mup := LieExtendedIdeal( M, A );
    Info( InfoInflation, 1, StringFormatted( "The extension of the ideal is {}", Mup ) );

    dim := LieClass( L )*Length(B)+1;
    T := EmptySCTable( dim, Zero(F), "antisymmetric");

    #Calculate the point wise multiplication of the extended ideal
    pwm := PointwiseMultiplication( Mup );
    for i in [1..Length(pwm)] do
        SetEntrySCTable( T, pwm[i][1], pwm[i][2], pwm[i][3] );
    od; 
    Info( InfoInflation, 1, StringFormatted( "The point wise multiplication is {}", pwm ) );
    
    #Calculate the induced multiplication of the extended ideal
    dtp := DerivateTensorProduct( Mup, B, s );
    for i in [1..Length(dtp)] do
        SetEntrySCTable( T, dtp[i][1], dtp[i][2], dtp[i][3] );
    od; 
    Info( InfoInflation, 1, StringFormatted( "The derivate tensor product is {}", dtp ) );

    return LieAlgebraByStructureConstants( F, T );
end;

###############################################################
## Lie algebras coverded constructed by inflation
###############################################################

LieCoveredInflated := function(n)

    local   F,  #Field where the Lie algebra is going to be defined
            L,  #Lie algebra
            A,  #Polynomial algebra
            M;  #Maximal ideal of L to inflate in eacch step

    F := GF(n);
    L := AbelianLieAlgebra( F, 2 );

    if n = 2 then

        M := BasisVectors( Basis(L) ){[1]};
        L := LieGradedPresentation( Inflation( L, M, L.2 ) );
        M := BasisVectors(Basis(L)){[2,3]};
        L := LieGradedPresentation( Inflation( L, M, L.1 ) );
        M := BasisVectors(Basis(L)){[1,3,4,5]};
        L := LieGradedPresentation( Inflation( L, M, L.1+L.2 ) );
        M := BasisVectors(Basis(L)){[1,3,4,5,6,7,8,9]};
        L := LieGradedPresentation( Inflation( L, M, L.2 ) );
    
    elif n=3 then
        
        M := BasisVectors(Basis(L)){[2]};
        L := LieGradedPresentation( Inflation( L, M, L.1 ) );
        M := BasisVectors(Basis(L)){[1,3,4]};
        L := LieGradedPresentation( Inflation( L, M, L.1+L.2 ) );
        M := BasisVectors(Basis(L)){Concatenation([1],[3..10])};
        L := LieGradedPresentation( Inflation( L, M, L.1-L.2 ) );
        M := BasisVectors(Basis(L)){Concatenation([1],[3..28])};
        L := LieGradedPresentation( Inflation( L, M, L.2 ) );
    fi;

    return L;
end;

###############################################################
## Quotients of a covered lie algebra that does not hold CB conjecture
###############################################################

LieMinimalQuotientClassBreadth := function( L )

    local   F,      #Field where the Lie algebra is going to be defined
            q,      #index of the lcs
            lcs;    #Lower central series of L

    F   := LeftActingDomain( L );
    q   := 2*Characteristic(F)^Size(F)+2;
    lcs := LieLowerCentralSeries(L);

    return L/lcs[q];

end;