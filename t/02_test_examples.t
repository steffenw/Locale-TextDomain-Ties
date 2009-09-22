#!perl

use strict;
use warnings;

use Test::More;
use Test::Differences;
use Cwd qw(getcwd chdir);

$ENV{TEST_EXAMPLE} or plan(
    skip_all => 'Set $ENV{TEST_EXAMPLE} to run this test.'
);

plan(tests => 3);

my @data = (
    {
        test   => 'all_ties',
        path   => 'example',
        script => '01_all_ties.pl',
        result => <<'EOT',
11 text1 translated

21 text1 translated # __x without placeholders
22 text1 translated # __x without placeholders and more common extractable
23 text2 translated {text}
24 text3 translated plural
25 text3 translated singular # __nx without placeholders
26 text3 translated plural # __xn without placeholders
27 text4 translated 1 singular
28 text4 translated 2 plural

31 ctext1 translated
32 ctext1 translated # __px without placeholders
33 ctext2 translated is good
34 ctext3 translated plural
35 ctext4 translated 2 plural

41 text1 original
42 text1 original # alternative writing
43 text3 original singular text3 original plural 2
44 special ctext1 original
45 special ctext3 original singular ctext3 original plural 2
EOT
    },
    {
        test   => 'extract',
        path   => 'example',
        script => '02_extract.pl',
        result => <<'EOT',
EOT
    },
    {
        test   => 'pot',
        path   => 'example',
        script => q{-ne "print" extract.pot},
        result => <<'EOT',
msgid ""
msgstr ""
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"Plural-Forms: nplurals=2; plural=n != 1;"

#: 02_extract.pl:1
#: 02_extract.pl:3
#: 02_extract.pl:4
msgid "text1 original"
msgstr ""

#: 02_extract.pl:5
msgid "text2 original {text}"
msgstr ""

#: 02_extract.pl:6
#: 02_extract.pl:7
#: 02_extract.pl:8
msgid "text3 original singular"
msgid_plural "text3 original plural"
msgstr[0] ""

#: 02_extract.pl:9
#: 02_extract.pl:10
msgid "text4 original {num} singular"
msgid_plural "text4 original {num} plural"
msgstr[0] ""

#: 02_extract.pl:12
#: 02_extract.pl:13
msgctxt "special"
msgid "ctext1 original"
msgstr ""

#: 02_extract.pl:14
msgctxt "special"
msgid "ctext2 original {text}"
msgstr ""

#: 02_extract.pl:15
msgctxt "special"
msgid "ctext3 original singular"
msgid_plural "ctext3 original plural"
msgstr[0] ""

#: 02_extract.pl:16
msgctxt "special"
msgid "ctext4 original {num} singular"
msgid_plural "ctext4 original {num} plural"
msgstr[0] ""

EOT
    },
);

for my $data (@data) {
    my $dir = getcwd();
    chdir("$dir/$data->{path}");
    my $result = qx{perl $data->{script} 2>&3};
    chdir($dir);
    eq_or_diff(
        $result,
        $data->{result},
        $data->{test},
    );
}