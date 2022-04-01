%% Matrix of Network Relationships
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%%  Estimate Aroma 05
h = figure;

default = [0 0.0388630 -0.0176641 0.0123051 0.0149963 0.0491632 0.0309616]

dorsal = [0.0388630 0 -0.1931864 -0.1328464 -0.0498359 -1.644e-01 0.0055009]

salven = [-0.0176641 -0.1931864 0 -2.192e-01 -0.0401194 -0.0999370 3.094e-02]

sommot = [0.0123051 -0.1328464 -2.192e-01 0 1.909e-02 -6.008e-02 4.607e-02 ]

cont = [0.0149963 -0.0498359 -0.0401194 1.909e-02 0 0.0027517 0.0102397]

vis = [ 0.0491632 -1.644e-01 -0.0999370 -6.008e-02 0.0027517 0 0.0447968  ]

limb  = [0.0309616 0.0055009 3.094e-02 4.607e-02 0.0102397 0.0447968  0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_aroma_abs_05'],'M');



imagesc(M)
title('Network Relationship Estimate aroma abs at Threshold 0.5')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn
%% Matrix of Network Relationships
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%%  Estimate Aroma 07
h = figure;

default = [0 5.507e-02 0.0066897 0.0295787 0.0374631 0.0560253 0.0339685]

dorsal = [5.507e-02 0 -1.693e-01 -0.1126197 -0.0308059 -1.409e-01 4.834e-03]

salven = [0.0066897 -1.693e-01 0 -2.083e-01 -0.0178441 -7.827e-02 0.0184438]

sommot = [0.0295787 -0.1126197 -2.083e-01 0 3.595e-02 -3.554e-02 5.411e-02]

cont = [0.0374631 -0.0308059 -0.0178441 3.595e-02 0 0.0189233 -0.0093842]

vis = [  0.0560253 -1.409e-01 -7.827e-02 -3.554e-02 0.0189233 0 4.474e-02 ]

limb  = [0.0339685 4.834e-03 0.0184438 5.411e-02 -0.0093842 4.474e-02 0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_aroma_abs_07'],'M');



imagesc(M)
title('Network Relationship Estimate aroma abs at Threshold 0.7')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn

%% Pval 07

h = figure;
default = [0.1 0.003 0.1 0.1 0.1 0.007 0.1]

dorsal = [0.003  0.1 0.001 0.006 0.1 0.006 0.1]

salven = [0.1 0.001  0.1 0.000351 0.1 0.08 0.1]

sommot = [0.1 0.006 0.000351 0.1 0.1 0.1 0.00031]

cont = [0.1 0.1 0.1 0.1 0.1 0.1 0.1]

vis = [  0.007 0.006 0.08 0.1 0.1 0.1 0.03 ]

limb  = [0.1 0.1 0.1 0.00031 0.1 0.03 0.1]

M = [default;dorsal;salven;sommot;cont;vis;limb]
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/pval_07'],'M');

imagesc(M)
title('Network Relationship p-Val at Threshold 0.7')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn

%% Estimate 0
h = figure;

default = [0 0 0 0 0 0 0]

dorsal = [0 0 -0.18 -0.13 0 -0.15 0]

salven = [0 -0.18 0 -0.2 0 -0.1 0]

sommot = [0 -0.13 -0.2 0 0 0 0]

cont = [0 0 0 0 0 0 -0.05]

vis = [  0 -0.15 -0.1 0 0 0 0]

limb  = [0 0 0 0 -0.05 0 0]

M = [default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_0'],'M');

imagesc(M)
title('Network Relationship Estimate at Threshold 0')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap winter


%% pVal 0

h = figure;

default = [0 0 0 0 0 0 0]

dorsal = [0 0 0.0005 0.005 0 0.002 0]

salven = [0 0.0005 0 -0.00042 0 0.0215 0]

sommot = [0 0.005 0.00042 0 0 0 0]

cont = [0 0 0 0 0 0 0.05]

vis = [  0 0.002 0.0215 0 0 0 0]

limb  = [0 0 0 0 0.05 0 0]

M = [default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/pval_0'],'M');

imagesc(M)
title('Network Relationship p-Val at Threshold 0')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn




rowNames = {'Def','Dors','Salv','Som','Cont','Vis','Limb'};
colNames = {'Def','Dors','Salv','Som','Cont','Vis','Limb'};
sTable = array2table(M,'RowNames',rowNames,'VariableNames',colNames)

%% Alle Werte 
%% Estimate 

h = figure;

default = [0 0 0 0 0 0 0]

dorsal = [0 0 -1.76 -0.13 0 -0.15  0]

salven = [0 -1.76 0 -0.2 0 -0.102 0]

sommot = [0 -0.13 -0.2 0 0 0 0]

cont = [0 0 0 0 0 0 -0.05]

vis = [  0 -0.15 -0.102 0 0 0 0 ]

limb  = [0 0 0 0 0 -0.05 0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_0'],'M');

imagesc(M)
title('Network Relationship Estimate at Threshold 0')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn






%% Matrix of Network Relationships pval thresh
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%%  Estimate 0
h = figure;

default = [0 0.0070851 -0.0473211 -0.0162906 -0.0117329 1.900e-02 -0.0143001 ]

dorsal = [0.0070851 0 -0.206296 -0.1494524 -0.0742108 -1.782e-01 -5.052e-02]

salven = [-0.0473211 -0.206296  0 -2.312e-01 -0.0670758 -0.1261786 -0.0243779]

sommot = [-0.0162906 -0.1494524 -2.312e-01 0 -8.773e-03  -0.0816185 1.454e-02 ]

cont = [-0.0117329 -0.0742108 -0.0670758 -8.773e-03 0 -0.0247978 -0.0569455]

vis = [  1.900e-02 -1.782e-01 -0.1261786 -0.0816185 -0.0247978 0 2.047e-03 ]

limb  = [-0.0143001 -5.052e-02 -0.0243779 1.454e-02 -0.0569455 2.047e-03  0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_0_pval'],'M');



imagesc(M)
title('Network Relationship Estimate at Threshold pVal 0.05')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn


%% Matrix of Network Relationships 36p 0.5 thresh
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%%  Estimate 0
h = figure;

default = [0 -0.0766035 -0.0736714 0.0610703 0.0019545 -0.0152523 3.444e-02]

dorsal = [-0.0766035 0 -1.520e-02 0.1213105 3.378e-02  0.0046531 0.0306012]

salven = [-0.0736714 -1.520e-02 0 0.0226958 5.545e-03 3.357e-02 2.347e-02]

sommot = [0.0610703 0.1213105 0.0226958 0  0.0585422  0.0386643 0.0399174]

cont = [0.0019545 3.378e-02 5.545e-03 0.0585422 0 6.557e-03 2.364e-02]

vis = [  -0.0152523 0.0046531 3.357e-02 0.0386643 6.557e-03 0 0.0415331 ]

limb  = [3.444e-02 0.0306012 2.347e-02 0.0399174 2.364e-02 0.0415331  0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_36p_abs_0.5'],'M');



imagesc(M)
title('Network Relationship Estimate 36p at Threshold pVal 0.05')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn

%% Matrix of Network Relationships 36p 0.7 thresh
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%%  Estimate 0
h = figure;

default = [0 -0.0848438 -0.0793305 0.0620172 -3.415e-04 -1.449e-02 -5.191e-03]

dorsal = [-0.0848438 0 -0.0170263 0.1234820 2.764e-02 -1.953e-03 2.989e-03]

salven = [-0.0793305 -0.0170263 0 0.0247571 5.118e-03 2.875e-02 -4.493e-03]

sommot = [0.0620172 0.1234820 0.0247571 0 5.694e-02 0.0298529 2.362e-02]

cont = [-3.415e-04 2.764e-02 5.118e-03 5.694e-02 0 4.570e-03 -1.012e-02]

vis = [  -1.449e-02 -1.953e-03 2.875e-02 0.0298529 4.570e-03 0 0.005368 ]

limb  = [-5.191e-03 2.989e-03 -4.493e-03 2.362e-02 -1.012e-02 0.005368  0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_36p_abs_07'],'M');

 
 imagesc(M)
title('Network Relationship Estimate 36p at Threshold 0.07')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn





%% Matrix of Network Relationships
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%%  Estimate Aroma gsr 05
h = figure;

default = [0 -0.0887273 -0.0650156 1.987e-03 -0.0158405 -1.284e-02 3.324e-02]

dorsal = [-0.0887273 0 -0.0377515 -0.0235887 -0.0370657 -0.0413798 0.0280060]

salven = [-0.06501561 -0.0377515 0 -8.435e-02 -0.0098169 0.0095864 4.574e-02]

sommot = [1.987e-03 -0.0235887 -8.435e-02 0 -0.0083818 -1.570e-02 6.015e-02]

cont = [-0.0158405 -0.0370657 -0.0098169 -0.0083818 0 -0.0452587 3.278e-02]

vis = [-1.284e-02 -0.0413798 0.0095864 -1.570e-02 -0.0452587 0 3.091e-02]

limb  = [ 3.324e-02 0.0280060 4.574e-02 6.015e-02 3.278e-02  3.091e-02 0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_aroma_gsr_abs_05'],'M');



imagesc(M)
title('Network Relationship Estimate aroma gsr abs at Threshold 0.5')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn


%% Matrix of Network Relationships
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%%  Estimate Aroma gsr 07
h = figure;

default = [ 0 -0.0785484 -0.0544049 1.534e-02 -0.0016242 -3.214e-03 6.618e-03]

dorsal = [-0.0785484 0 -0.0256529 -0.0122392 -0.0257196 -0.0334189 -1.169e-02 ]

salven = [-0.0544049 -0.0256529 0 -7.237e-02 0.0057621 0.0249141 1.639e-02  ]

sommot = [1.534e-02 -0.0122392 -7.237e-02 0 5.675e-03 -4.617e-03 2.261e-02]

cont = [-0.0016242 -0.0257196 0.0057621 5.675e-03 0 -0.0269741 -1.401e-02]

vis = [-3.214e-03 -0.0334189 0.0249141 -4.617e-03 -0.0269741 0 -3.092e-03]

limb  = [6.618e-03 -1.169e-02 1.639e-02 2.261e-02 -1.401e-02 -3.092e-03 0 ]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_aroma_gsr_abs_07'],'M');



imagesc(M)
title('Network Relationship Estimate aroma gsr abs at Threshold 0.7')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn

%% Matrix of Network Relationships
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%%  Estimate Aroma pval 05 thr 05
h = figure;

default = [ 0 0.0381834 -0.0181419 0.0115915 0.0147365 0.0485567 0.0306697]

dorsal = [0.0381834 0 -0.1937459 -0.1332731 -0.0506045 -1.652e-01 0.0047273 ]

salven = [-0.0181419 -0.1937459 0 -2.199e-01 -0.0407538 -0.1007712 3.031e-02]

sommot = [0.0115915 -0.1332731 -2.199e-01 0 1.851e-02 -6.058e-02 4.572e-02]

cont = [0.0147365 -0.0506045 -0.0407538 1.851e-02 0 0.0022631 0.0095400 ]

vis = [0.0485567 -1.652e-01 -0.1007712 -6.058e-02 0.0022631 0 0.0439945  ]

limb  = [0.0306697 0.0047273 3.031e-020 4.572e-02 0.0095400  0.0439945 0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_aroma_pval_05_abs_05'],'M');



imagesc(M)
title('Network Relationship Estimate aroma pval 05 abs at Threshold 0.5')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn


%%  Estimate Aroma pval 05 thr 05 age 
h = figure;

default = [ 0 -0.0004789 -0.0006456  1.188e-05 -0.0001753 -0.0005726 0.0001802]

dorsal = [-0.0004789 0 -0.0008019  -0.0004457  -8.847e-05 -0.0006921 0.0001317 ]

salven = [-0.0006456 -0.0008019 0 -0.0008327 -0.0003909 -0.0004011  0.0000414]

sommot = [1.188e-05  -0.0004457 -0.0008327 0 -0.0001524 -0.0004167  8.495e-05 ]

cont = [-0.0001753 -8.847e-05 -0.0003909 -0.0001524 0 -0.0001381 0.0001737 ]

vis = [-0.0005726 -0.0006921 -0.0004011 -0.0004167 -0.0001381 0  0.0001076]

limb  = [0.0001802 0.0001317  0.0000414 8.495e-05 0.0001737  0.0001076 0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_aroma_pval_05_abs_05_age'],'M');



imagesc(M)
title('Network Relationship Estimate with age aroma pval 05 abs at Threshold 0.5 ')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn
%%  Estimate Aroma pval 05 thr 05 wmh 
h = figure;

default = [ 0 -0.0548985 -0.0194115  1.268e-03  -0.0033397 0.0270945 0.0207927]

dorsal = [-0.0548985 0 0.0188405 0.0078563  -3.050e-02 0.0071952  0.0190450  ]

salven = [-0.0194115  0.0188405 0 -0.0260675 0.0179416   0.0373916  0.0429826]

sommot = [1.268e-03  0.0078563 -0.0260675 0 0.0023601 0.0133852   5.428e-02]

cont = [-0.0033397 -3.050e-02  0.0179416 0.0023601 0 -0.0353960 0.0208073 ]

vis = [0.0270945  0.0071952  0.0373916  0.0133852 -0.0353960  0  0.0234391 ]

limb  = [0.0207927  0.0190450  0.0429826 5.428e-02 0.0208073  0.023439 0]

M = [ default;dorsal;salven;sommot;cont;vis;limb];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/network_rel']
 mkdir (target_dir)
 save([target_dir '/estimate_aroma_pval_05_abs_05_wmh'],'M');



imagesc(M)
title('Network Relationship Estimate with age aroma pval 05 abs at Threshold 0.5 ')
xlabel(' Def         Dors        Salv      Som       Cont      Vis         Limb');
ylabel('Limb       Vis      Cont    Som      Salv    Dors     Def');
colorbar
colormap autumn