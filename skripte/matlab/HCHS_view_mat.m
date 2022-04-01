%% General settings
hchs_dir = '/home/share/rawdata/Max/HCHS/analysis';
main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
target_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];


%% Sorting Subjects
        mkdir(target_dir)
        cd(main_dir)
        
            all_subjects_str = ls(main_dir);
            all_subjects     = strsplit(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i};         
            if isempty(regexp(csubj, 'sub', 'once')) 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects = sort(all_subjects);


nsub = length(all_subjects);
%% Loop through Subjects

for subjind = 1:length(all_subjects)
    
     subject = all_subjects{subjind};
     
                
                               
                      
                     cd (main_dir)
                
                     load([main_dir '/' subject]);
                     
                   %  display(subject)
                     
                     imagesc(Mat)
                     pause(1)
                     
                     cd (main_dir)
end