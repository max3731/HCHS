%% General settings
 hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis'
% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_mat'];
% target_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];

conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_mat'];
target_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix_0.5'];
% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_mat'];
% target_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];

thresh = [ 0.5  ];%0.9 0.7 0 0.1 0.3 0.3 0.5



%% Sorting Subjects
        mkdir(target_dir)
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
            all_subjects     = cellstr(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i};         
            if isempty(regexp(csubj, 'sub', 'once')) 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects)); % all subjects which are not empty 
all_subjects = sort(all_subjects);


%% Loop through Subjects, forming matrices

%     
%     A = 1:6
%     B=tril(ones(3))
%     B(B==1)=A
%     B'
  for subjind = 1:length(all_subjects)
                    
                subject = all_subjects{subjind};
                load([conn_dir '/' subject]);
    

                    B=tril(ones(200)); % creating matrix B with half ones half zeros
                    ne = length(B); %
                    B(1:(ne+1):ne^2) = 0; % set diagonal to zero
                     idx=B==1;
                     sum(idx(:)); % check if length of vector and number of ones matches
                     B(B==1)=M; % exchange ones with vector values
                     A =  B'; % transpone matrix
                     Mat = B + A; % form symetrical matrix 
                     
                     Mat = threshold_proportional(Mat, (1-thresh))
              
                     imagesc(Mat)
                     
                     save([target_dir '/' subject],'Mat');
                     
  end
         
 