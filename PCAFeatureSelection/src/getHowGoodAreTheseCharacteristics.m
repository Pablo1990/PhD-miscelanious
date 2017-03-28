function [ goodness, projection ] = getHowGoodAreTheseCharacteristics(characteristics, labels, eigenvectors)
%GETHOWGOODARETHESECHARACTERISTICS Summary of this function goes here
%   Detailed explanation goes here
    %% ---- PCA feature selection -----%
    %% Obtencion de numeros a partir de graficas metodo3 (LUCIANO)
    projection = characteristics * eigenvectors;
    [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(projection, labels, 2);
    C = sinterluc/sintraluc;
    goodness = trace(C);
%     %% ----- Discriminant analysis feature selection ------%
%     W = LDA(characteristics, labels');
%     L = [ones(size(characteristics, 1), 1) characteristics] * W';
%     [~, sintraluc, sinterluc, ~, ~] = valid_sumsqures(L, labels, 2);
%     C = sinterluc/sintraluc;
%     goodness = trace(C);
%     weights = characteristics \ L;
%     projection = characteristics * zscore(weights);
%     %% ---- TuMetodo ----%
%     res = fitcdiscr(characteristics, labels');
%     resClass = resubPredict(res);
%     [resResubCM, ~] = confusionmat(labels', resClass);
%     sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
%     specifity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;
%     
%     if (sensitivity < 20 || specifity < 20)
%         goodness = min(sensitivity, specifity);
%     else
%         goodness = pow2(specifity) + pow2(sensitivity);
%     end
end

