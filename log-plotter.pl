#!/usr/bin/perl

use strict;
use warnings;
use Date::Parse;
use Chart::Gnuplot;

my $filename = $ARGV[0]
  or die "Usage: $0 <filename>";

open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $re = qr/2017-03/; # if not every line
my $lines = 0;
my @x_vals; my @y_vals;
while (my $row = <$fh>) {
  $lines += 1;
  if ($row =~ $re) {
    my $time = str2time(substr($row, 0, 19)); # 0-23
    push @x_vals, $time;
    push @y_vals, $lines;
   }
}

my $chart = Chart::Gnuplot->new(
    output   => "plot-$filename.png",
    title    => $filename,
    xlabel   => 'time',
    ylabel   => 'lines',
    xrange   => [$x_vals[0], $x_vals[$#x_vals]],
    yrange   => [0, $y_vals[$#y_vals]],
    timeaxis => 'x',
    bg       => 'white',
);
my $dataset = Chart::Gnuplot::DataSet->new(
    xdata => \@x_vals,
    ydata => \@y_vals,
    #title => 'lines vs time',
    style => 'linespoints', # 'dots'
    timefmt => '%s', #'%Y-%m-%d %H:%M:%S',
);

$chart->plot2d($dataset);
