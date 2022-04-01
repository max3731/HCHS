

%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
%   main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];
%   main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];
  
% main_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];
 %conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma'];
absolute_values = 1;
target_dir = [hchs_dir, '/csv_for_R'];
main_txt_path = [hchs_dir '/sozio_data'];

all_thresh = [0 0.1 0.3 0.5  ];% 0.9 0.7
num_thresh = length(all_thresh);


HCHS=load([hchs_dir, '/csv_for_R/all_val'])
g = gramm('x',HCHS.ratio','y',HCHS.MPG,...
    'Color',CarData.City_Highway,...
    'Marker',CarData.Car_Truck);
facet_grid(g,CarData.City_Highway,CarData.Car_Truck,'scale','fixed');
geom_point(g);
stat_fit(g,'fun',@(a,b,c,x)a.*x.^b+c,'disp_fit',true,'StartPoint',[1 1 21]);
set_names(g,'x','Horsepower','y','MPG','column','Vehicle class','color','Driving condition','column','','row','');
draw(g);