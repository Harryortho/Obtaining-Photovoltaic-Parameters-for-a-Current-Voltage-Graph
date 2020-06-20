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
## @deftypefn {Function File} {@var{retval} =} OutputQuadrant (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>
## Created: 2016-11-14

function [Quadrant] = OutputQuadrant (Quadrant_Direction)
quadBank=...
[...
-1,1,-1,-1; %Top Left scan (Neg V, Pos C, ΔV: -ve, ΔC: = -ve)
-1,1,1,1; %Top Left scan (Neg V, Pos C, ΔV: +ve, ΔC: = +ve)

1,1,1,-1; %Top Right scan (Pos V, Pos C,  ΔV: +ve, ΔC: = -ve)
1,1,-1,1; %Top Right scan (Pos V, Pos C,  ΔV: -ve, ΔC: = +ve)

-1,-1,1,-1; %Bottom Left scan (Neg V, Neg C, ΔV: +ve, ΔC: =-ve)
-1,-1,-1,1; %Bottom Left scan (Neg V, Neg C, ΔV: -ve, ΔC: =+ve)

1,-1,-1,-1; %Bottom Right scan (Pos V, Neg C, ΔV: -ve, ΔC: =-ve)
1,-1,1,1; %Bottom Right scan (Pos V, Neg C, ΔV: +ve, ΔC: =+ve)
];

Test = Quadrant_Direction==quadBank;
Result= zeros(8,1);

for row = 1:8
 Result(row,1) = sum(Test(row,:));
endfor

%The function below obtains the row with the largest value which was
%the sum of the true and false values, thus the row value is the one
%which has sum of 1,1,1,1 = 4 thus this should be the aknowledged row for
%the rest of the code.
QuadRowAns= find(Result==max(Result));

TLd=[-1,1,-1,-1]; TLu=[-1,1,1,1];
TRd=[1, 1, 1, -1]; TRu=[1,1,-1,1];
BRd=[-1,-1,1,-1]; BRu=[-1,-1,-1,1];
BLu=[1,-1,-1,-1]; BLd=[1,-1,1,1];

QuadList = ...
{TLd,'TLd'; TLu, 'TLu';...
 TRd,'TRd'; TRu,'TRu'; ...
 BRd, 'BRd'; BRu, 'BRu'; ...
 BLu,'BLu'; BLd,'BLd'};
%State the quadrant that has been detected for the data
disp(Quadrant = QuadList{QuadRowAns,2});
endfunction