function relevantEdges = findRelevantEdges3(bw,edges)
% Identity subset of edges relevant to binary image bw.
% Edges are considered relevant if they are capable of separating regions,
% that is, if there is more than one region label present in their
% 8-neighborhood.
%
% Described in:
% D. Asarnow and R. Singh,
% "Segmenting the Etiological Agent of Schistosomiasis
% for High-Content Screening," 
% IEEE Transactions on Medical Imaging, 
% vol. 32, no. 6, pp. 1007-10018, 2013.
% 
% A. Moody-Davis, L. Mennillo and R. Singh, 
% "Region Based Segmentation of Parasites for High-Throughput Screening," 
% G. Bebis et al. (Eds.): International Symposium on Visiual Computing, 
% Part I, LNCS 6938, pp. 44-54, 2011.
%
% Copyright (C) 2013 Daniel Asarnow
% Laurent Mennillo
% Rahul Singh
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

% lo = graythresh(gr)*0.15;
% hi = graythresh(gr)*0.3;
% edges = edge(gr, 'canny',[]);

% markers = bw - edges;
% markers = im2bw(markers);
markers = bw;
markers(edges) = 0;
% ar = bwarea(markers);
% labelsTmp1 = bwlabel(markers, 4);
% nr = max(max(labelsTmp1));
% [mu,sigma] = bwstats(markers);
% markers = bwareaopen(markers,round(mu+sigma));
% imwrite(markers, '1-markers.png', 'png');
% markers = bwareaopen(markers,10);

labelsTmp1 = bwlabel(markers, 4);
% imwrite(labelsTmp1, '2-labelsTmp1.png', 'png');

relevantEdges = zeros(size(labelsTmp1, 1), size(labelsTmp1, 2));
% idx = find(edges);
for r = 2 : size(labelsTmp1, 1)-1
    for c = 2 : size(labelsTmp1, 2)-1
% for i = idx
%     [r,c] = ind2sub(size(labelsTmp1),i);
        if (edges(r,c) == 1)
            relevantPixel = false;
            labelTmp = -1;
            for offset1 = -1 : 1
                for offset2 = -1 : 1
                    if (labelsTmp1((r + offset1), (c + offset2)) ~= 0) ...
%                             && (bw((x + offset1), (y + offset2)) ~= 0)
                        if (labelTmp == -1);
                            labelTmp = labelsTmp1((r + offset1), (c + offset2));
                        else
                            if (labelsTmp1((r + offset1), (c + offset2)) ~= labelTmp)
                                relevantPixel = true;
                                break;
                            end
                        end
                    end
                end
                if (relevantPixel)
                    break;
                end
            end
            if (relevantPixel)
                relevantEdges(r,c) = 1;
            end
        end
    end
end

% relevantEdges = imdilate(relevantEdges, [strel('line',3,90) strel('line',3,0)]);
% Strenghtening edges to separate 8-connected components
% relevantEdges = bwmorph(relevantEdges, 'diag');
% relevantEdges = bwmorph(relevantEdges, 'dilate');
% relevantEdges = bwareaopen(relevantEdges,10);
% relevantEdges = bwmorph(relevantEdges,'thin',Inf);