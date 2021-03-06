hchs_dir = 'C:\Users\mschu\Documents\CSI\HCHS\new_cohort\'
conn_dir_func = [hchs_dir, '/fMRI_resting/matrix_200_7']; 
conn_dir_struc = [hchs_dir, '/MRI_dwi/matrix_200_7']; 


main_txt_path = [hchs_dir '/social_data'];


absolute_values = 1;

NBS_path = 'C:\Users\mschu\Documents\CSI\NBS1.2\Networks HCHS'
BCT_path = 'C:\Users\mschu\Documents\CSI\HCHS\analysis\BCT\2019_03_03_BCT';
addpath(BCT_path);

all_thresh = [ 0.5  ];
num_thresh = length(all_thresh);


%% Sorting Subjects
       
        cd(conn_dir_struc)
        
            all_subjects_str = ls(conn_dir_struc);
            all_subjects = cellstr(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i}; 

            if isempty(regexp(csubj, 'sub', 'once')) 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects_structural = sort(all_subjects);
all_subjects_structural = all_subjects_structural';


         id_m_str = cell(length(all_subjects_structural),1);
         for subjind = 1:length(all_subjects_structural);
             csubj = all_subjects_structural{subjind};
             nsubj=csubj(1:12);   %extract subject name
             nsubj=strsplit(nsubj);% convert into cell
             id_m_str(subjind,:) = nsubj;       
         end

          cd(conn_dir_func)

            all_subjects_str = ls(conn_dir_func);
            all_subjects = cellstr(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i}; 
            if isempty(regexp(csubj, 'sub', 'once')) 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects_functional = sort(all_subjects);
all_subjects_functional = all_subjects_functional';


         id_m_fc = cell(length(all_subjects_functional),1);
         for subjind = 1:length(all_subjects_functional);
             csubj = all_subjects_functional{subjind};
             nsubj=csubj(1:12);   %extract subject name
             nsubj=strsplit(nsubj);% convert into cell
             id_m_fc(subjind,:) = nsubj;       
         end

         tbl = readtable([main_txt_path '/data_mayer_20210917.csv']) ; 

         id = tbl.DisclosureID;

                     str2 = 'sub-';
         for subjind = 1:length(id)
             csubj = id{subjind};
             nsubj=strcat(str2,csubj); % attach "sub"
             nsubj=strsplit(nsubj); %convert into cell
             id(subjind,:)=nsubj;            
         end


               ex1 = setdiff(id_m_fc,id_m_str)  % returns names in id_mf_fc that are not in id_m_str
               [~,idx1] = ismember(id_m_fc,ex1) % one's on these rows which resemble index of ex1
               [idx1] = find(idx1) % returns index numbers of ones              
               id_m_fc(idx1, :) = []; % delete subjects of id which are not in id_m                       

              
               ex2 = setdiff(id_m_str,id_m_fc)  % returns names in id_mf_fc that are not in id_m_str
               [~,idx2] = ismember(id_m_str,ex2) % one's on these rows which resemble index of ex1
               [idx2] = find(idx2) % returns index numbers of ones              
               id_m_str(idx2, :) = []; % delete subjects of id which are not in id_m       
    
    
              if isequal(id_m_str,id_m_fc);
                  display 'Funktionelle und strukturelle Matrizen sind angeglichen'
              else
                  display 'Funktionelle und strukturelle Matrizen sind ungleich'
              end

                % for the following analysis it doesn't matter if id_m_str
                % is used or id_m_fc, both arrays are the same now
               ex3 = setdiff(id,id_m_str);
               [~,idx3] = ismember(id,ex3);
               [idx3] = find(idx3); 
               id(idx3, :) = [];
               tbl(idx3, :) = []; 
               [~,idx3] = sortrows(tbl(:,2)); % sortieren der Tabelle nach Subject ID
               tbl = tbl(idx3,:);


              ex4 = setdiff(id_m_str,id);
              [~,idx4] = ismember(id_m_str,ex4);
              [ex4] = find(idx4); 
              id_m_str(ex4, :) = [];
              id_m_fc(ex4, :) = [];

               if isequal(id_m_str,id);
                  display 'Matrizen und Demographie angeglichen'
              else
                  display 'Matrizen und Demographie ungleich'
               end

              writecell (id_m_fc, [main_txt_path '/id_subjects.txt'])
