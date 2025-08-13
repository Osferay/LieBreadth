#
# liebreadth: Breadth in finite dimensional algebras
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "liebreadth" );
LoadPackage( "guarana" );

dir := DirectoriesPackageLibrary( "liebreadth", "tst" );
tst := [ "T.tst" ];
  
tst := List( tst, x -> Filename( dir, x ) );
TestDirectory( tst, rec(exitGAP := true) );

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
