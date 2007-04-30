
use 5;
use ExtUtils::MakeMaker;

my $EUMM_VERSION = eval $ExtUtils::MakeMaker::VERSION;

WriteMakefile(
    NAME              => 'Memoize::Attrs',
    VERSION_FROM      => 'lib/Memoize/Attrs.pm',
    PREREQ_PM         => {
        Memoize             => 0,
        Attribute::Handlers => 0,

        Test::More          => 0,
    },
    PL_FILES          => {},
    ($] >= 5.005 ? (
        'ABSTRACT_FROM' => 'lib/Memoize/Attrs.pm',
        'AUTHOR'        => 'Adriano R. Ferreira <ferreira@cpan.org>'
    ) : ()),
    ($EUMM_VERSION >= 6.31 ? (
        LICENSE => 'perl', 
        EXTRA_META => "recommends:\n    Test::Pod:                     1.18\n    Test::Pod::Coverage:           1.04\n",
    ) :())

);

