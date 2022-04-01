

%subject='CONNECT_ma_01'%%VERSUCH!!!!
%% General settings
 hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';

 
 main_dir = [hchs_dir, '/structural/conn_mat/matrix'];
 target_dir = [hchs_dir, '/structural/conn_mat/conn_matrix'];




    mkdir(target_dir)
    cd(main_dir)
 
    
    %% Sorting Subjects
            all_subjects_str = ls(main_dir);
            all_subjects     = cellstr(all_subjects_str);
            
            for i = 1:length(all_subjects);
                     csubj = all_subjects{i};         
                  if isempty(regexp(csubj, 'sub', 'once')); 
                     all_subjects{i} = [];
                 end
            end 
    
    
all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects = sort(all_subjects);

   %% Loop through Subjects 
    
                for subjind = 1:length(all_subjects);
                    
                       
                    subject = all_subjects{subjind};
                    
%       
                    submat = subject(1:12);
                    
                    M=csvread(subject)
            
                    

                  
                   save([target_dir '/' submat],'M');
                    
                end 
%                    id_all     = cellstr(id_all)
%                    save([hchs_dir '/sozio_data/id_all_gsr'],'id_all');
