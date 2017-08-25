function [CI,N] = CIndex(days,status,pred)

n = length(days);
CI = 0;
N = 0;
for i = 1:n
    if status(i)==1
        idx = find(days>days(i));
        CI = CI+sum(pred(idx)>pred(i));
        N = N+length(idx);
    end
end
CI = CI/N;
