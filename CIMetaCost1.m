function [NLL,DL] = CIMetaCost1(b,X,e,lambda,alpha)
    [NLL,DL] = CIMetaCost(b,X,e);
    NLL = NLL + lambda*(1-alpha)*sum(b.*b)/2;
    DL = DL + lambda*(1-alpha)*b;
end