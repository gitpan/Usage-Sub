use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
# $Id: Makefile.PL,v 1.2 2002/02/23 12:17:30 hasant Exp $
WriteMakefile(
    'NAME'		=> 'Usage::Sub',
    'VERSION_FROM'	=> 'Sub.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'Sub.pm', # retrieve abstract from module
       AUTHOR     => 'Hasanuddin Tamir <hasant@trabas.com>') : ()),
	dist => {
		COMPRESS => 'gzip -9',
		SUFFIX => 'gz',
		POSTOP => 'mv $(DISTVNAME).tar.gz ..',
	},
);
