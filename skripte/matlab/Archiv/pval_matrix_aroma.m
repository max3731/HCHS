%% General settings
 hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis'
conn_dir = [hchs_dir, '/fMRI_resting/Timelines/'];
conn_dir_aroma = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
target_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];

% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_mat'];
% target_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];


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

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects = sort(all_subjects);

  for subjind = 1:length(all_subjects)
                    
                subject = all_subjects{subjind};
                load([conn_dir '/' subject]);
                    
                    submat = subject(1:12);
                    M = dlmread(subject);
                    [rho,pval] = corr(M);
                    ne = length(pval);
                    pval(1:(ne+1):ne^2) = 0; % set diagonal to zero
                    idx=pval<0.05; % alles unter p-wert 0.1 wird 1, der rest 0
                    
                    load([conn_dir_aroma '/' submat]);
                    Mat = idx.*rho; % Corr Matrix 
                    Mats = idx.*Mat;
                    
                    ne = length(Mat);
                    Mat(1:(ne+1):ne^2) = 0; 

%                     B=tril(ones(200)); % creating matrix B with half ones half zeros
%                     ne = length(B); %
%                     B(1:(ne+1):ne^2) = 0; % set diagonal to zero
%                      idx=B==1;
%                      sum(idx(:)); % check if length of vector and number of ones matches
%                      B(B==1)=M; % exchange ones with vector values
%                      A =  B'; % transpone matrix
%                      Mat = B + A; % form symetrical matrix 
              
                     imagesc(Mat)
              
                     imagesc(Mats)
                     
                     save([target_dir '/' submat],'Mat');
                     
  end
         
