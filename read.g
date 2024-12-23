dir   := DirectoryCurrent();
dir   := Filename(dir, "pkg/LieBreadth");
dir   := Directory( dir );
if IsBool( DirectoryContents( dir ) ) then
    Error( "The current directory is empty." );
fi;

paths := [ "breadth.gd", "lie.gi", "breadth.gi", "inflation.gi" ];

for path in paths do
    filename := Filename(dir, path);
    if not IsExistingFile(filename) then
        str := StringFormatted( "File {} is not in the current directory", filename);
        Error( str );
    else
        Read( filename );
    fi;
od;

Print( "Functions loaded. \n");
Unbind( dir );
Unbind( paths ); 
Unbind( filename );
Unbind( str );