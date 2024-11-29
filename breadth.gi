###############################################################
## Function to calculate the l dimensiona matrix minors 
## of a matrix M. It stops at the first non-trivial minor finded.
###############################################################

MatrixMinors := function( M, l )
    local   n,      #Dimension of the matrix M.
            R,      #Combinations of rows and columns for the minors.
            r,      #Rows of the non-trivial minor.
            c,      #Columns of the non-trivial minor.
            N,      #Minor
            det;    #Determinant of N  

    n := Length(M);
    R := Combinations([1..n], l);

    for r in R do
        for c in R do
            N   := M{r}{c};
            det := Determinant(N);

            if det <> 0*det then 
                return [det, [r,c] ]; 
            fi;
        od;
    od;

    return false;

end;

###############################################################
## Function to calculate the l dimensiona matrix minors 
## of a matrix M using some information of the rows and columns.
## It stops at the first non-trivial minor finded.
###############################################################

MatrixMinorsWithInfo := function( M, l, StartRow, NonZeroCols)
    local   n,      #Dimension of the matrix M.
            R,      #Combinations of rows for the minors.
            C,      #Combinations of columns for the minors
            r,      #Rows of the non-trivial minor.
            c,      #Columns of the non-trivial minor.
            N,      #Minor
            det;    #Determinant of N  


    n := Length(M);
    R := Combinations([StartRow..n], l);
    C := Combinations( NonZeroCols, l);
    
    for r in R do
        for c in C do
            N := M{r}{c};
            det := Determinant(N);

            if det <> 0*det then 
                return [ det, [r,c] ]; 
            fi;
        od;
    od;

    return false;

end;

###############################################################
## Function to calculate the l dimensiona matrix minors 
## of a matrix M using some information of the rows and columns.
## Returns all non-trivial minor finded.
###############################################################

AllMatrixMinors := function( M, l )
    local   n,      #Dimension of the matrix M.
            R,      #Combinations of rows and columns for the minors.
            res,    #Resulting non-trivial minor.
            r,      #Rows of the non-trivial minor.
            c,      #Columns of the non-trivial minor.
            N,      #Minor
            det;    #Determinant of N  

    n := Length(M);
    R := Combinations([1..n], l);
    res := [];

    for r in R do
        for c in R do
            N := M{r}{c};
            det := Determinant(N);

            if det <> 0*det then 
                Add(res, [det, [r,c] ] ); 
            fi;
        od;
    od;

    return res;

end;

###############################################################
## Function to calculate the l dimensiona matrix minors 
## of a matrix M using some information of the rows and columns.
## Returns all non-trivial minor finded.
###############################################################

AllMatrixMinorsWithInfo := function(  M, l, StartRow, NonZeroCols )
    local   n,      #Dimension of the matrix M.
            R,      #Combinations of rows and columns for the minors.
            C,      #Combinations of columns for the minors
            res,    #Resulting non-trivial minor.
            r,      #Rows of the non-trivial minor.
            c,      #Columns of the non-trivial minor.
            N,      #Minor
            det;    #Determinant of N  
    
    n := Length(M);
    R := Combinations([StartRow..n], l);
    C := Combinations( NonZeroCols, l);
    res := [];
    
    for r in R do
        for c in C do
            N := M{r}{c};
            det := Determinant(N);

            if det <> 0*det then 
                Add(res, [ det, [r,c] ]); 
            fi;
        od;
    od;

    return res;

end;

###############################################################
## Function check if a given polynomial p over F vanishes 
## The argument n is the number of indeterminates in the poly
###############################################################

VanishingPolyFF := function( p, F, n )

    local   ord,    #Order of the field
            I,      #Ideal of vanishing polynomials
            lp,     #Linear polynomial
            deg,    #Degree of the indeterminate i in the poly
            vp,     #Vanishing polynomial of indeterminate i
            rp,     #Reduction of the polynomial in I
            i;      #Bucle variable

    ord := Size( F );
    I   := [];

    #Sometimes GAP stores the polynomial with rational representation
    #To avoid this we have to use the command quotient.

    lp := Quotient( NumeratorOfRationalFunction(p), DenominatorOfRationalFunction(p) );

    for i in [1..n] do

        deg := DegreeIndeterminate( lp, i );
        if deg >= ord then 
            vp := Indeterminate( F, i )^ord + Indeterminate( F, i );
            Add( I, vp); 
        fi;
    od;

    rp := PolynomialReduction( lp, I, MonomialGrlexOrdering() );

    if IsZero(rp[1]) then return true; fi;

    return false;

end;

###############################################################
## Method to calculate the breadth of a Lie algebra 
###############################################################

InstallMethod( LieBreadth, [IsLieNilpotent], function(L)

    local   dim,            #Dimension of d
            der,            #Dimension of the derived subalgebra
            F,              #Field of the algebra L
            i, c,           #Bucle variables
            x,              #Vector of indeterminates 
            adj,            #Adjoint matrix
            StartRow,       #First row to include in the search of minors
            NonZeroCols,    #Non-zero columns of adj
            CenterCols,     #Corresponding columns to elements of the center
            max,            #Maximum breadth
            minors;         #Non-trivial minors in each step

    dim := Dimension(L);
    der := Dimension( LieDerivedSubalgebra(L) );
    F   := LeftActingDomain(L);

    x := List([1..dim], x -> 0);
    for i in [1..(dim-der)] do
        x[i] := Indeterminate( F, i );
    od;
    Info( InfoLieBreadth, 1, StringFormatted( "The vector of indeterminates is: {}", x ));

    adj := List( StructureMatrices(L), i -> x*i );

    if InfoLevel( InfoLieBreadth ) = 1 then
        Info( InfoLieBreadth, 1, "The adjoint matrix is:\n");
        PrintArray( adj );
    fi;

    StartRow    := dim-der+1;
    NonZeroCols := [1..dim];
    CenterCols  := BasisLieCenter(L).pos;
    for c in CenterCols do
        RemoveSet( NonZeroCols, c );
    od;
    
    max := dim - Dimension( LieCenter(L) );
    for i in Reversed([1..max]) do

        if IsFinite(F) then 
            minors := AllMatrixMinorsWithInfo( adj, i, StartRow, NonZeroCols);
                    
            if not IsEmpty( minors ) then
                for c in [1..Length( minors )] do
                    if not VanishingPolyFF( minors[c][1], F, dim-der) then 
                        return i; 
                    fi;

                od;
            fi;
        else 
            minors := MatrixMinorsWithInfo( adj, i, StartRow, NonZeroCols );

            if not IsBool( minors ) then
                return i;
            fi;

        fi;
    od;

    return 0;
end );