function [ ] = comparePercentageOfHexagonsAgainstComparisonWithRegularHexagons(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%     analyzeGraphletDistances('E:\Pablo\PhD-miscelanious\voronoiGraphlets\results\comparisons\EveryFile\maxLength5');
%     load('E:\Pablo\PhD-miscelanious\voronoiGraphlets\results\comparisons\EveryFile\maxLength5\distanceMatrixMeanGCDDA.mat');
%     differenceWithRegularHexagon = distanceMatrix(22,:);
%     differenceWithRegularHexagon = differenceWithRegularHexagon(differenceWithRegularHexagon > 0);
%     names = {names(distanceMatrix(22, :) ~= distanceMatrix(22, 22))};
%     names = names{1};
%     save('differenceWithRegularHexagon.mat', 'differenceWithRegularHexagon', 'names');
    clear
    distances = readtable('E:\Pablo\PhD-miscelanious\voronoiGraphlets\results\comparisons\EveryFile\maxLength5\distancesCorrect.csv', 'Delimiter', ';');
    names = distances.names;
    differenceWithRegularHexagon = cellfun(@(x) str2num(strrep(x, ',', '.')), distances.distance);
    
    load('E:\Pablo\PhD-miscelanious\voronoiGraphlets\results\comparisons\EveryFile\percentageOfHexagons.mat')
    names = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
    names = cellfun(@(x) x{end}, names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '_', '-'), names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, 'adjacencyMatrix', ''), names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '-data', ''), names, 'UniformOutput', false);
    names = cellfun(@(x) x(1:end-1), names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '-OnlyWeightedCellsAndNeighbours', ''), names, 'UniformOutput', false);
    
    nameFiles = cellfun(@(x) strsplit(x, '\'), nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) x{end}, nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) x(1:end-7), nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) strrep(x, '_', '-'), nameFiles, 'UniformOutput', false);
    
    rightPercentages = zeros(1, size(names, 2));
    for numName = 1:size(nameFiles, 2)
        numFound = find(cellfun(@(x) isequal(nameFiles{numName}, x ), names, 'UniformOutput', true) == 1);
        if isempty(numFound) == 0
            nameFiles{numName};
            rightPercentages(1, numFound) = percentageOfHexagons(numName);
        end
    end
    percentageOfHexagons = rightPercentages;
    if size(percentageOfHexagons, 2) ~= size(differenceWithRegularHexagon, 1)
        error('No matrix coincidence on size');
    end

    numberOfTypes = 15;
    colors = hsv(numberOfTypes);
    colors(1, :) = [0.0 0.2 0.0]; %BCA
    colors(2, :) = [1.0 0.4 0.0]; %Eye
    colors(3, :) = [0.0 0.4 0.8]; %cNT
    colors(4, :) = [0.0 0.6 0.0]; %dWL
    colors(5, :) = [0.8 0.0 0.0]; %dWP
    colors(6, :) = [0.8 0.8 0.8]; %voronoi
    colors(7, :) = [0.6 0.0 1.0]; %voronoiWeighted
    colors(8, :) = [1.0 1.0 0.0]; %voronoiNoise
    colors(9, :) = [0.8 0.8 0.8]; %Case II
    colors(10, :) = [1.0 0.6 1.0]; %Case III
    colors(11, :) = [1.0 0.2 1.0]; %Case IV
    colors(12, :) = [0.8 0.6 1.0]; %dMWP
    colors(13, :) = [0.2 0.8 1.0]; %Atrophy Sim
    colors(14, :) = [0.0 0.0 0.0]; %Control Sim Prol
    colors(15, :) = [0.4 0.0 0.0]; %Control Sim No Prol
    %colors(16, :) = [0.2 0.4 0.6]; %BNA
    h1 = figure('units','normalized','outerposition',[0 0 1 1]);
    h = zeros(numberOfTypes);
    hold on;
    for i = 1:size(names, 1)
        if isempty(strfind(names{i}, 'BC')) == 0
            h(1, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(1, :), 'MarkerFaceColor', colors(1, :));
        elseif isempty(strfind(names{i}, 'omm')) == 0
            h(2, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(2, :), 'MarkerFaceColor', colors(2, :));
        elseif isempty(strfind(names{i}, 'cNT')) == 0
            h(3, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(3, :), 'MarkerFaceColor', colors(3, :));
        elseif isempty(strfind(names{i}, 'dWL')) == 0
            h(4, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(4, :), 'MarkerFaceColor', colors(4, :));
        elseif isempty(strfind(names{i}, 'dWP')) == 0
            h(5, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(5, :), 'MarkerFaceColor', colors(5, :));
        elseif isempty(strfind(names{i}, 'disk')) == 0 %voronoiWeighted
            h(7, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(7, :), 'MarkerFaceColor', colors(7, :));
            nameDiagram = strsplit(names{i}, '-');
            t1 = text(differenceWithRegularHexagon(i),percentageOfHexagons(i), nameDiagram(6));
            t1.FontSize = 5;
            t1.HorizontalAlignment = 'center';
            t1.VerticalAlignment = 'middle';
        elseif isempty(strfind(names{i}, 'voronoiNoise')) == 0
            h(8, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(8, :), 'MarkerFaceColor', colors(8, :));
            nameDiagram = strsplit(names{i}, '-');
            t1 = text(differenceWithRegularHexagon(i),percentageOfHexagons(i), nameDiagram(5));
            t1.FontSize = 5;
            t1.HorizontalAlignment = 'center';
            t1.VerticalAlignment = 'middle';
        elseif isempty(strfind(names{i}, 'Case-III')) == 0
            h(10, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(10, :), 'MarkerFaceColor', colors(10, :));
        elseif isempty(strfind(names{i}, 'Case-II')) == 0
            h(9, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(9, :), 'MarkerFaceColor', colors(9, :));
        elseif isempty(strfind(names{i}, 'Case-IV')) == 0
            h(11, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(11, :), 'MarkerFaceColor', colors(11, :));
        elseif isempty(strfind(names{i}, 'dMWP')) == 0
            h(12, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(12, :), 'MarkerFaceColor', colors(12, :));
        elseif isempty(strfind(names{i}, 'Atrophy-Sim')) == 0
            h(13, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(13, :), 'MarkerFaceColor', colors(13, :));
        elseif isempty(strfind(names{i}, 'Control-Sim-Prol')) == 0
            h(14, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(14, :));
        elseif isempty(strfind(names{i}, 'Control-Sim-no-Prol')) == 0
            h(15, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(15, :));
        elseif isempty(strfind(names{i}, 'image')) == 0
            h(6, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(6, :));
            nameDiagram = strsplit(names{i}, '-');
            t1 = text(differenceWithRegularHexagon(i),percentageOfHexagons(i), nameDiagram(end));
            t1.FontSize = 5;
            t1.HorizontalAlignment = 'center';
            t1.VerticalAlignment = 'middle';
%         elseif isempty(strfind(names{i}, 'BNA')) == 0
%             h(16, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(16, :), 'MarkerFaceColor', colors(16, :));
            else
            names{i}
        end
    end
    
    %'BNA' remaining
    newNames = {'BCA', 'Eye', 'cNT', 'dWL', 'dWP', 'Voronoi', 'Voronoi weighted', 'Voronoi Noise', 'Case II', 'Case III', 'Case IV', 'dMWP', 'Atrophy', 'Control Proliferative', 'Control No Proliferative'};
    hlegend1 = legend(h(:,1), newNames');
    title('Percentage of hexagons against graphlets difference with hexagonal tesselation');
    xlabel('Graphlets value comparison');
    ylabel('Percentage of hexagons');

    export_fig(h1, 'differenceGraphlets', '-tiff', '-a4');

end
