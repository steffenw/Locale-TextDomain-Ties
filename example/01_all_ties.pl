#!perl

use strict;
use warnings;

our $VERSION = 0;

require Tie::Sub;
use Locale::TextDomain 1.18 qw(test ./LocaleData/);
# the text domain -------------^^^^
# the path to the .mo file ---------^^^^^^^^^^^^^

## no critic (Ties)
tie my %__x,   'Tie::Sub', sub { return __x(shift) };
tie my %__n,   'Tie::Sub', sub { return __n(shift, shift, shift) };
tie my %__nx,  'Tie::Sub', sub { return __nx(shift, shift, shift, @_) };
tie my %__xn,  'Tie::Sub', sub { return __xn(shift, shift, shift, @_) };

tie my %__p,   'Tie::Sub', sub { return __p(shift, shift) };
tie my %__px,  'Tie::Sub', sub { return __px(shift, shift, @_) };
tie my %__np,  'Tie::Sub', sub { return __np(shift, shift, shift, shift) };
tie my %__npx, 'Tie::Sub', sub { return __npx(shift, shift, shift, shift, @_) };

tie my %N__,   'Tie::Sub', sub { return [N__(shift)] };
tie my %N__n,  'Tie::Sub', sub { return [N__n(shift, shift, shift)] };
tie my %N__p,  'Tie::Sub', sub { return [N__p(shift, shift)] };
tie my %N__np, 'Tie::Sub', sub { return [N__np(shift, shift, shift, shift)] };
## use critic (Ties)

# The construct 'shift, @_' or 'shift, shift, @_' is necessary
# because the module Locale::TextDomain uses prototypes.
# A simple '@_' does not work.

local $ENV{LANGUAGE} = 'de_DE';
# target language -----^^^^^^

() = print <<"EOT";
11 $__{'text1 original'}

21 $__x{'text1 original'} # __x without placeholders
22 $__x{[ 'text1 original' ]} # __x without placeholders and more common extractable
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

# $Id$