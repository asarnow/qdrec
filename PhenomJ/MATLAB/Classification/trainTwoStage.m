function [R,cm,svms2,svms1] = trainTwoStage(parasites,G,svmsInfo)
% R = trainTwoStage(parasites,svms2,svms1);
% Input:
%  parasites P x 1 parastite feature struct array
%  G         P x 1 logical array binary classifications for training set
%  svmsInfo  struct holding classifier parameter
% Output:
%  R         N x 2 response matrix for the N populations represented
%            in parasites. First column contains quantal responses,
%            second column contains parasite counts. Values are
%            computed for training set using cross-validation.
%  cm        confusion matrix for cross-validated classifications
%  svms2     cell array of second-stage classifiers; pass empty vector to
%            skip second stage.
%  svms1     cell array of first-stage classifiers
% 
% Prepare sets of stage-one and stage-two classifiers using
% cross-validation. The parasites struct should be produced using
% extractDescriptors.
%
% The svmsInfo struct should contain a field named "classifier" with a
% value of 0, 1, 2 or 3 for SVM (RBF), SVM (linear), Naive Bayes and Random
% Forests, respectively, as well as a field named "twoStage" containing
% true for two-stage classification or false for one-stage classification.
% Both SVM classifiers also require fields named "C" for the soft-margin
% box contraint, "kktlevel" to hold the permitted KKT violation level, and
% "tolkkt" for the tolerance on the KKT conditions.  The RBF kernel
% requires another field named "sigma" for its scale parameter.
% Naive Bayes requires no parameters, and Random Forest requires a single
% "nTrees" parameter defining the number of classification trees to be
% employed.
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
% Re-format training classifications.
G = ~G(cleanidx)';
% Train stage-one classifier.
[Gp1,svms1] = trainClassifier(Z,G,svmsInfo);
% Check for trivial classification.
if all(~Gp1)
    Gp1 = true(size(Gp1));
end
Gp1 = ~Gp1;
if svmsInfo.twoStage
    % Create average control feature vectors based on first stage
    % classification.
    CM = controloids(VI,VCI,Gp1,Z,@(x)mean(x,1));
    % Train stage-two classifier using <parasite,control> feature vector
    % tuples.
    [Gp2,svms2] = trainClassifier([Z CM],G,svmsInfo);
    Gp2 = ~Gp2;
else
    Gp2 = Gp1;
    svms2 = [];
end
% Compute population response matrix using cross-validated classifications.
R = parasite_response(VI,Gp2);
% Compute cross-validated confusion matrix.
[~,cm] = confusion(~G',Gp2');