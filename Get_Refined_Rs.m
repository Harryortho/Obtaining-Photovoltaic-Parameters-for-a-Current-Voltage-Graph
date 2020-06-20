
## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} Resistance_Refine (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>
## Created: 2016-01-07
%, [ResistanceEnd,New_RMSE, New_ERR]
%function [ResistanceEnd, RsUpp, RsLow] = Get_Refined_Rs (Resistance, ...
%HighResistance, LowResistance,Error)
%%Chooseing Rs_low or Rs_upp
%RsLow = LowResistance;
%RsUpp = HighResistance;
%negErrRs =(Resistance +LowResistance)/2;
%PosErrRs = (Resistance +HighResistance)/2;
%Error(Error<0) = negErrRs;
%Error(Error>0) = PosErrRs; trying to speed things up but need the if

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} Resistance_Refine (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>
## Created: 2016-01-07
%, [ResistanceEnd,New_RMSE, New_ERR]
function [ResistanceEnd, RsUpp, RsLow] = Get_Refined_Rs (Resistance, ...
  HighResistance, LowResistance,Error)
%Chooseing Rs_low or Rs_upp
RsLow = LowResistance;
RsUpp = HighResistance;
%Check =  [Resistance,  HighResistance, LowResistance, Error]
%  Resistance = ((Error>1)==1)*((Resistance +LowResistance)/2)...
%  + ((Error<1)==1)*((Resistance +HighResistance)/2);
%  RsUpp = ((Error>1)==1)*Resistance+((Error<1)==1)*HighResistance;
%  RsLow = ((Error<1)==1)*Resistance+((Error>1)==1)*LowResistance;
if Error > 0
   Resistance = (Resistance +LowResistance)/2;
   RsUpp = Resistance;
   
   elseif Error <0
   
   Resistance = (Resistance+HighResistance)/2;
   RsLow =Resistance ;
endif
  ResistanceEnd = Resistance;
endfunction