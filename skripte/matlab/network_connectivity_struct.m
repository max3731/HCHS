%% General settings
hchs_dir = 'C:\Users\mschu\Documents\CSI\HCHS\new_cohort\'
conn_dir = [hchs_dir, '/MRI_dwi/matrix_200_7']; 




main_txt_path = [ 'C:\Users\mschu\Documents\CSI\HCHS\new_cohort\social_data'];
absolute_values = 0;
mean_default = []


NBS_path = 'C:\Users\mschu\Documents\CSI\NBS1.2\Networks HCHS'
BCT_path = 'C:\Users\mschu\Documents\CSI\HCHS\analysis\BCT\2019_03_03_BCT';

addpath(BCT_path);
 

 all_thresh = [ 0  ];
 num_thresh = length(all_thresh);



 cd(conn_dir)       
 broken_subjects = 'sub-2016203f.mat'
 
 default_sign_all = []


         
%% Sorting Subjects
       
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
            all_subjects = cellstr(all_subjects_str);
            
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
% all_subjects = all_subjects';


%% Vorbereiten von Matrizen Datensatz

         id_m = cell(length(all_subjects),1);
         for subjind = 1:length(all_subjects);
             csubj = all_subjects{subjind};
             nsubj=csubj(1:12);   %extract subject name
             nsubj=strsplit(nsubj);% convert into cell
             id_m(subjind,:) = nsubj;             
         end

           id = importdata([hchs_dir '/id_subjects.txt']) ;
          
        

%% Angleichen von Matrizen an Demographie Datensatz      

         % Index der Subjects die in der Demographie Tabelle aber nicht bei
         % den Matrizen enthalten sind
               ex1 = setdiff(id_m,id)  % returns names in id that are not in id_m
               [~,idx1] = ismember(id_m,ex1) % one's on these rows which resemble index of ex1
               [idx1] = find(idx1) % returns index numbers of ones              
               id_m(idx1, :) = []; % delete subjects of id which are not in id_m                       
               all_subjects(idx1, :) = [];

              if isequal(id_m,id);
                  display 'Matrizen und Demographie angeglichen'
              else
                  display 'Matrizen und Demographie ungleich'
              end
         
%% Loop through Subjects

      for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              
                                            
                      

                         target_dir_with = [hchs_dir, '/MRI_dwi/results_200_7/sift_radius2_' num2str(thresh)];

                         target_dir_3d = [hchs_dir, '/MRI_dwi/results_200_7/sift_radius2_' num2str(thresh) '/Matrix_3d'];

                      
                      
                       
              for subjind = 1:length(all_subjects)

                            subject = all_subjects{subjind};
                            load([conn_dir '/' subject]);

                                  Mat = threshold_proportional(Mat, (1-thresh));
                                  
                                %% CONNECTIVITY WITHIN NETWORKS     
                                
                                %% Global Connectivity
                                  
                                  mean_conn = mean(mean(Mat));
                                  mean_conn_all_str(subjind,:) = mean_conn;
                                  
                                  conn_all_str(:,:,subjind)  = Mat;
                                  conn = Mat;
                                  




                             %%  extracting default net and mean connectivity
                              
                           
                             
                               default_lh = (74:100);  
                               default_rh = (182:200); 
                               %
                               default_index = [default_lh,default_rh]; % Index right and left
                               default = Mat(default_index, default_index);

