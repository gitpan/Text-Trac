use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Text::Trac',
    AUTHOR              => 'Gosuke Miyashita <gosukenator@gmail.com>',
    VERSION_FROM        => 'lib/Text/Trac.pm',
    ABSTRACT_FROM       => 'lib/Text/Trac.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'               => 0,
        'UNIVERSAL::require'       => 0,
        'Class::Accessor::Fast'    => 0,
        'Class::Data::Inheritable' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Text-Trac-*' },
);
