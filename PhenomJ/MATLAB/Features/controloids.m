function CM = controloids(image_ids,control_ids,G,Z,avgfun)
% CM = controloids(image_ids,control_ids,G,Z,avgfun)
% Compute estimated control vectors and assemble for each parasite
% based on parasite population labels. The normal ('false' classification)
% control parasites are averaged, and the control vectors are duplicated
% in the correct order for classification of <parasite,control> feature
% vector tuples.
% Input:
%  image_ids     P x 1 array of integer population labels
%  control_ids   P x 1 array of control pop. labels for each pop.
%  G             P x 1 logical array of classifications
%  Z             P x D matrix of parasite features
%  avgfun        function handle to averaging function (e.g. median)        
% Output:
%  CM            P x D matrix of average control features
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

normal = ~G;
controlsu = unique(control_ids);
controloid = avgfun(Z(image_ids == control_ids & normal,:));
CM = nan(size(Z));
for i=1:length(controlsu)
    idx = controlsu(i);
    control_loc = image_ids == idx;
    loc = control_ids == idx;
    if nnz(control_loc & normal) > 0
        control_medoid = avgfun( Z(control_loc & normal,:) );
    else
        control_medoid = controloid;
    end
    CM(loc,:) = repmat(control_medoid,[nnz(loc) 1]);
end