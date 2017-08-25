function b_est = cvMeta(X,y,c,alpha)
    % FUNCTION:
    %   work horse function for model training using cross-validation
    % INPUT:
    %   X: K*1 cell array, X{k} is n_k*d matrix of data
    %   y: K*1 cell array, y{k} is n_k*1 vector of survival time
    %   c: K*1 cell array, c{k} is n_k*1 vector of event status.
    %   alpha: a control parameter balancing L1/L2 norms.
    % OUTPUT:
    %   b_est: d*1 vector of estimated coefficients for each feature
    
    % construct an adjacency list, facilitate computing cost funciton
    e = cell(length(c),1);
    for i = 1:length(c)
        e{i} = CIEdges(y{i},c{i});
    end
    
    % initialize grid of regularization
    d = size(X{1},2);
    gOptions.verbose = 0;
    b_init = zeros(d,1);
    [~,dl0] = CIMetaCost(b_init,X,e);
    lambda_max = max(abs(dl0))/0.05;
    lambda = logspace(log10(lambda_max*0.001),log10(lambda_max/10),100);
    
    % leave-one-dataset-out cross-validation
    h = waitbar(0,'Please wait...');
    for j = 1:length(lambda)
        waitbar(j/length(lambda))
        lambdaVec = lambda(j)*ones(d,1);
        for k = 1:length(X)
            funObj = @(b)CIMetaCost1(b,X(1:end~=k),e(1:end~=k),lambda(j),alpha);
            b_est = L1General2_PSSgb(funObj,b_init,alpha*lambdaVec,gOptions);
            [nll(j,k),~] = CICost(b_est,X{k},e{k});
            b_init = b_est;
        end
    end
    close(h)
    
    % get coefficients using lambda corresponding to minimum cv cost
    [~,idxmin] = min(sum(nll,2));
    lambda_min = lambda(idxmin);
    funObj = @(b)CIMetaCost1(b,X,e,lambda_min,alpha);
    b_init = zeros(d,1);
    lambdaVec = lambda_min*ones(d,1);
    b_est = L1General2_PSSgb(funObj,b_init,alpha*lambdaVec,gOptions);
end