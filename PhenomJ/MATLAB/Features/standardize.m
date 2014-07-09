function X = standardize(X,S)
% Standardize variable scales by dividing by standard deviation.
% Rows of X correspond to observations, columns to variables.
% S is an optional vector of scaling factors for each variable
% represented by the columns of X. If a second argument is not given
% the standard deviations of the variables are used.
% 
% Copyright (C) 2013 Daniel Asarnow
% San Francisco State University
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

X = bsxfun(@minus,X,mean(X));
if nargin == 1
    X = bsxfun(@rdivide,X,std(X));
else
    X = bsxfun(@rdivide,X,S);
end