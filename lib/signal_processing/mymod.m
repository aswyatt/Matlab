function [M, n] = mymod(x,y)
% mymod: Modulus after division.
%
%	[M, n] = mymod(x,y);
%
%   M = x - n.*y where n = floor(x./y) if y ~= 0.  If y is not an
%   integer and the quotient x./y is within roundoff error of an integer,
%   then n is that integer.  The inputs x and y must be real arrays of the
%   same size, or real scalars.
%
%   The statement "x and y are congruent mod m" means mod(x,m) == mod(y,m).
%
%   By convention:
%      MOD(x,0) is x.
%      MOD(x,x) is 0.
%      MOD(x,y), for x~=y and y~=0, has the same sign as y.
%
%   Note: REM(x,y), for x~=y and y~=0, has the same sign as x.
%   MOD(x,y) and REM(x,y) are equal if x and y have the same sign, but
%   differ by y if x and y have different signs.
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)
%
%   See also MOD, REM, MYREM.

n = floor(x./y);
M = x-n.*y;