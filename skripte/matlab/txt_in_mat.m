

%subject='CONNECT_ma_01'%%VERSUCH!!!!
%% General settings
 hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%  main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma'];
%  target_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_mat'];
 
 main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr'];
 target_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_mat'];

% main_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p'];
% target_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_mat'];
%  d = dir('*.1D');
%  filenames = {d.name} %% Rauslöschen ungewünschter Daten
% 
% for i = 1:numel(filenames)
%   fn = filenames{i};
%     disp(fn)
%     delete(fn)
% end



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
                    
%                     display(subject);
                    submat = subject(1:12);
                    
                    M = dlmread(subject);
                    id_all(subjind,:) = submat;
                  
                   save([target_dir '/' submat],'M');
                    
                end 
                   id_all     = cellstr(id_all)
                   save([hchs_dir '/sozio_data/id_all_gsr'],'id_all');
%                   save([hchs_dir '/sozio_data/id_all'],'id_all');
 %                 save([hchs_dir '/sozio_data/id_all_36'],'id_all');