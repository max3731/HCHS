%% General settings
hchs_dir = '/home/share/rawdata/Max/HCHS/analysis';
conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
target_dir = [hchs_dir, '/fMRI_resting/conn_mat/'];


 all_thresh = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
 num_thresh = length(all_thresh);

 
 
 BCT_path = '/home/share/rawdata/CONNECT/CONNECT_skripte/fMRI_resting/BCT/2019_03_03_BCT';
 addpath(BCT_path);
 
 
%% Sorting Subjects
        %mkdir(target_dir)
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
            all_subjects     = strsplit(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i};         
            if isempty(regexp(csubj, 'sub', 'once')) 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects = sort(all_subjects);


%% Loop through Subjects

         for subjind = 1:length(all_subjects);
                    
                subject = all_subjects{subjind};
                load([conn_dir '/' subject]);
                
                
                
                    for ind_thresh = 1:num_thresh;
                        thresh  = all_thresh(ind_thresh);
                        target_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix_' num2str(thresh)];
                        
                        
                        
                        
                        
                                    if ~exist(target_dir, 'dir');
                                        mkdir(target_dir);
                                    end
                         
                         mat_thr = threshold_proportional(Mat, (1-thresh));
                         save([target_dir '/' subject],'mat_thr');
                
                    end
                    
         end
                
                
                
                
    