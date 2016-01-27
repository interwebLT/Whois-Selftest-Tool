use strict;
use warnings;
use 5.014;

use Test::More tests => 6;
use Test::Differences;
use PDT::TS::Whois::Lexer;
use PDT::TS::Whois::Validator qw( validate );
use PDT::TS::Whois::Grammar qw( $grammar );
use PDT::TS::Whois::Types;

sub accept_registrar {
    my $test_name = shift;
    my $input     = shift =~ s/\r?$/\r/gmr;

    my $types = PDT::TS::Whois::Types->new;
    $types->add_type( 'query registrar name' => sub { return (shift !~ /Example Registrar, Inc\./ ) ? ( 'expected matching registrar name' ) : () } );

    my $lexer     = PDT::TS::Whois::Lexer->new( $input );
    my @errors    = validate( rule => 'Registrar Object query', lexer => $lexer, grammar => $grammar, types => $types );
    eq_or_diff \@errors, [], 'Should accept valid registrar reply';
}

accept_registrar 'Fax number section type A, empty' => <<EOF;
Registrar Name: Example Registrar, Inc.
Street: 1234 Admiralty Way
City: Marina del Rey
State/Province: CA
Postal Code:
Country: US
Phone Number: +1.3105551212
Fax Number: +1.3105551213
Fax Ext:
Fax Number: +1.3105551214
Email: registrar\@example.tld
WHOIS Server:
Referral URL: http://www.example-registrar.tld
>>> Last update of WHOIS database: 2009-05-29T20:15:00Z <<<

For more information on Whois status codes, please visit https://icann.org/epp

Disclaimer: This is a legal disclaimer.
EOF

accept_registrar 'Fax number section type A, omitted' => <<EOF;
Registrar Name: Example Registrar, Inc.
Street: 1234 Admiralty Way
City: Marina del Rey
State/Province: CA
Country: US
Phone Number: +1.3105551212
Fax Number: +1.3105551213
Fax Ext:
Fax Number: +1.3105551214
Email: registrar\@example.tld
Referral URL: http://www.example-registrar.tld
>>> Last update of WHOIS database: 2009-05-29T20:15:00Z <<<

For more information on Whois status codes, please visit https://icann.org/epp

Disclaimer: This is a legal disclaimer.
EOF

accept_registrar 'Fax number section type B, non-empty field' => <<EOF;
Registrar Name: Example Registrar, Inc.
Street: 1234 Admiralty Way
City: Marina del Rey
State/Province: CA
Postal Code:
Country: US
Phone Number: +1.3105551212
Fax Number:
Fax Ext: 567
Email: registrar\@example.tld
WHOIS Server:
Referral URL: http://www.example-registrar.tld
>>> Last update of WHOIS database: 2009-05-29T20:15:00Z <<<

For more information on Whois status codes, please visit https://icann.org/epp

Disclaimer: This is a legal disclaimer.
EOF

accept_registrar 'Fax number section type B, empty field' => <<EOF;
Registrar Name: Example Registrar, Inc.
Street: 1234 Admiralty Way
City: Marina del Rey
State/Province: CA
Postal Code:
Country: US
Phone Number: +1.3105551212
Fax Number:
Fax Ext:
Email: registrar\@example.tld
WHOIS Server:
Referral URL: http://www.example-registrar.tld
>>> Last update of WHOIS database: 2009-05-29T20:15:00Z <<<

For more information on Whois status codes, please visit https://icann.org/epp

Disclaimer: This is a legal disclaimer.
EOF

accept_registrar 'Fax number section type B, omitted field' => <<EOF;
Registrar Name: Example Registrar, Inc.
Street: 1234 Admiralty Way
City: Marina del Rey
State/Province: CA
Postal Code:
Country: US
Phone Number: +1.3105551212
Fax Number:
Email: registrar\@example.tld
WHOIS Server:
Referral URL: http://www.example-registrar.tld
>>> Last update of WHOIS database: 2009-05-29T20:15:00Z <<<

For more information on Whois status codes, please visit https://icann.org/epp

Disclaimer: This is a legal disclaimer.
EOF

accept_registrar 'Fax number section type C' => <<EOF;
Registrar Name: Example Registrar, Inc.
Street: 1234 Admiralty Way
City: Marina del Rey
State/Province: CA
Country: US
Phone Number: +1.3105551212
Email: registrar\@example.tld
Referral URL: http://www.example-registrar.tld
>>> Last update of WHOIS database: 2009-05-29T20:15:00Z <<<

For more information on Whois status codes, please visit https://icann.org/epp

Disclaimer: This is a legal disclaimer.
EOF
