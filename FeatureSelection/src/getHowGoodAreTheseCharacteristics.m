function [ goodness, projection, sensitivity, specificity, oddsRatio] = getHowGoodAreTheseCharacteristics(characteristics, labels, weightsOfCharac, usedMethod)
%GETHOWGOODARETHESECHARACTERISTICS Summary of this function goes here
%   Detailed explanation goes here
if isequal(lower(usedMethod), lower('PCA'))
    %% ---- PCA feature selection -----%
    % Luciano's Method: As grouped and clusters go further from each other
    % the better.
    projection = characteristics * weightsOfCharac;
    [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(projection, labels, 2);
    C = sinterluc/sintraluc;
    goodness = trace(C);
    sensitivity = -1;
    specificity = -1;
elseif isequal(lower(usedMethod), lower('DA'))
    %% ----- Discriminant analysis feature selection ------%
    W = LDA(characteristics, labels');
    L = [ones(size(characteristics, 1), 1) characteristics] * W';
    L = L(:, 1:2);
    [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(L, labels, max(labels));
    C = sinterluc/sintraluc;
    goodness = trace(C);
    %clustered = evalclusters(L, labels, 'silhouette');
    %seperated = evalclusters(L, labels, 'CalinskiHarabasz');
    %goodness = clustered.CriterionValues + seperated.CriterionValues/100;
    weights = characteristics \ L;
    projection = characteristics * normalizeVector(weights);
    
    sensitivity = -1;
    specificity = -1;
elseif isequal(lower(usedMethod), lower('NCA'))
    %% ----- Neighborhood component analysis (NCA) NOT SUPPORTED YET ------%
    mdl = fscnca(characteristics, labels);
    [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(mdl, labels, max(labels));
    C = sinterluc/sintraluc;
    goodness = trace(C);
    %clustered = evalclusters(L, labels, 'silhouette');
    %seperated = evalclusters(L, labels, 'CalinskiHarabasz');
    weights = characteristics \ L;
    projection = characteristics * normalizeVector(weights);
elseif isequal(lower(usedMethod), lower('LogisticRegression'))
    lastwarn('')
    labels = labels - 1;
    priorWeights = labels;
    priorWeights(labels==0) = sum(labels == 1)/length(labels);
    priorWeights(labels==1) = sum(labels == 0)/length(labels);
    [B,FitInfo] = lassoglm(characteristics, labels, 'binomial');
    b = vertcat(FitInfo.Intercept(1), B(:, 1));
    [b,dev,stats] = glmfit(characteristics, labels, 'binomial', 'weights', priorWeights); % Logistic regression
%     msgWarn = lastwarn();
%     if isempty(strfind(msgWarn, 'The estimated coefficients perfectly separate failures from successes')) == 0
%         disp('yuhuuu');
%     end
    yfit = 1 ./ (1 + exp(-(b(1) + characteristics * (b(2:end))))); % Same as  yfit = glmval(b, characteristics, 'logit')';
    [resResubCM, order] = confusionmat(logical(labels), (yfit > 0.5));
    %[resResubCM, order] = confusionmat(logical(labels), (yfit > mean([mean(yfit(labels == 0)), mean(yfit(labels == 1))]))); %0.35 works better
    specificity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
    sensitivity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;
    [~, ~, ~, AUC] = perfcurve(labels, yfit, 1);
    VPpositive = resResubCM(2, 2) / (resResubCM(2, 2) + resResubCM(1, 2)) * 100;
    VPnegative = resResubCM(1, 1) / (resResubCM(1, 1) + resResubCM(2, 1)) * 100;
    finalRes = [sensitivity, specificity, VPpositive, VPnegative];
    oddsRatio = {b, stats};
    %Getting the failing cases:
    %failingIndices = find(xor((yfit > mean([mean(yfit(labels == 0)), mean(yfit(labels == 1))])), logical(labels)));
    
    
    %One way of measure the goodness of fit
    %But it is not good since its based on sensitivity and specificity
%     if (sensitivity < 20 || specificity < 20)
%         goodness = min(sensitivity, specificity);
%     else
%         goodness = specificity*2 + sensitivity*2;
%     end
    
    % AIC: Akkaike information criterion
    % It provides an estimate of the test error curve
    % The samellest AIC is the best
    %logLikelihood = sum(log( binopdf(labels, ones(size(labels, 1), 1), yfit)));
    %AIC = -2*logLikelihood + 2*numel(b);
    %goodness = - AIC;
    
    % Another simple way is using the Normalized mean square error (NMSE)
    % NMSE costs vary between -Inf (bad fit) to 1 (perfect fit). If the
    % cost function is equal to zero, then x is no better than a straight
    % line at matching xref. It is normalized in order to compare it with
    % others NMSE. It also represents the sample standard deviation of the 
    % differences between predicted values and observed values
    goodness = goodnessOfFit(yfit, logical(labels), 'NMSE');
    
    % We could also minimize the deviance (it is a generalization of the
    % residual sum of squares). This criterion is reasonable if the
    % training observations represent independent random draws from their
    % population.
    %goodness = 100 - dev;
    
    %sum of squared errors of prediction (SSE)
    %SSE_GLM = sum(stats.resid.^2)
    projection = characteristics * weightsOfCharac;
elseif isequal(lower(usedMethod), lower('DANoProjections'))
    res = fitcdiscr(characteristics, labels');
    resClass = resubPredict(res);
    [resResubCM, ~] = confusionmat(labels', resClass);
    sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
    specificity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;
    
    if (sensitivity < 20 || specificity < 20)
        goodness = min(sensitivity, specificity);
    else
        goodness = pow2(specificity) + pow2(sensitivity);
    end
    
    W = LDA(characteristics, labels');
    L = [ones(size(characteristics, 1), 1) characteristics] * W';
    weights = characteristics \ L;
    projection = characteristics * normalizeVector(weights);
end

end

