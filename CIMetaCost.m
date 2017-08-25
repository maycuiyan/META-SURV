function [NLL,DL] = CIMetaCost(b,X,e)
    NLL = 0;
    DL = 0;
    NE = 0;
    for i = 1:length(X)
        [nll,dl,ne] = CICost(b,X{i},e{i});
        NLL = NLL+nll;
        DL = DL+dl;
        NE = NE+ne;
    end
    NLL = NLL/NE;
    DL = DL(:)/NE;
end