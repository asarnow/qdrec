function T = th_maxlik(I,T,n)
% T =  th_maxlik(I,T,n)
%
% Find a global threshold for a grayscale image using the maximum likelihood
% via expectation maximization method.
%
% In:
%  I    grayscale image
%  T    initial threshold (defaults to Otsu)
%  n    maximum graylevel (defaults to 255)
%
% Out:
%  T    threshold
%
% References: 
%
% A. P. Dempster, N. M. Laird, and D. B. Rubin, "Maximum likelihood from
% incomplete data via the EM algorithm," Journal of the Royal Statistical
% Society, Series B, vol. 39, pp. 1-38, 1977.
%
% C. A. Glasbey, "An analysis of histogram-based thresholding algorithms,"
% CVGIP: Graphical Models and Image Processing, vol. 55, pp. 532-537, 1993.
%
% Copyright (C) 2004 Antti Niemist�
% See README for more copyright information.

if nargin < 3
  n = 255;
end
if nargin == 1
    T = round(graythresh(I)*n);
end

I = double(I);

% Calculate the histogram.
y = hist(I(:),0:n);

% The initial estimate for the threshold is found with the MINIMUM
% algorithm.
% T = th_minimum(I,n);


% Calculate initial values for the statistics.
mu = partSumB(y,T)/partSumA(y,T);
nu = (partSumB(y,n)-partSumB(y,T))/(partSumA(y,n)-partSumA(y,T));
p = partSumA(y,T)/partSumA(y,n);
q = (partSumA(y,n)-partSumA(y,T)) / partSumA(y,n);
sigma2 = partSumC(y,T)/partSumA(y,T)-mu^2;
tau2 = (partSumC(y,n)-partSumC(y,T)) / (partSumA(y,n)-partSumA(y,T)) - nu^2;

mu_prev = NaN;
nu_prev = NaN;
p_prev = NaN;
q_prev = NaN;
sigma2_prev = NaN;
tau2_prev = NaN;

phi = zeros(n,1);

while abs(mu-mu_prev) > eps || abs(nu-nu_prev) > eps || ...
      abs(p-p_prev) > eps || abs(q-q_prev) > eps || ...
      abs(sigma2-sigma2_prev) > eps || abs(tau2-tau2_prev) > eps
  for i = 0:n
    phi(i+1) = p/q * exp(-((i-mu)^2) / (2*sigma2)) / ...
        (p/sqrt(sigma2) * exp(-((i-mu)^2) / (2*sigma2)) + ... 
         (q/sqrt(tau2)) * exp(-((i-nu)^2) / (2*tau2)));
  end
  ind = 0:n;
  gamma = 1-phi;
  F = phi*y';
  G = gamma*y';
  p_prev = p;
  q_prev = q;
  mu_prev = mu;
  nu_prev = nu;
  sigma2_prev = nu;
  tau2_prev = nu;
  p = F/A(y,n);
  q = G/A(y,n);
  mu = ind.*phi*y'/F;
  nu = ind.*gamma*y'/G;
  sigma2 = ind.^2.*phi*y'/F - mu^2;
  tau2 = ind.^2.*gamma*y'/G - nu^2;
end

% The terms of the quadratic equation to be solved.
w0 = 1/sigma2-1/tau2;
w1 = mu/sigma2-nu/tau2;
w2 = mu^2/sigma2 - nu^2/tau2 + log10((sigma2*q^2)/(tau2*p^2));
  
% If the threshold would be imaginary, return with threshold set to zero.
sqterm = w1^2-w0*w2;
if sqterm < 0;
  T = 0;
  return
end

% The threshold is the integer part of the solution of the quadratic
% equation.
T = floor((w1+sqrt(sqterm))/w0);
end

function x = partSumA(y,j)
% x = A(y,j)
%
% The partial sum A from C. A. Glasbey, "An analysis of histogram-based
% thresholding algorithms," CVGIP: Graphical Models and Image Processing,
% vol. 55, pp. 532-537, 1993.
%
% In:
%  y    histogram
%  j    last index in the sum
%
% Out:
%  x    value of the sum
%  
%
% Copyright (C) 2004 Antti Niemist�
% See README for more copyright information.

x = sum(y(1:j+1));
end

function x = partSumB(y,j)
% x = B(y,j)
%
% The partial sum B from C. A. Glasbey, "An analysis of histogram-based
% thresholding algorithms," CVGIP: Graphical Models and Image Processing,
% vol. 55, pp. 532-537, 1993.
%
% In:
%  y    histogram
%  j    last index in the sum
%
% Out:
%  x    value of the sum
%  
%
% Copyright (C) 2004 Antti Niemist�
% See README for more copyright information.

ind = 0:j;
x = ind*y(1:j+1)';
end

function x = partSumC(y,j)
% x = C(y,j)
%
% The partial sum C from C. A. Glasbey, "An analysis of histogram-based
% thresholding algorithms," CVGIP: Graphical Models and Image Processing,
% vol. 55, pp. 532-537, 1993.
%
% In:
%  y    histogram
%  j    last index in the sum
%
% Out:
%  x    value of the sum
%  
%
% Copyright (C) 2004 Antti Niemist�
% See README for more copyright information.

ind = 0:j;
x = ind.^2*y(1:j+1)';
end

function T = th_minimum(I,n)
% T =  th_minimum(I,n)
%
% Find a global threshold for a grayscale image by choosing the threshold to
% be in the valley of the bimodal histogram. The method is also known as
% the mode method.
%
% In:
%  I    grayscale image
%  n    maximum graylevel (defaults to 255)
%
% Out:
%  T    threshold
%
% References: 
%
% J. M. S. Prewitt and M. L. Mendelsohn, "The analysis of cell images," in
% Annals of the New York Academy of Sciences, vol. 128, pp. 1035-1053, 1966.
%
% C. A. Glasbey, "An analysis of histogram-based thresholding algorithms,"
% CVGIP: Graphical Models and Image Processing, vol. 55, pp. 532-537, 1993.
%
% Copyright (C) 2004 Antti Niemist�
% See README for more copyright information.

if nargin == 1
  n = 255;
end

I = double(I);

% Calculate the histogram.
y = hist(I(:),0:n);

% Smooth the histogram by iterative three point mean filtering.
iter = 0;
while ~bimodtest(y)
  h = ones(1,3)/3;
  y = conv2(y,h,'same');
  iter = iter+1;
  % If the histogram turns out not to be bimodal, set T to zero.
  if iter > 10000;
    T = 0;
    return
  end
end

% The threshold is the minimum between the two peaks.
for k = 2:n
  if y(k-1) > y(k) && y(k+1) > y(k)
    T = k-1;
  end
end
end
