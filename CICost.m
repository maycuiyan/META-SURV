function [nll,dl,ne] = CICost(b,X,e)

ne = size(e,1);
xb = X*b;
delta = xb(e(:,2))-xb(e(:,1));
nll = sum(max(0,1-delta));
count = zeros(1,size(X,1));
for  i = 1:size(e,1)
    if delta(i)<1
        count(e(i,1)) = count(e(i,1))+1;
        count(e(i,2)) = count(e(i,2))-1;
    end
end
dl = count*X;

