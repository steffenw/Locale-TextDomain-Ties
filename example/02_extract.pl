#!perl

use strict;
use warnings;

our $VERSION = 0;

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

# simplified extracting rules because q{...} is not allowed
my $text_rule = q{( (?: \\\\ \\\\ | \\\\ ' | [^'] )+ )};
my @rules = (
    # text
    qr{\$ __ ( x            )? \{ \[? \s* '$text_rule'}xmso,
    # text plural
    qr{\$ __ ( n | nx | xn  )? \{ \[  \s* '$text_rule' , \s* '$text_rule'}xmso,
    # text context
    qr{\$ __ ( px?          )? \{ \[  \s* '$text_rule' , \s* '$text_rule'}xmso,
    # text context plural
    qr{\$ __ ( np | npx     )? \{ \[  \s* '$text_rule' , \s* '$text_rule' , \s* '$text_rule'}xmso,
);

my @pot_data;

# extract pot data
my $line_number = 1;
for my $line (split m{\n}xms, $text) {
    RULE: for my $rule (@rules) {
        my @result = $line =~ $rule
            or next RULE;
        # found
        $line =~ s{$rule}{}xms; # delete found string
        my $format = shift @result || q{};
        push @pot_data, {
            # where found
            reference    => __FILE__ . ":$line_number",
            # optional context
            msgctxt      => $format =~ m{p}xms
                            ? shift @result
                            # DBD::PO fetch NULL as empty string
                            : q{},
            # the original text
            msgid        => shift @result,
            # optional origninal text in the plural form
            msgid_plural => $format =~ m{n}xms
                            ? shift @result
                            # DBD::PO fetch NULL as empty string
                           : q{},
        };
        redo RULE; # possibly more in a line
    }
    ++$line_number;
}

# Deleting the pot file if this exists,
# so that this example can be going on repeatedly.
unlink 'extract.pot';

# create a new pot file
my $dbh = DBI->connect(
    'DBI:PO:po_charset=UTF-8',
    undef,
    undef,
    {RaiseError => 1},
);
$dbh->do(<<'EO_SQL');
     CREATE TABLE extract.pot (
         reference    VARCHAR,
         msgctxt      VARCHAR,
         msgid        VARCHAR,
         msgid_plural VARCHAR
     )
EO_SQL

# write the header
my $header_msgstr = $dbh->func(
    { 'Plural-Forms' => 'nplurals=2; plural=n != 1;' },
    'build_header_msgstr',
);
$dbh->do(<<'EO_SQL', undef, $header_msgstr);
     INSERT INTO extract.pot
     (msgstr)
     VALUES (?)
EO_SQL

# to check if the entry is known
my $sth_select = $dbh->prepare(<<'EO_SQL');
     SELECT reference
     FROM extract.pot
     WHERE
         msgctxt=?
         AND msgid=?
         AND msgid_plural=?
EO_SQL

# to insert a new entry
my $sth_insert = $dbh->prepare(<<'EO_SQL');
     INSERT INTO extract.pot
     (reference, msgctxt, msgid, msgid_plural)
     VALUES (?, ?, ?, ?)
EO_SQL

# to add the next reference to a known entry
my $sth_update = $dbh->prepare(<<'EO_SQL');
     UPDATE extract.pot
     SET reference=?
     WHERE
         msgctxt=?
         AND msgid=?
         AND msgid_plural=?
EO_SQL

# write entrys
for my $entry (@pot_data) {
    $sth_select->execute(
    	@{$entry}{ qw(msgctxt msgid msgid_plural) },
    );
    my ($reference) = $sth_select->fetchrow_array();
    if ($reference && length $reference) {
        # Concat with the po_separator. The default is "\n".
        $reference = "$reference\n$entry->{reference}";
        $sth_update->execute(
            $reference,
            @{$entry}{ qw(msgctxt msgid msgid_plural) },
        );
    }
    else {
        $sth_insert->execute(
            @{$entry}{ qw(reference msgctxt msgid msgid_plural) },
        );
    }
}

# all finished
for ($sth_select, $sth_insert, $sth_update) {
    $_->finish();
}
$dbh->disconnect();

# $Id$