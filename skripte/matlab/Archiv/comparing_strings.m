
%% General Settings

hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis'
aroma_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
p36_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];
p36_spkreg_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_spkreg'];




%% Aroma String

   cd(aroma_dir)
        
            all_subjects_str_aroma = ls(aroma_dir);
            all_subjects_aroma     = cellstr(all_subjects_str_aroma);
            
       for i = 1:length(all_subjects_aroma);
                        csubj = all_subjects_aroma{i};         
            if isempty(regexp(csubj, 'sub', 'once')) 
                        all_subjects_aroma{i} = [];
            end
        end 

            all_subjects_aroma = all_subjects_aroma(~cellfun('isempty', all_subjects_aroma));
            all_subjects_aroma = sort(all_subjects_aroma);
            
            
%% 36p String

   cd(p36_dir)
        
            all_subjects_str_36p= ls(p36_dir);
            all_subjects_36p    = cellstr(all_subjects_str_36p );
            
       for i = 1:length(all_subjects_36p);
                        csubj = all_subjects_36p{i};         
            if isempty(regexp(csubj, 'sub', 'once')) 
                        all_subjects_36p{i} = [];
            end
        end 

            all_subjects_36p = all_subjects_36p(~cellfun('isempty', all_subjects_36p));
            all_subjects_36p = sort(all_subjects_36p);
            
            setdiff(all_subjects_aroma,all_subjects_36p)
            
 %% 36p_spkreg String

   cd(p36_spkreg_dir)
        
            all_subjects_str_36p_spkreg= ls(p36_spkreg_dir);
            all_subjects_36p_spkreg    = cellstr(all_subjects_str_36p_spkreg );
            
       for i = 1:length(all_subjects_36p_spkreg);
                        csubj = all_subjects_36p_spkreg{i};         
            if isempty(regexp(csubj, 'sub', 'once')) 
                        all_subjects_36p_spkreg{i} = [];
            end
        end 

            all_subjects_36p_spkreg = all_subjects_36p_spkreg(~cellfun('isempty', all_subjects_36p_spkreg));
            all_subjects_36p_spkreg = sort(all_subjects_36p_spkreg);
            
            
         setdiff(all_subjects_aroma,all_subjects_36p_spkreg)
            
            