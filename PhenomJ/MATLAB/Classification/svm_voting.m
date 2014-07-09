function [G,Gp_full] = svm_voting(svms,Z,flag,param)
% [G,Gp_full] = svm_voting(svms,Z,flag,param);
% Conduct majority voting between svms.
% Input:
%  svms            cell array containing trained SVM structs
%  Z               matrix of observations
%  flag            boolean, if true generate logical (boolean) output
% === Optional Input ===
%  param           array of parameterization labels, if svms is 2D and
%                  contains SVMs which are parameterized by e.g. by subsets
%                  of experimental conditions.
% Output:
%  G               vector of majority-determined classifications.
%                  If flag is false, G is left as a double value between
%                  zero and one. If flag is true, G is converted to a
%                  logical (binary) output.
%  Gp_full         if param is used, separate classifications for each
%                  parameter.
%
% Copyright (C) 2014 Daniel Asarnow
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

if nargin <= 2
    flag = false; % by default, do not binarize voting result
end

if nargin >= 4
    p = unique(param);
    np = length(p);
else
    np = 1;
end

N = size(Z,1);

if np == 1
    assert(nargin <= 3);
    m = length(svms);
    G = zeros(N,1);
    for i=1:length(svms)
        G = G + svmclassify(svms{i},Z);
    end
    G = G / m;

    if flag
        G = logical(round(G));
    end
else
    G = cell(np,1);
    [ms,ns] = size(svms);
    assert(ns==np);
    Gp_full = zeros(N,1);
    for j=1:np
        mask = param==p(j);
        n = nnz( mask );
        G{j} = zeros(n,1);
        for i=1:ms
            G{j} = G{j} + svmclassify(svms{i,j},Z(mask,:));
        end
        G{j} = G{j} / ms;

        if flag
            G{j} = logical(round(G{j}));
        end
        Gp_full( mask ) = G{j};
    end
end