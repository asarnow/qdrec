function [R,Gp,Gp1] = testTwoStage(parasites,svms2,svms1,votingfun)
% R = testTwoStage(parasites,svms2,svms1);
% Input:
%  parasites P x 1 parastite feature struct array
%  svms2     Cell array of trained classifiers for <parasite,control>
%            tuples of feature vectors. Pass empty vector to skip second
%            stage
%  svms1     Cell array of trained classifiers for raw parasite
%            feature vectors
%  votingfun Function handle to voting function for the classifier banks
%            (e.g. svm_voting, nb_voting, tb_voting)
% Output:
%  R         N x 2 response matrix for the N populations represented
%            in parasites. First column contains quantal responses,
%            calculated using two-stage classification, and the second
%            column contains parasite counts.
% Gp         N x 1 logical array containing two-stage classification result
% Gp1        N x 1 logical array containing one-stage classification result
% 
% Applies the two SVMs to parasite feature data to perform the two stage
% classification method. In the first stage, control parasites are
% classified and the normal parasites are averaged. In the second stage,
% the parasites are all re-classified using a tuple of their raw feature
% vector and the appropriate average control vector.
%
% If svms2 is equal to the empty vector [], only one-stage classification
% is performed. In this case, R will be calculated using the one-stage
% result and Gp and Gp1 will be equal.
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

if nargin < 4
    votingfun = @svm_voting;
end

% Convert feature struct to matrix of feature vectors.
Z = descToZDat(parasites);
% Standardize features, discarding parasites with NaN values.
cleanidx = all(~isnan(Z),2);
Z = standardize(Z(cleanidx,:));
% Extract source image names.
vidsbl = unique(cellfun(@lower,{parasites(cleanidx).Video}','UniformOutput',false));
% Extract image population labels.
[~,~,VI] = unique([parasites(cleanidx).VideoIndex]');
% Determine control population labels.
VCI = vids2controls(vidsbl);
% Control pop. labels for each parasite.
VCI = VCI(VI);
% Classify in first stage using majority vote of classifiers.
Gp1 = votingfun(svms1,Z,1);
% Check for trivial classification.
if all(~Gp1)
    Gp1 = true(size(Gp1));
end
Gp1 = ~Gp1;
% Skip second stage if not requested
if ~isempty(svms2)
    % Create average control feature vectors based on first stage
    % classification.
    CM = controloids(VI,VCI,Gp1,Z,@(x)mean(x,1));
    % Majority voting in second stage using <parasite,control> feature vector
    % tuples.
    Gp = ~votingfun(svms2,[Z CM],1);
else
    Gp = Gp1;
end
% Compute response matrix for output.
R = parasite_response(VI,Gp);