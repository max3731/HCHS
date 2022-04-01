%% Circular Graph Examples
% Copyright 2016 The MathWorks, Inc.

%% 1. Adjacency matrix of 1s and 0s
% Create an example adjacency matrix made up of ones and zeros.
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
% M = load([conn_dir '/estimate_0'])
% x=M.M
% abs(x)
% rng(0);
% % x = rand(7);
% thresh = -2;
%  x(x >  thresh) = 1;
%  x(x <= thresh) = 0;

%%
% Call CIRCULARGRAPH with only the adjacency matrix as an argument.
% circularGraph(x);

%%
% Click on a node to make the connections that emanate from it more visible
% or less visible. Click on the 'Show All' button to make all nodes and
% their connections visible. Click on the 'Hide All' button to make all
% nodes and their connections less visible.

%% 2. Supply custom properties
% Create an example adjacency matrix made up of various values and supply
% custom properties.
% rng(0);
M = load([conn_dir '/estimate_aroma_gsr_abs_05_circ_wmh'])
x=M.M
x=abs(x)
% x = rand(20);
%  thresh = 0;
% % x(x >  thresh) = 1;
%  x(x > thresh) = 0.0001;
%  x=abs(x)
% for i = 1:numel(x)
%   if x(i) > 0
%     x(i) = rand(1,1);
%   end
% end

%%
%x = rand(7)
% Create custom node labels
myLabel = cell(length(x));
Label = {' Def ' ' Dors ' ' Salv ' 'Som' ' Cont ' ' Vis ' ' Limb '};
for i = 1:length(x)
  myLabel{i} = Label{i};
end

%%
% Create custom colormap
figure;
myColorMap = lines(length(x));

circularGraph(x,'Colormap',myColorMap,'Label',myLabel);