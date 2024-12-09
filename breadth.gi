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
    fi; od; od;

    return false;

end;

###############################################################
## Function to calculate the l dimensiona matrix minors 
## of a matrix M using some information of the rows and columns.
## It stops at the first non-trivial minor finded.
###############################################################

MatrixMinorsWithInfo := function( M, l, NonZeroRows, NonZeroCols)
    local   n,      #Dimension of the matrix M.
            R,      #Combinations of rows for the minors.
            C,      #Combinations of columns for the minors
            r,      #Rows of the non-trivial minor.
            c,      #Columns of the non-trivial minor.
            N,      #Minor
            det;    #Determinant of N  


    n := Length(M);
    R := Combinations( NonZeroRows, l);
    C := Combinations( NonZeroCols, l);
    
    for r in R do
        for c in C do
            N := M{r}{c};
            det := Determinant(N);

            if det <> 0*det then 
                return [ det, [r,c] ]; 
    fi; od; od;

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
    fi; od; od;

    return res;

end;

###############################################################
## Function to calculate the l dimensiona matrix minors 
## of a matrix M using some information of the rows and columns.
## Returns all non-trivial minor finded.
###############################################################

AllMatrixMinorsWithInfo := function(  M, l, NonZeroRows, NonZeroCols )
    local   n,      #Dimension of the matrix M.
            R,      #Combinations of rows and columns for the minors.
            C,      #Combinations of columns for the minors
            res,    #Resulting non-trivial minor.
            r,      #Rows of the non-trivial minor.
            c,      #Columns of the non-trivial minor.
            N,      #Minor
            det;    #Determinant of N  
    
    n := Length(M);
    R := Combinations( NonZeroRows, l);
    C := Combinations( NonZeroCols, l);
    res := [];
    
    for r in R do
        for c in C do
            N := M{r}{c};
            det := Determinant(N);

            if det <> 0*det then 
                Add(res, [ det, [r,c] ]); 
    fi; od; od;

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
    fi; od;

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
            NonZeroRows,    #Non-zero rows of adj
            max,            #Maximum breadth
            minors;         #Non-trivial minors in each step

    if IsLieAbelian( L ) then
        return 0;
    fi;

    dim := Dimension(L);
    der := Dimension( LieDerivedSubalgebra(L) );
    F   := LeftActingDomain(L);

    x := List([1..dim], x -> 0);
    for i in Difference( [1..dim], BasisLieDerived(L).pos) do
        x[i] := Indeterminate( F, i );
    od;
    Info( InfoLieBreadth, 2, StringFormatted( "The vector of indeterminates is: {}", x ));

    adj := List( StructureMatrices(L), i -> x*i );

    if InfoLevel( InfoLieBreadth ) = 1 then
        Info( InfoLieBreadth, 2, "The adjoint matrix is:\n");
        PrintArray( adj );
    fi;

    NonZeroRows := BasisLieDerived(L).pos;
    NonZeroCols := Difference( [1..dim], BasisLieCenter(L).pos);

    max := dim - Dimension( LieCenter(L) );
    for i in Reversed([1..max]) do
        Info( InfoLieBreadth, 1, StringFormatted( "Computing minors of dimension: {}", i ) );
        if IsFinite(F) then 
            minors := AllMatrixMinorsWithInfo( adj, i, NonZeroRows, NonZeroCols);
                    
            if not IsEmpty( minors ) then
                for c in [1..Length( minors )] do
                    if not VanishingPolyFF( minors[c][1], F, dim-der) then 

                        Info( InfoLieBreadth, 1, StringFormatted( "The non-vanishing minor has polynomial: {}, and the corresponding matrix is;", minors[c][1] ) );
                        if InfoLevel( InfoLieBreadth ) = 1 then
                            PrintArray( adj{minors[c][2][1]}{minors[c][2][2]} );
                        fi;
                        if not LieClass(L) <= i +1 then
                            Info( InfoLieBreadth, 1, "This Lie algebra does not hold the class-breadth conjecture" );
                        fi;

                        return i; 
        fi; od; fi;

        else 
            minors := MatrixMinorsWithInfo( adj, i, NonZeroRows, NonZeroCols );

            if not IsBool( minors ) then
                return i;
    fi; fi; od;
end );

InstallMethod( IsTrueClassBreadth, [IsLieNilpotent], function(L) 

    
    local   dim,            #Dimension of d
            der,            #Dimension of the derived subalgebra
            F,              #Field of the algebra L
            i, c,           #Bucle variables
            x,              #Vector of indeterminates 
            adj,            #Adjoint matrix
            StartRow,       #First row to include in the search of minors
            NonZeroCols,    #Non-zero columns of adj
            NonZeroRows,    #Non-zero rows of adj
            max,            #Maximum breadth
            minors;         #Non-trivial minors in each step

    if HasLieBreadth(L) then
        return LieClass(L) <= LieBreadth(L) +1;
    fi;

    if IsLieAbelian( L ) then
        return true;
    fi;

    dim := Dimension(L);
    der := Dimension( LieDerivedSubalgebra(L) );
    F   := LeftActingDomain(L);

    x := List([1..dim], x -> 0);
    for i in Difference( [1..dim], BasisLieDerived(L).pos) do
        x[i] := Indeterminate( F, i );
    od;
    Info( InfoLieBreadth, 2, StringFormatted( "The vector of indeterminates is: {}", x ));

    adj := List( StructureMatrices(L), i -> x*i );

    if InfoLevel( InfoLieBreadth ) = 1 then
        Info( InfoLieBreadth, 2, "The adjoint matrix is:\n");
        PrintArray( adj );
    fi;

    NonZeroRows := BasisLieDerived(L).pos;
    NonZeroCols := Difference( [1..dim], BasisLieCenter(L).pos);

    max := dim - Dimension( LieCenter(L) );
    for i in Reversed([1..max]) do

        Info( InfoLieBreadth, 1, StringFormatted( "Computing minors of dimension: {}", i ) );
        if IsFinite(F) then 
            if i +1 < LieClass(L) then
                return false;
            else 
                minors := AllMatrixMinorsWithInfo( adj, i, NonZeroRows, NonZeroCols);
                    
                if not IsEmpty( minors ) then
                    for c in [1..Length( minors )] do
                        if not VanishingPolyFF( minors[c][1], F, dim-der) then 

                            Info( InfoLieBreadth, 1, StringFormatted( "The non-vanishing minor has polynomial: {}, and the corresponding matrix is;", minors[c][1] ) );
                            if InfoLevel( InfoLieBreadth ) = 1 then
                                PrintArray( adj{minors[c][2][1]}{minors[c][2][2]} );
                            fi;
                            if not LieClass(L) <= i +1 then
                                Info( InfoLieBreadth, 1, "This Lie algebra does not hold the class-breadth conjecture" );
                            fi;
                            SetLieBreadth( L, i);
                            return true; 
                        fi; 
                    od; 
                fi; 
            fi;
        else 
            return true;
        fi; od;

    return 0;
end );