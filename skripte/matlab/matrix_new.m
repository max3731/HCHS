 hchs_dir = '/home/maximilian/CSI/new_cohort'
 
 conn_dir = '/media/maximilian/FREECOM HDD/für_max'
 target_dir = [hchs_dir, '/fMRI_resting/matrix_200_7'];
 broken_subjects = 'sub-xxxxx.mat'
 empty_subjects = []
 nan_subjects = []
        mkdir(target_dir)
        cd(conn_dir)
        
             all_subjects_str = ls(conn_dir);
             all_subjects = strsplit(all_subjects_str)
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
                 if  exist([conn_dir '/' subject '/ses-1/func/schaefer200x7'],'dir')                    
                     M = load([conn_dir '/' subject '/ses-1/func/schaefer200x7/' subject '_schaefer200x7_network.txt' ]);

                     if isnan(mean(mean(M)))

                         nan_subjects = [nan_subjects; subject];

                     else
                     B=tril(ones(200)); % creating matrix B with half ones half zeros
                     ne = length(B); %
                     B(1:(ne+1):ne^2) = 0; % set diagonal to zero
                     idx=B==1;
                     sum(idx(:)); % check if length of vector and number of ones matches
                     B(B==1)=M; % exchange ones with vector values
                     A =  B'; % transpone matrix
                     Mat = B + A; % form symetrical matrix 
            

                    % imagesc(Mat)
                     save([target_dir '/' subject],'Mat');
                     end
                 else
                     
                     
                   empty_subjects = [empty_subjects; subject];
                     


                 end    
                 
  end              
             writematrix(empty_subjects,[target_dir '/empty']);
             writematrix(nan_subjects,[target_dir '/nan']);
                