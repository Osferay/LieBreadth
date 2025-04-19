#
# liebreadth: Breadth in finite dimensional algebras
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "liebreadth",
Subtitle := "Breadth in finite dimensional algebras",
Version := "0.1",
Date := "19/04/2025", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    FirstNames := "Óscar",
    LastName := "Fernández Ayala",
    WWWHome := "https://Osferay.github.io",
    Email := "oscar00ayala@gmail.com",
    IsAuthor := true,
    IsMaintainer := true,
    #PostalAddress := TODO,
    Place := "Braunschweig",
    Institution := "TU Braunschweig",
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/Osferay/liebreadth",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://Osferay.github.io/research/software/liebreadth/",
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "liebreadth",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Breadth in finite dimensional algebras",
),

Dependencies := rec(
  GAP := ">= 4.13",
  NeededOtherPackages := [ ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := [ "LieAlgebras" ],

));


