gap> ftl := FromTheLeftCollector(5);;
gap> SetConjugate( ftl, 2, 1, [2, 1, 3, 11] );;
gap> SetConjugate( ftl, 3, 1, [3, 1, 4, 8]  );
gap> SetConjugate( ftl, 3, 2, [3, 1, 5, 15] );
gap> SetConjugate( ftl, 4, 1, [4, 1, 5, 16] );
gap> G := PcpGroupByCollector( ftl );;
gap> TGroupBreadth(G);
3
