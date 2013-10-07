#!perl

use strict;
use warnings;

our $VERSION = 0;

use Carp qw(croak);
use English qw(-no_match_vars $OS_ERROR);

# extractor
require Locale::TextDomain::OO::Extract;
# to write a portable object template (.pot) file comfortable
require DBI;
require DBD::PO; DBD::PO->init( qw(:plural) );

# the same text like fist example
my $text = <<'EOT';
11 $__{'text1 original'}

21 $__x{'text1 original'} # __x without placeholders
22 $__x{[ 'text1 original' ]} # __x without placeholders, more common extractable
23 $__x{[ 'text2 original {text}', text => 'is good' ]}
24 $__n{[ 'text3 original singular', 'text3 original plural', 2 ]}
25 $__nx{[ 'text3 original singular', 'text3 original plural', 1 ]} # __nx without placeholders
26 $__xn{[ 'text3 original singular', 'text3 original plural', 2 ]} # __xn without placeholders
27 $__nx{[ 'text4 original {num} singular', 'text4 original {num} plural', 1, num => 1 ]}
28 $__xn{[ 'text4 original {num} singular', 'text4 original {num} plural', 2, num => 2 ]}

31 $__p{[ 'special', 'ctext1 original' ]}
32 $__px{[ 'special', 'ctext1 original' ]} # __px without placeholders
33 $__px{[ 'special', 'ctext2 original {text}', text => 'is good' ]}
34 $__np{[ 'special', 'ctext3 original singular', 'ctext3 original plural', 2 ]}
35 $__npx{[ 'special', 'ctext4 original {num} singular', 'ctext4 original {num} plural', 2, num => 2 ]}

41 @{ $N__{'text1 original'} }
42 @{ $N__{[ 'text1 original' ]} } # alternative writing
43 @{ $N__n{[ 'text3 original singular', 'text3 original plural', 2 ]} }
44 @{ $N__p{[ 'special', 'ctext1 original' ]} }
45 @{ $N__np{[ 'special', 'ctext3 original singular', 'ctext3 original plural', 2 ]} }
EOT

# Deleting the pot file if this exists,
# so that this example can be going on repeatedly.
unlink 'extract.pot';

my $extractor = Locale::TextDomain::OO::Extract->new();
$extractor->extract({
    file_name            => 'extract.pl',
    source_filehandle    => do {
        open my $file, '<', \$text
            or croak $OS_ERROR;
        $file;
    },
    destination_filename => 'extract.pot',
});

# $Id$
