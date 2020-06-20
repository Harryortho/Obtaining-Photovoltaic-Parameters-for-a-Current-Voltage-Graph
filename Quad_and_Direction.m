## Copyright (C) 2016 user
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} Quad_and_Direction (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>
## Created: 2016-11-11

function [Result] = Quad_and_Direction (volts, amps, VocInd)

%Obtaining the quadrant and scan direction of the IV Data
%If the data begins in the upper or lower quadrant the current will 
%start of as positive or negative respectively

%Where the initial voltage and current points are:

%If negative the value is -1, means left side of the IV graph 
qV = sign(volts(VocInd));
%If negative the value is -1 and means bottom half of the IV graph
qC = sign(amps(1));

%If negative the direction is scanning from V...-Ve 
sV = mode(sign(diff(volts(1:VocInd))));
%If negative the direction is scanning from -I...0 . 
sC = mode(sign(diff(amps(1:VocInd))));

Result = [qV, qC, sV, sC];

endfunction
