 hchs_dir = '/home/maximilian/CSI/new_cohort'
 
 conn_dir = 'D:\für_max'
 target_dir = [hchs_dir, '/MRI_dwi/matrix_200_7'];
 broken_subjects = 'sub-xxxxx.mat'
 empty_subjects = []
 nan_subjects = []
        mkdir(target_dir)
        cd(conn_dir)
        
             all_subjects_str = ls(conn_dir);
             all_subjects = cellstr(all_subjects_str)
        %    all_subjects     = cellstr(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i};
            if ~isempty(regexp(broken_subjects, csubj, 'once'))
                all_subjects{i} = [];
            elseif isempty(regexp(csubj, 'sub', 'once')) 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects = sort(all_subjects);
all_subjects = all_subjects';

  for subjind = 1:length(all_subjects)
                    
                subject = all_subjects{subjind};
                 if  exist([conn_dir '/' subject '/ses-1/dwi/' subject '_ses-1_acq-AP_space-T1w_desc-preproc_space-T1w_dhollanderconnectome.mat'],'file')                    
                     M = load([conn_dir '/' subject '/ses-1/dwi/' subject '_ses-1_acq-AP_space-T1w_desc-preproc_space-T1w_dhollanderconnectome' ]);
                     M = M.schaefer200x7_sift_radius2_count_connectivity       
                     if isnan(mean(mean(M)))

                         nan_subjects = [nan_subjects; subject];

                     else
                     Mat = M
                     save([target_dir '/' subject],'Mat');
                     end
                 else
                                          
                   empty_subjects = [empty_subjects; subject];
                     
                 end    
                 
  end              
             writematrix(empty_subjects,[target_dir '/empty']);
             writematrix(nan_subjects,[target_dir '/nan']);
                