%% Extracting links decreasing significant with age                               

                                           T= readtable ( [NBS_path '/default_sign_str.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
%                              
                                           rows = [1:rows];



                                       for k = 1:length(rows);
                                           row = rows(k);
                                            x = T(row,1);
                                            x=table2array (x);
                                            y = T(row,2) ;
                                             y=table2array (y);
                                             default_sign = default(x,y);
                                             default_sign_all(:,row)  = default_sign;                     
                                        end

                                             mean_default_sign = mean(default_sign_all);
                                             mean_default_sign_all_str(subjind,:) = mean_default_sign;


                                           T= readtable ( [NBS_path '/default_sign_str_increase.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
%                              
                                           rows = [1:rows];



                                       for k = 1:length(rows);
                                           row = rows(k);
                                            x = T(row,1);
                                            x=table2array (x);
                                            y = T(row,2) ;
                                             y=table2array (y);
                                             default_sign_increase = default(x,y);
                                             default_sign_increase_all(:,row)  = default_sign_increase;                     
                                        end

                                             mean_default_sign_increase = mean(default_sign_increase_all);
                                             mean_default_sign_all_str_increase(subjind,:) = mean_default_sign_increase;
                                             

                               
       
                               default_all_str(:,:,subjind)  = default; % 3D matrix of all subjects
                               
                               mean_default = tril(default); % for calculating mean only half of the matrix 
                               mean_default(mean_default==0) = nan; % for calculating mean changing zeros to nan

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_default = mean(mean_default,'omitnan'); % calculating mean for each column
                               mean_default = mean_default(~isnan(mean_default)); % excluding columns with nan result 
                               mean_default = mean(mean_default); % calculating mean of the columns 
                                                                                          
                               mean_default_all_str(subjind,:) = mean_default; % mean values of all subjects
                               



                              %% extracting Dorsal net and mean connectivity 


                               dorsal_lh = (31:43); % 
                               dorsal_rh = (135:147); 
                               %
                               dorsal_index = [ dorsal_lh, dorsal_rh]; %
                               dorsal = Mat(dorsal_index, dorsal_index);

%% Extracting links decreasing significant with age

                                           T= readtable ( [NBS_path '/dorsal_sign_str.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
%                              
                                           rows = [1:rows];

                                       for k = 1:length(rows);
                                           row = rows(k);
                                            x = T(row,1);
                                            x=table2array (x);
                                            y = T(row,2) ;
                                             y=table2array (y);
                                             dorsal_sign = dorsal(x,y);
                                             dorsal_sign_all(:,row)  = dorsal_sign;                     
                                        end

                                             mean_dorsal_sign = mean(dorsal_sign_all);
                                             mean_dorsal_sign_all_str(subjind,:) = mean_dorsal_sign;                               
                               

%                                            T= readtable ( [NBS_path '/dorsal_sign_str_increase.csv']);
%                                            table_size = size(T) ; 
%                                            rows = table_size(1); 
% %                              
%                                            rows = [1:rows];
% 
% 
% 
%                                        for k = 1:length(rows);
%                                            row = rows(k);
%                                             x = T(row,1);
%                                             x=table2array (x);
%                                             y = T(row,2) ;
%                                              y=table2array (y);
%                                              dorsal_sign_increase = dorsal(x,y);
%                                              dorsal_sign_increase_all(:,row)  = dorsal_sign_increase;                     
%                                         end
% 
%                                              mean_dorsal_sign_increase = mean(dorsal_sign_increase_all);
%                                              mean_dorsal_sign_all_str_increase(subjind,:) = mean_dorsal_sign_increase;


                      
                               dorsal_all_str(:,:,subjind)  = dorsal;
                               
                               mean_dorsal = tril(dorsal);
                               mean_dorsal(mean_dorsal==0) = nan;

                 

                               mean_dorsal = mean(mean_dorsal,'omitnan');
                               mean_dorsal = mean_dorsal(~isnan(mean_dorsal));
                               mean_dorsal = mean(mean_dorsal);
                               mean_dorsal_all_str(subjind,:) = mean_dorsal;
                               
                               
                               [~, mod] = modularity_und(dorsal);
                               modul_dorsal(subjind,:) = mod;

                             %%  extracting SalVen net and mean connectivity     


                               salven_lh = (44:54); % 
                               salven_rh = (148:158); 
                               %
                               salven_index = [salven_lh,salven_rh]; %
                               salven = Mat(salven_index, salven_index);


%% Extracting links decreasing significant with age

                                           T= readtable ( [NBS_path '/salven_sign_str.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
                              
                                           rows = [1:rows];

                                       for k = 1:length(rows);
                                            row = rows(k);
                                             x = T(row,1);
                                             x=table2array (x);
                                             y = T(row,2) ;
                                             y=table2array (y);
                                             salven_sign = salven(x,y);
                                             salven_sign_all(:,row)  = salven_sign;                     
                                        end

                                             mean_salven_sign = mean(salven_sign_all);
                                             mean_salven_sign_all_str(subjind,:) = mean_salven_sign;  


                                           T= readtable ( [NBS_path '/salven_sign_str_increase.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
%                              
                                           rows = [1:rows];



                                       for k = 1:length(rows);
                                           row = rows(k);
                                            x = T(row,1);
                                            x=table2array (x);
                                            y = T(row,2) ;
                                            y=table2array (y);
                                            salven_sign_increase = salven(x,y);
                                            salven_sign_increase_all(:,row)  = salven_sign_increase;                     
                                        end

                                             mean_salven_sign_increase = mean(salven_sign_increase_all);
                                             mean_salven_sign_all_str_increase(subjind,:) = mean_salven_sign_increase;                                                                                                                      
                               
                               salven_all_str(:,:,subjind)  = salven;
                               
                               mean_salven = tril(salven);
                               mean_salven(mean_salven==0) = nan;

                               mean_salven = mean(mean_salven,'omitnan');
                               mean_salven = mean_salven(~isnan(mean_salven));
                               mean_salven = mean(mean_salven);
                               mean_salven_all_str(subjind,:) = mean_salven;


                               [~, mod] = modularity_und(salven);
                               modul_salven_str(subjind,:) = mod;


                            %%  extracting SomMot net and mean connectivity     


                               sommot_lh = (15:30); % 
                               sommot_rh = (116:134); 
                               %
                               sommot_index = [ sommot_lh, sommot_rh]; %
                               sommot = Mat(sommot_index, sommot_index);

%% Extracting links decreasing significant with age

                                           T= readtable ( [NBS_path '/sommot_sign_str.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
                              
                                           rows = [1:rows];

                                       for k = 1:length(rows);
                                            row = rows(k);
                                             x = T(row,1);
                                             x=table2array (x);
                                             y = T(row,2) ;
                                             y=table2array (y);
                                             sommot_sign = sommot(x,y);
                                             sommot_sign_all(:,row)  = sommot_sign;                     
                                        end

                                             mean_sommot_sign = mean(sommot_sign_all);
                                             mean_sommot_sign_all_str(subjind,:) = mean_sommot_sign;                                    

                                                                                                                                    
                                           T= readtable ( [NBS_path '/sommot_sign_str_increase.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
%                              
                                           rows = [1:rows];



                                       for k = 1:length(rows);
                                           row = rows(k);
                                            x = T(row,1);
                                            x=table2array (x);
                                            y = T(row,2) ;
                                            y=table2array (y);
                                            sommot_sign_increase = sommot(x,y);
                                            sommot_sign_increase_all(:,row)  = sommot_sign_increase;                     
                                        end

                                             mean_sommot_sign_increase = mean(sommot_sign_increase_all);
                                             mean_sommot_sign_all_str_increase(subjind,:) = mean_sommot_sign_increase;  

                               
   
                               
                                                                                          
                               
                              
                               
                               sommot_all_str(:,:,subjind)  = sommot;
                               
                               mean_sommot = tril(sommot);
                               mean_sommot(mean_sommot==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

%                                median_sommot = median(mean_sommot,'omitnan');
%                                median_sommot = median_sommot(~isnan(median_sommot));
%                                median_sommot = median(median_sommot);
%                                median_sommot_all_str(subjind,:) = median_sommot;

                               mean_sommot = mean(mean_sommot,'omitnan');
                               mean_sommot = mean_sommot(~isnan(mean_sommot));
                               mean_sommot = mean(mean_sommot);
                               mean_sommot_all_str(subjind,:) = mean_sommot;
                               
                               
                               [~, mod] = modularity_und(sommot);
                               modul_sommot(subjind,:) = mod;


                            %%  extracting Cont net and mean connectivity     


                               cont_lh = (61:73); % 
                               cont_rh = (165:181); 
                               %
                               cont_index = [cont_lh,cont_rh]; %
                               cont = Mat(cont_index, cont_index);

%% Extracting links decreasing significant with age

                                           T= readtable ( [NBS_path '/cont_sign_str.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
                              
                                           rows = [1:rows];

                                       for k = 1:length(rows);
                                            row = rows(k);
                                             x = T(row,1);
                                             x=table2array (x);
                                             y = T(row,2) ;
                                             y=table2array (y);
                                             cont_sign = cont(x,y);
                                             cont_sign_all(:,row)  = cont_sign;                     
                                        end

                                             mean_cont_sign = mean(cont_sign_all);
                                             mean_cont_sign_all_str(subjind,:) = mean_cont_sign; 


                                           T= readtable ( [NBS_path '/cont_sign_str_increase.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
%                              
                                           rows = [1:rows];



                                       for k = 1:length(rows);
                                           row = rows(k);
                                            x = T(row,1);
                                            x=table2array (x);
                                            y = T(row,2) ;
                                            y=table2array (y);
                                            cont_sign_increase = sommot(x,y);
                                            cont_sign_increase_all(:,row)  = cont_sign_increase;                     
                                        end

                                             mean_cont_sign_increase = mean(cont_sign_increase_all);
                                             mean_cont_sign_all_str_increase(subjind,:) = mean_cont_sign_increase;  
                                        





                               
                               cont_all_str(:,:,subjind)  = cont;
                               
                               
                               mean_cont = tril(cont);
                               mean_cont(mean_cont==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_cont = mean(mean_cont,'omitnan');
                               mean_cont = mean_cont(~isnan(mean_sommot));
                               mean_cont = mean(mean_cont);
                               mean_cont_all_str(subjind,:) = mean_cont;




                           %%  extracting Vis net and mean connectivity     


                               vis_lh = (1:14); % 
                               vis_rh = (101:115); 
                               %
                               vis_index = [vis_lh,vis_rh]; %
                               vis = Mat(vis_index, vis_index);

%% Extracting links decreasing significant with age

                                           T= readtable ( [NBS_path '/vis_sign_str.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
                              
                                           rows = [1:rows];

                                       for k = 1:length(rows);
                                            row = rows(k);
                                             x = T(row,1);
                                             x=table2array (x);
                                             y = T(row,2) ;
                                             y=table2array (y);
                                             vis_sign = vis(x,y);
                                             vis_sign_all(:,row)  = vis_sign;                     
                                        end

                                             mean_vis_sign = mean(vis_sign_all);
                                             mean_vis_sign_all_str(subjind,:) = mean_vis_sign;                                 

                                           T= readtable ( [NBS_path '/vis_sign_str_increase.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
%                              
                                           rows = [1:rows];



                                       for k = 1:length(rows);
                                           row = rows(k);
                                            x = T(row,1);
                                            x=table2array (x);
                                            y = T(row,2) ;
                                            y=table2array (y);
                                            vis_sign_increase = vis(x,y);
                                            vis_sign_increase_all(:,row)  = vis_sign_increase;                     
                                        end

                                             mean_vis_sign_increase = mean(vis_sign_increase_all);
                                             mean_vis_sign_all_str_increase(subjind,:) = mean_vis_sign_increase;  


                                 
                               vis_all_str(:,:,subjind)  = vis;
                               
                               mean_vis = tril(vis);
                               mean_vis(mean_vis==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_vis = mean(mean_vis,'omitnan');
                               mean_vis = mean_vis(~isnan(mean_vis));
                               mean_vis = mean(mean_vis);
                               mean_vis_all_str(subjind,:) = mean_vis;
                               
                               
                               

                               [~, mod] = modularity_und(vis);
                               modul_vis(subjind,:) = mod;

                          %%  extracting Limb net and mean connectivity     


                               limb_lh = (55:60); % 
                               limb_rh = (159:164); 
                               %
                               limb_index = [limb_lh,limb_rh]; %
                               limb = Mat(limb_index, limb_index);

 %% Extracting links decreasing significant with age

                                           T= readtable ( [NBS_path '/limb_sign_str.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
                              
                                           rows = [1:rows];

                                       for k = 1:length(rows);
                                            row = rows(k);
                                             x = T(row,1);
                                             x=table2array (x);
                                             y = T(row,2) ;
                                             y=table2array (y);
                                             limb_sign = limb(x,y);
                                             limb_sign_all(:,row)  = limb_sign;                     
                                        end

                                             mean_limb_sign = mean(limb_sign_all);
                                             mean_limb_sign_all_str(subjind,:) = mean_limb_sign;   

                                           T= readtable ( [NBS_path '/limb_sign_str_increase.csv']);
                                           table_size = size(T) ; 
                                           rows = table_size(1); 
%                              
                                           rows = [1:rows];



                                       for k = 1:length(rows);
                                           row = rows(k);
                                            x = T(row,1);
                                            x=table2array (x);
                                            y = T(row,2) ;
                                            y=table2array (y);
                                            limb_sign_increase = limb(x,y);
                                            limb_sign_increase_all(:,row)  = limb_sign_increase;                     
                                        end

                                             mean_limb_sign_increase = mean(limb_sign_increase_all);
                                             mean_limb_sign_all_str_increase(subjind,:) = mean_limb_sign_increase;                                             

                               limb_all_str(:,:,subjind)  = limb;
                               
                               mean_limb = tril(limb);
                               mean_limb(mean_limb==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_limb = mean(mean_limb,'omitnan');
                               mean_limb = mean_limb(~isnan(mean_limb));
                               mean_limb = mean(mean_limb);
                               mean_limb_all_str(subjind,:) = mean_limb;         
                               
%                                [~, mod] = modularity_und(limb);
%                                modul_limb(subjind,:) = mod;
%% Mean within connectivity                               
                               within = [mean_default,mean_dorsal,mean_salven, mean_sommot,mean_cont,mean_vis,mean_limb];
                               mean_within = mean(within);
                               mean_within_all(subjind,:) = mean_within;   
                               
                               
                               %% CONNECTIVITY BETWEEN NETWORKS
                               
                               
                               
                               
%                                   if absolute_values

                                     target_dir_bet = [hchs_dir, '/MRI_dwi/results_200_7/sift_radius2_' num2str(thresh) '/between_net']

                     
%                                   else
% % 
%                                      target_dir_bet = [hchs_dir, '/fMRI_resting/results_200_7/mean_36_' num2str(thresh) '/between_net'];
% 
%                                   end
                                         %%  extracting default and rest connectivity
                                         
                                           mat_index = (1:1:200); % Alle Rois abbilden
                                          
                                           % Rois specific for networks                                           
                                           default_lh = (74:100);  
                                           default_rh = (182:200); 
                                           
                                           default_index = [default_lh,default_rh]; 

%                                            dorsal_lh = (31:43); % 
%                                            dorsal_rh = (135:147);   

                                            rest_lh = (1:73); % 
                                            rest_rh = (101:181);

                                           rest_index = [ rest_lh, rest_rh]; %
                                           
                                           default_rest_index = [default_index,rest_index];
                                          

                                           default_rest = Mat(default_index, rest_index); % Extraktion für die mean connectivity zwischen den netzwerken
                                           
                                           
                                           default_rest_mat = Mat;    
                                           mat_index(default_rest_index) = []; %löschen der Indices für default
                                           
                                              % Deleting all connections other than these to networks

                                           default_rest_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           default_rest_mat(:,mat_index) = 0;% alle anderen Indices in der Matrix auf 0 setzen
                                           default_rest_mat(default_index,default_index) = 0;
                                           default_rest_mat(rest_index,rest_index) = 0;


                                           mean_default_rest_mat = tril(default_rest_mat); % for calculating mean only half of the matrix 
                                           mean_default_rest_mat(mean_default_rest_mat==0) = nan;
                                           
                                           mean_default_rest_mat = mean(mean_default_rest_mat,'omitnan'); % calculating mean for each column
                                           mean_default_rest_mat = mean_default_rest_mat(~isnan(mean_default_rest_mat)); % excluding columns with nan result 
                                           mean_default_rest_mat = mean(mean_default_rest_mat); 
                                           
                                           default_betw_all_str(subjind,:) = mean_default_rest_mat;
% 



                                           

                                       
                                       %%  extracting dorsal and rest connectivity
                                           mat_index = (1:1:200); % Alle Rois abbilden
                                          
                                           % Rois specific for networks                                           
                                           dorsal_lh = (31:43); % 
                                           dorsal_rh = (135:147);   
                                           
                                           dorsal_index = [dorsal_lh,dorsal_rh]; 

                                            rest_1 = (1:30); % 
                                            rest_2 = (44:146);
                                            rest_3 = (147:200);
                                            
                                           rest_index = [ rest_1, rest_2,rest_3]; %
                                           
                                           dorsal_rest_index = [dorsal_index,rest_index];
                                          

                                           dorsal_rest = Mat(dorsal_index, rest_index); % Extraktion für die mean connectivity zwischen den netzwerken
                                           
                                           
                                           dorsal_rest_mat = Mat;    
                                           mat_index(dorsal_rest_index) = []; %löschen der Indices für default
                                           
                                     % Deleting all connections other than these to networks

                                           dorsal_rest_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           dorsal_rest_mat(:,mat_index) = 0;% alle anderen Indices in der Matrix auf 0 setzen
                                           dorsal_rest_mat(dorsal_index,dorsal_index) = 0;
                                           dorsal_rest_mat(rest_index,rest_index) = 0;


                                           mean_dorsal_rest_mat = tril(dorsal_rest_mat); % for calculating mean only half of the matrix 
                                           mean_dorsal_rest_mat(mean_dorsal_rest_mat==0) = nan;
                                           
                                           mean_dorsal_rest_mat = mean(mean_dorsal_rest_mat,'omitnan'); % calculating mean for each column
                                           mean_dorsal_rest_mat = mean_dorsal_rest_mat(~isnan(mean_dorsal_rest_mat)); % excluding columns with nan result 
                                           mean_dorsal_rest_mat = mean(mean_dorsal_rest_mat); 
                                           
                                           dorsal_betw_all_str(subjind,:) = mean_dorsal_rest_mat;
                                                                                
                                                                         


                                



                                       %%  extracting salven and rest connectivity
                                       
                                           mat_index = (1:1:200);
                                           
                                           salven_lh = (44:54); % 
                                           salven_rh = (148:158);
                                           
                                           salven_index = [salven_lh,salven_rh];  
                                               
                                           rest_1 = (1:43); % 
                                           rest_2 = (55:147);
                                           rest_3 = (159:200);

                                           rest_index = [ rest_1, rest_2,rest_3]; 
                                           
                                           salven_rest_index = [salven_index,rest_index];                                            
                                           salven_rest = Mat(salven_index, rest_index);
                                                                                     
           
                                           salven_rest_mat = Mat;
                                           mat_index(salven_rest_index) = []; %löschen der Indices für salven

                                           salven_rest_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           salven_rest_mat(:,mat_index) = 0; 
                                           salven_rest_mat(salven_index,salven_index) = 0;
                                           salven_rest_mat(rest_index,rest_index) = 0;                                              

                                           
                                                                                      
                                           mean_salven_rest_mat = tril(salven_rest_mat); % for calculating mean only half of the matrix 
                                           mean_salven_rest_mat(mean_salven_rest_mat==0) = nan;
                                           
                                           mean_salven_rest_mat = mean(mean_salven_rest_mat,'omitnan'); % calculating mean for each column
                                           mean_salven_rest_mat = mean_salven_rest_mat(~isnan(mean_salven_rest_mat)); % excluding columns with nan result 
                                           mean_salven_rest_mat = mean(mean_salven_rest_mat);  
                                           
                                           salven_betw_all_str(subjind,:)  = mean_salven_rest_mat;
                                           
                                  
                             


                                        %%  extracting sommot and rest connectivity
                                          
                                           mat_index = (1:1:200);
                                           
                                           
                                           sommot_lh = (15:30); % 
                                           sommot_rh = (116:134);  
                                           
                                           sommot_index = [sommot_lh,sommot_rh];  
                                           
                                           
                                           rest_1 = (1:14); % 
                                           rest_2 = (31:115);
                                           rest_3 = (135:200);

                                           rest_index = [ rest_1, rest_2,rest_3]; 
                                           
                                           sommot_rest_index = [sommot_index,rest_index];                                           
                                           sommot_rest = Mat(sommot_index, rest_index);
                                                                                      
                                                                                      
                                           sommot_rest_mat = Mat;
                                           mat_index(sommot_rest_index) = []; %löschen der Indices für default

                                           sommot_rest_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           sommot_rest_mat(:,mat_index) = 0; 
                                           sommot_rest_mat(sommot_index,sommot_index) = 0;
                                           sommot_rest_mat(rest_index,rest_index) = 0;  
                                                                                                                                                                            
                                           mean_sommot_rest_mat = tril(sommot_rest_mat); % for calculating mean only half of the matrix 
                                           mean_sommot_rest_mat(mean_sommot_rest_mat==0) = nan;
                                           
                                           mean_sommot_rest_mat = mean(mean_sommot_rest_mat,'omitnan');% calculating mean for each column
                                           mean_sommot_rest_mat = mean_sommot_rest_mat(~isnan(mean_sommot_rest_mat)); % excluding columns with nan result 
                                           mean_sommot_rest_mat = mean(mean_sommot_rest_mat);    
                                           
                                           sommot_betw_all_str(subjind,:)  = mean_sommot_rest_mat;
                                




                                  

                                      %%  extracting cont and rest connectivity
                                        
                                           mat_index = (1:1:200);
                                           
                                           
                                           cont_lh = (61:73); % 
                                           cont_rh = (165:181);                                            

                                           cont_index = [cont_lh,cont_rh];  
                                           
                                           
                                           rest_1 = (1:60); % 
                                           rest_2 = (74:164);
                                           rest_3 = (182:200);

                                           rest_index = [ rest_1, rest_2,rest_3];                                            
                                           
                                           
                                           cont_rest_index = [cont_index,rest_index];   
                                           cont_rest = Mat(cont_index, rest_index);
                                                                                     

                                           
                                           cont_rest_mat = Mat;
                                           mat_index(cont_rest_index) = []; %löschen der Indices für default
                  
                                           cont_rest_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           cont_rest_mat(:,mat_index) = 0;  
                                           cont_rest_mat(cont_index,cont_index) = 0;
                                           cont_rest_mat(rest_index,rest_index) = 0;  

                                           
                                           mean_cont_rest_mat = tril(cont_rest_mat); % for calculating mean only half of the matrix 
                                           mean_cont_rest_mat(mean_cont_rest_mat==0) = nan;
                                           
                                           mean_cont_rest_mat = mean(mean_cont_rest_mat,'omitnan');% calculating mean for each column
                                           mean_cont_rest_mat = mean_cont_rest_mat(~isnan(mean_cont_rest_mat)); % excluding columns with nan result 
                                           mean_cont_rest_mat = mean(mean_cont_rest_mat);  
                                           
                                           cont_betw_all_str(subjind,:)  = mean_cont_rest_mat;
                                          







                                       %%  extracting vis and rest connectivity
                                           
                                          
                                           mat_index = (1:1:200); 
                                           
                                           vis_lh = (1:14); % 
                                           vis_rh = (101:115); 

                                           vis_index = [vis_lh,vis_rh];                                            
                                           
                                           rest_1 = (15:100); % 
                                           rest_2 = (116:200);
      

                                           rest_index = [ rest_1, rest_2];                                               
                                           
                                           
                                           vis_rest_index = [vis_index,rest_index]; 
                                           vis_rest = Mat(vis_index, rest_index);
                                                                                      
                                           
                                           vis_rest_mat = Mat;
                                           mat_index(vis_rest_index) = []; %löschen der Indices für default

                                           vis_rest_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           vis_rest_mat(:,mat_index) = 0;  
                                           vis_rest_mat(vis_index,vis_index) = 0;
                                           vis_rest_mat(rest_index,rest_index) = 0;  
                                           
                                           mean_vis_rest_mat = tril(vis_rest_mat); % for calculating mean only half of the matrix 
                                           mean_vis_rest_mat(mean_vis_rest_mat==0) = nan;
                                           
                                           mean_vis_rest_mat = mean(mean_vis_rest_mat,'omitnan'); % calculating mean for each column
                                           mean_vis_rest_mat = mean_vis_rest_mat(~isnan(mean_vis_rest_mat)); % excluding columns with nan result 
                                           mean_vis_rest_mat = mean(mean_vis_rest_mat);                                             
                                           
                                           vis_betw_all_str(subjind,:)  = mean_vis_rest_mat;
                                         

                                     %%  extracting limb and rest connectivity
                                           
                                          
                                           mat_index = (1:1:200); 
                                           
                                           limb_lh = (55:60); % 
                                           limb_rh = (159:164); 

                                           limb_index = [limb_lh,limb_rh]; %                                           
                                           
                                           rest_1 = (1:54); % 
                                           rest_2 = (61:158);
                                           rest_3 = (165:200);

                                           rest_index = [ rest_1, rest_2,rest_3];                                               
                                           
                                           
                                           limb_rest_index = [limb_index,rest_index]; 
                                           limb_rest = Mat(limb_index, rest_index);
                                                                                      
                                           
                                           limb_rest_mat = Mat;
                                           mat_index(limb_rest_index) = []; %löschen der Indices für default

                                           limb_rest_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           limb_rest_mat(:,mat_index) = 0;  
                                           limb_rest_mat(vis_index,vis_index) = 0;
                                           limb_rest_mat(rest_index,rest_index) = 0;  
                                           
                                           mean_limb_rest_mat = tril(limb_rest_mat); % for calculating mean only half of the matrix 
                                           mean_limb_rest_mat(mean_limb_rest_mat==0) = nan;
                                           
                                           mean_limb_rest_mat = mean(mean_limb_rest_mat,'omitnan');  % calculating mean for each column
                                           mean_limb_rest_mat = mean_limb_rest_mat(~isnan(mean_limb_rest_mat)); % excluding columns with nan result 
                                           mean_limb_rest_mat = mean(mean_limb_rest_mat);                                             
                                           
                                           limb_betw_all_str(subjind,:)  = mean_limb_rest_mat;
                                                                                                  
%% mean between connecitivity for all networks

% for all networks

                                           global_between = [mean_default_rest_mat,mean_dorsal_rest_mat,mean_salven_rest_mat  ...
                                                      mean_sommot_rest_mat,mean_cont_rest_mat,mean_vis_rest_mat,mean_limb_rest_mat];
                                                  
                                           mean_global_between =  mean(global_between);          
                                           mean_global_between_all_str(subjind,:) = mean_global_between; 
                                           
%% mean within connecitivity for all networks

                                           global_within = [mean_default,mean_dorsal,mean_salven  ...
                                                      mean_sommot,mean_cont,mean_vis,mean_limb];
                                                  
                                           mean_global_within =  mean(global_within);          
                                           mean_global_within_all_str(subjind,:) = mean_global_within; 

%% Segregation Coefficient
   % single networks                     
                    seg_default = mean_default - mean_default_rest_mat;
                    seg_default = seg_default ./ mean_default;
                    seg_default_all_str(subjind,:) = seg_default; 
                    
                    seg_dorsal = mean_dorsal - mean_dorsal_rest_mat;
                    seg_dorsal = seg_dorsal ./ mean_dorsal;
                    seg_dorsal_all_str(subjind,:) = seg_dorsal; 
                    
                    seg_salven = mean_salven - mean_salven_rest_mat;
                    seg_salven = seg_salven ./ mean_salven;
                    seg_salven_all_str(subjind,:) = seg_salven;
                                        
                    seg_sommot = mean_sommot - mean_sommot_rest_mat;
                    seg_sommot = seg_sommot ./ mean_sommot;
                    seg_sommot_all_str(subjind,:) = seg_sommot; 

                    seg_cont = mean_cont - mean_cont_rest_mat;
                    seg_cont = seg_cont ./ mean_cont;
                    seg_cont_all_str(subjind,:) = seg_cont; 
                    
                    seg_vis = mean_vis - mean_vis_rest_mat;
                    seg_vis = seg_vis ./ mean_vis;
                    seg_vis_all_str(subjind,:) = seg_vis;                     
                    
                    seg_limb = mean_limb - mean_limb_rest_mat;
                    seg_limb = seg_limb ./ mean_limb;
                    seg_limb_all_str(subjind,:) = seg_limb;   
                    
% Segregation global
                    seg_global = [seg_default, seg_dorsal, seg_salven, seg_sommot, seg_cont, seg_vis, seg_limb];
                    seg_global = mean(seg_global);
                    seg_global_all_str(subjind,:) = seg_global; 
                    
% Segregation association
                    seg_asso = [seg_default, seg_dorsal, seg_salven, seg_sommot, seg_cont,seg_limb];
                    seg_asso = mean(seg_asso);
                    seg_asso_all_str(subjind,:) = seg_asso; 

% Segregation sensory
                    seg_sensor = [seg_sommot,seg_vis];
                    seg_sensor = mean(seg_sensor);
                    seg_sensor_all_str(subjind,:) = seg_sensor; 
                                        
                                        
              end
  
                    mkdir (target_dir_with)
                    mkdir (target_dir_bet)
                    mkdir (target_dir_3d)


                    % Saving 3d connetivity matrix from networks                   
                    save([target_dir_3d '/default_all_str'],'default_all_str');
                    save([target_dir_3d '/dorsal_all_str'],'dorsal_all_str');
                    save([target_dir_3d '/salven_all_str'],'salven_all_str');
                    save([target_dir_3d '/sommot_all_str'],'sommot_all_str');
                    save([target_dir_3d '/cont_all_str'],'cont_all_str');
                    save([target_dir_3d '/conn_all_str'],'conn_all_str');
                   
                    save([target_dir_3d '/vis_all_str'],'vis_all_str');
                    save([target_dir_3d '/limb_all_str'],'limb_all_str');
                   
          

                    % Saving mean within connetivity networks                   
                    save([target_dir_with '/mean_default_str'],'mean_default_all_str');
                    save([target_dir_with '/mean_dorsal_str'],'mean_dorsal_all_str');
                    save([target_dir_with '/mean_salven_str'],'mean_salven_all_str');
                    save([target_dir_with '/mean_sommot_str'],'mean_sommot_all_str');
                    save([target_dir_with '/mean_cont_str'],'mean_cont_all_str');
                                      
                    save([target_dir_with '/mean_vis'],'mean_vis_all_str');
                    save([target_dir_with '/mean_limb'],'mean_limb_all_str');
                    save([target_dir_with '/mean_conn_str'],'mean_conn_all_str');
                    save([target_dir_with '/mean_global_within_str'],'mean_global_within_all_str');

                    save([target_dir_with '/median_sommot_str'],'median_sommot_all_str');


                    % Saving sginificant within connetivity networks 
                    save([target_dir_with '/mean_default_sign_str'],'mean_default_sign_all_str');
                    save([target_dir_with '/mean_dorsal_sign_str'],'mean_dorsal_sign_all_str');
                    save([target_dir_with '/mean_salven_sign_str'],'mean_salven_sign_all_str');
                    save([target_dir_with '/mean_sommot_sign_str'],'mean_sommot_sign_all_str');
                    save([target_dir_with '/mean_cont_sign_str'],'mean_cont_sign_all_str');
                   
                    save([target_dir_with '/mean_vis_sign_str'],'mean_vis_sign_all_str');
                    save([target_dir_with '/mean_limb_sign_str'],'mean_limb_sign_all_str');

                    % Saving sginificant increasing within connetivity networks 
                    save([target_dir_with '/mean_default_sign_str_increase'],'mean_default_sign_all_str_increase');
%                     save([target_dir_with '/mean_dorsal_sign_str_increase'],'mean_dorsal_sign_all_str_increase');
                    save([target_dir_with '/mean_salven_sign_str_increase'],'mean_salven_sign_all_str_increase');
                    save([target_dir_with '/mean_sommot_sign_str_increase'],'mean_sommot_sign_all_str_increase');
                    save([target_dir_with '/mean_cont_sign_str_increase'],'mean_cont_sign_all_str_increase');
                   
                    save([target_dir_with '/mean_vis_sign_str_increase'],'mean_vis_sign_all_str_increase');
                     save([target_dir_with '/mean_limb_sign_str_increase'],'mean_limb_sign_all_str_increase');                    
               

                    % Saving mean between connectivity of networks
                    save([target_dir_bet  '/mean_default_between_str'],'default_betw_all_str');
                    save([target_dir_bet  '/mean_dorsal_between_str'],'dorsal_betw_all_str');
                    save([target_dir_bet  '/mean_salven_between_str'],'salven_betw_all_str');
                    save([target_dir_bet  '/mean_sommot_between_str'],'sommot_betw_all_str');
                    save([target_dir_bet  '/mean_cont_between_str'],'cont_betw_all_str');
                   
                    save([target_dir_bet  '/mean_vis_between_str'],'vis_betw_all_str');
                    save([target_dir_bet  '/mean_limb_between_str'],'limb_betw_all_str');
                                      
                    save([target_dir_bet  '/mean_global_between_str'],'mean_global_between_all_str');     
                    
                    % Saving segregation of networks
                    save([target_dir_bet  '/mean_seg_default_str'],'seg_default_all_str');
                    save([target_dir_bet  '/mean_seg_dorsal_str'],'seg_dorsal_all_str');
                    save([target_dir_bet  '/mean_seg_salven_str'],'seg_salven_all_str');
                    save([target_dir_bet  '/mean_seg_sommot_str'],'seg_sommot_all_str');
                    save([target_dir_bet  '/mean_seg_cont_str'],'seg_cont_all_str');
                    
                    save([target_dir_bet  '/mean_seg_vis_str'],'seg_vis_all_str');
                    save([target_dir_bet  '/mean_seg_limb_str'],'seg_limb_all_str');
                    
                    % Saving segregation global
                    save([target_dir_bet  '/mean_seg_global_str'],'seg_global_all_str');
                    save([target_dir_bet  '/mean_seg_asso_str'],'seg_asso_all_str');
                    save([target_dir_bet  '/mean_seg_sensor_str'],'seg_sensor_all_str');
                    writecell(id_m,[hchs_dir '/id_subjects']);


      end