#!/usr/bin/perl -w

use strict;
use Spreadsheet::ParseExcel;
use HTML::Entities;

binmode STDOUT, ":utf8";

my $output = "";
my $oExcel = new Spreadsheet::ParseExcel;
my ($oWkS);

die "You must provide a filename to $0 to be parsed as an excel file" unless @ARGV;

my $oBook = $oExcel->Parse($ARGV[0]);

#print "FILE  :", $oBook->{File} , "\n";
#print "COUNT :", $oBook->{SheetCount} , "\n";
#print "AUTHOR:", $oBook->{Author} , "\n" if defined $oBook->{Author};

if (defined($ARGV[3])) {
    $oWkS = $oBook->{Worksheet}[$ARGV[3]];

    extract($oWkS);
} else {
    for (my $iSheet = 0; $iSheet < $oBook->{SheetCount} ; $iSheet++) {
        $oWkS = $oBook->{Worksheet}[$iSheet];
        
        extract($oWkS);
    }
}

sub extract {
    my ($oWkS) = @_;
    my ($iR, $iC, $oWkC, $col, $cols, $temp, $value, $valid);
    
    #print "--------- SHEET:", $oWkS->{Name}, "\n";
    for (my $iR = $oWkS->{MinRow} ; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ; $iR++) {
        $valid = 0;
        $output = "\"" . $ARGV[1] . "\"";
        #for (my $iC = $oWkS->{MinCol} ; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ; $iC++) {
        if (defined($ARGV[2])) {
            foreach $col (split(/,/, $ARGV[2])) {
                $output .= ",\"";
                $temp = '';
                
                if ($col =~ /\+/) {
                    #$output .= "\"";
                    foreach $cols (split(/\+/, $col)) {
                        $oWkC = $oWkS->{Cells}[$iR][$cols];
                        #print "( $iR , $iC ) =>", $oWkC->Value, "\n" if($oWkC);
                        $output .= strip($oWkC->Value) . " " if ($oWkC);
                    }
                    $output .= "\"";
                    
                } else {
                    #$output .= "\"";
                    if (substr($col,0,1) eq 'E') {
                        $col = substr($col,1);
                        $oWkC = $oWkS->{Cells}[$iR][$col];
                        if ($oWkC) {
                            $value = striptonum($oWkC->Value);
                            
                            if (($value ne "") && is_numeric($value)) {
                                $temp = ($value * 1.1);
                                # print $temp . "\n";
                            }
                            
                        } else {
                            $value = 0;
                        }
                        
                    } else {
                        $oWkC = $oWkS->{Cells}[$iR][$col];
                        $temp = $oWkC->Value if ($oWkC);
                    }
                    
                    #print "( $iR , $iC ) =>", $oWkC->Value, "\n" if($oWkC);
                    #$output .= "\"";
                    $output .= strip($temp) if ($temp);
                    $output .= "\"";
                }
                
                if ($temp) {
                    $valid = 1;
                }
            }
        } else {
            $oWkC = $oWkS->{Cells}[$iR][$iC];
            #print "( $iR , $iC ) =>", $oWkC->Value, "\n" if($oWkC);
            $output .= strip($oWkC->Value) . "\"" if ($oWkC);
        }
        #}
        
        #chomp $output;
        #chomp $output;
        if ($valid) {
            print "$output\n";
        }
    }
}

sub strip {
    my ($string) = @_;
    
    $string =~ s/\"//g;
    $string =~ s/^\s+//g;
    $string =~ s/\s+$//g;
    $string =~ s/[\$\,]//g;

    decode_entities($string);

    return $string;
}

sub striptonum {
    my ($string) = @_;
    
    #$string =~ s/[\s\$A-Za-z,\-:\/\@\"]//g;
    $string =~ s/^[0-9\.]//g;
    $string =~ s/[\$\,]//g;
    #$string = getnum($string);
    
    return $string;
}

sub getnum {
    use POSIX qw(strtod);
    my $str = shift;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    $! = 0;
    my($num, $unparsed) = strtod($str);
    if (($str eq '') || ($unparsed != 0) || $!) {
        return;
    } else {
        return $num;
    } 
} 

sub is_numeric { defined scalar &getnum } 
