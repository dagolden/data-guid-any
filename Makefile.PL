# inc::MakeMaker <self>
# and Dist::Zilla::Plugin::MakeMaker::Awesome 0.41.
# Don't edit it but the dist.ini and plugins used to construct it.

use strict;
use warnings;

use 5.006;
use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Generic interface for GUID/UUID creation",
  "AUTHOR" => "David Golden <dagolden\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::CBuilder" => "0.26",
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Data-GUID-Any",
  "LICENSE" => "apache",
  "MIN_PERL_VERSION" => "5.006",
  "NAME" => "Data::GUID::Any",
  "PREREQ_PM" => {
    "Exporter" => 0,
    "IPC::Cmd" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Spec" => 0,
    "Test::More" => "0.92",
    "lib" => 0
  },
  "VERSION" => "0.006",
  "test" => {
    "TESTS" => "t/*.t"
  }
);
;

$WriteMakefileArgs{PREREQ_PM} ||= {};

eval {
  local @INC = ('lib', @INC);
  require Data::GUID::Any;
  Data::GUID::Any::v1_guid_as_string(); # dies if no provider
  Data::GUID::Any::v4_guid_as_string(); # dies if no provider
  1;
} or do {
  require ExtUtils::CBuilder;
  if ( ExtUtils::CBuilder->new->have_compiler ) {
    $WriteMakefileArgs{PREREQ_PM}{'Data::UUID::MT'} = '0';
  }
  else {
    $WriteMakefileArgs{PREREQ_PM}{'UUID::Tiny'} = '0';
  }
};

# Hey, CPAN Testers, go ahead and test with extra prereqs
# that don't have external library dependencies
if ( $ENV{AUTOMATED_TESTING} ) {
  require ExtUtils::CBuilder;
  $WriteMakefileArgs{BUILD_REQUIRES}{'Data::UUID::MT'} = '0'
    if ExtUtils::CBuilder->new->have_compiler;
  $WriteMakefileArgs{BUILD_REQUIRES}{'UUID::Tiny'} = '0';
}
 

my %FallbackPrereqs = (
  "Exporter" => 0,
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => 0,
  "IPC::Cmd" => 0,
  "Test::More" => "0.92",
  "lib" => 0,
  "strict" => 0,
  "warnings" => 0
);

unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
