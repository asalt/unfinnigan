package Finnigan::Peaks;

use strict;
use warnings;

use Finnigan;
use base 'Finnigan::Decoder';


sub decode {
  my $self = bless Finnigan::Decoder->read($_[1], ["count" => ['V', 'UInt32']]), $_[0];
  return $self->iterate_object(
                               $_[1],
                               $self->{data}->{count}->{value},
                               peaks => 'Finnigan::Peak'
                              );
}

sub count {
  shift->{data}->{count}->{value};
}

sub peaks {
  shift->{data}->{peaks}->{value};
}

sub peak {
  shift->{data}->{peaks}->{value};
}

sub all {
  my $d;
  return [
          map {$d = $_->{data}; [$d->{mz}->{value}, $d->{abundance}->{value}]}
          @{$_[0]->{data}->{peaks}->{value}}
         ];
}

sub list {
  my $self = shift;
  foreach my $peak ( @{$self->peaks} ) {
    print "$peak\n";
  }
}

1;
__END__

=head1 NAME

Finnigan::ScanIndexEntry -- decoder for ScanIndexEntry, a linked list item pointing to scan data

=head1 SYNOPSIS

  use Finnigan;
  my $entry = Finnigan::ScanIndexEntry->decode(\*INPUT);
  say $entry->offset; # returns an offset from the start of scan data stream 
  say $entry->data_size;
  $entry->dump;

=head1 DESCRIPTION

ScanIndexEntry is a static (fixed-size) structure containing the
pointer to a scan, the scan's data size and some auxiliary information
about the scan.

ScanIndexEntry elements seem to form a linked list. Each
ScanIndexEntry contains the index of the next entry.

Although in all observed instances the scans were sequential and their
indices could be ignored, it may not always be the case.

It is not clear whether scan index numbers start at 0 or at 1. If they
start at 0, the list link index must point to the next item. If they
start at 1, then "index" will become "previous" and "next" becomes
"index" -- the list will be linked from tail to head. Although
observations are lacking, I am inclined to interpret it as a
forward-linked list, simply from common sense.


=head2 EXPORT

None

=head1 SEE ALSO

Finnigan::RunHeader

=head1 AUTHOR

Gene Selkov, E<lt>selkovjr@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Gene Selkov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
