function R = parasite_response(VI,G)
% R = parasite_response(VI,G);
% Input:
%  VI - P x 1 numerical array of integer labels of parasite population
%  G - P x 1 logical array of binary parasite classifications
% Output:
%  R - N x 2 matrix of responses and parasite counts
% 
% R contains a row for each of N unique population labels.
% The first column contains the quantal response for the population
% and the second column contains the number of parasites.
% The quantal response is defined as the proportion of 'true'
% classifications in each population.
%
% Copyright (C) 2014 Daniel Asarnow
% San Francsico State University
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

R = zeros(max(VI),2);
for i=1:max(VI)
    pMask = VI==i;
    R(i,1) = nnz(G(pMask)) / nnz(pMask);
    R(i,2) = nnz(pMask);
end