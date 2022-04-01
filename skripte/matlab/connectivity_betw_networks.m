%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis'
%conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];
conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];

% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];

main_txt_path = [hchs_dir '/sozio_data'];
absolute_values = 1;
default_dorsal_all = []
default_salven_all = []
default_sommot_all = []
default_cont_all   = []
default_vis_all    = []
 


BCT_path = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis/BCT/2019_03_03_BCT';
addpath(BCT_path);
 

 all_thresh = [ 0.5 ]; % 0 0.1 0.3 0.7 0.9
 num_thresh = length(all_thresh);
 
 broken_subjects = 'sub-2016203f.mat'


%% Sorting Subjects
      
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
            all_subjects     = cellstr(all_subjects_str);
            
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

 %% Vorbereiten von Matrizen Datensatz

         id_m = cell(length(all_subjects),1);
         for subjind = 1:length(all_subjects);
             csubj = all_subjects{subjind};
             nsubj=csubj(1:12);
             nsubj=strsplit(nsubj);
             id_m(subjind,:) = nsubj;       
         end
         
       tbl = readtable([main_txt_path '/data.xlsx']) ; 

          id = tbl.DisclosureID;
          
         
         % Angleichen der Nomenklatur
             str2 = 'sub-';
         for subjind = 1:length(id)
             csubj = id{subjind};
             nsubj=strcat(str2,csubj);
             nsubj=strsplit(nsubj);
             id(subjind,:)=nsubj;            
         end

%% Angleichen von Matrizen an Age Datensatz         
         
         % Index der Subjects die in der Demographie Tabelle aber nicht bei
         % den Matrizen enthalten sind
           ex1 = setdiff(id,id_m) ; 
           [~,idx] = ismember(id,ex1);
           [idx1] = find(idx);
         
           id(idx1, :) = [];
     
           
          tbl(idx1, :) = []; %löschen der subjects für die keine Tabelleneinträge existieren
          [~,idx] = sortrows(tbl(:,3)); % sortieren der Tabelle nach Subject ID
          tbl = tbl(idx,:);
          id = sort(id); %  sortieren des Subject ID arrays
          
          ex3 = setdiff(id_m,id);  % Subjects die in Matrizen aber nicht in Demographie Tabelle exisiteren  
          [~,idx3] = ismember(id_m,ex3);
          [idx3] = find(idx3);
           
          id_m(idx3) = []; % %löschen der subjects für die keine Matrizen existieren
            
           
          all_subjects(idx3) = []; % löschen der Matrizen  die nicht im Demographie Datensatz sind
 
         

           

         setdiff(id_m,id);
         setdiff(id,id_m);

%% Loop through Subjects
      for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_abs_' num2str(thresh) '/between_net'];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_' num2str(thresh) '/between_net'];
%                              
%                       end


                      if absolute_values

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh) '/between_net'];
                      else

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh) '/between_net'];
                             
                      end
                      
%                       
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_abs_' num2str(thresh) '/between_net'];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_' num2str(thresh) '/between_net'];
%                              
%                       end

                      
                      
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_36_abs_' num2str(thresh) '/between_net'];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_36_' num2str(thresh) '/between_net'];
%                              
%                       end

                        mkdir(target_dir);
                        
                          for subjind = 1:length(all_subjects)

                                        subject = all_subjects{subjind};
                                        load([conn_dir '/' subject]);
                                        
                                        if absolute_values
                                           Mat = abs(Mat);
                                        end  
                                        
                                          Mat = threshold_proportional(Mat, (1-thresh));
                                          mean_conn = mean(mean(Mat));

                                         %%  extracting default and dorsal connectivity
                                         
                                           mat_index = (1:1:200); % Alle Rois abbilden
                                          
                                           % Rois specific for networks                                           
                                           default_lh = (74:100);  
                                           default_rh = (182:200); 
                                           
                                           default_index = [default_lh,default_rh]; 

                                           dorsal_lh = (31:43); % 
                                           dorsal_rh = (135:147);   

                                           dorsal_index = [ dorsal_lh, dorsal_rh]; %
                                           
                                           default_dorsal_index = [default_index,dorsal_index];
                                          

                                           default_dorsal = Mat(default_index, dorsal_index); % Extraktion für die mean connectivity zwischen den netzwerken
                                           
                                           
                                           default_dorsal_mat = Mat;    
                                           mat_index(default_dorsal_index) = []; %löschen der Indices für default
                                           
                                     % Deleting all connections other than these to networks

                                           default_dorsal_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           default_dorsal_mat(:,mat_index) = 0;% alle anderen Indices in der Matrix auf 0 setzen
                                           default_dorsal_mat(default_index,default_index) = 0;
                                           default_dorsal_mat(dorsal_index,dorsal_index) = 0;


                                           mean_default_dorsal_mat = tril(default_dorsal_mat); % for calculating mean only half of the matrix 
                                           mean_default_dorsal_mat(mean_default_dorsal_mat==0) = nan;
                                           
                                           mean_default_dorsal_mat = nanmean(mean_default_dorsal_mat); % calculating mean for each column
                                           mean_default_dorsal_mat = mean_default_dorsal_mat(~isnan(mean_default_dorsal_mat)); % excluding columns with nan result 
                                           mean_default_dorsal_mat = mean(mean_default_dorsal_mat); 
                                           
                                           default_dorsal_all(subjind,:) = mean_default_dorsal_mat;
% 
%                                            default_dorsal_all(:,:,subjind)  = default_dorsal_mat;
%                                                                                                                               

                                            % Calculating mean of one half of symetric connectivity matrix

%                                            mean_default_dorsal = tril(default_dorsal); % for calculating mean only half of the matrix 
%                                            mean_default_dorsal(mean_default_dorsal==0) = nan;                                           
%                                            mean_default_dorsal = nanmean(mean_default_dorsal); % calculating mean for each column
%                                            mean_default_dorsal = mean_default_dorsal(~isnan(mean_default_dorsal)); % excluding columns with nan result 
%                                            mean_default_dorsal = mean(mean_default_dorsal); 
                                           
% 
%                                            mean_default_dorsal = mean(default_dorsal);
%                                            mean_default_dorsal = mean(mean_default_dorsal);

                                        %%  extracting default and salven connectivity
                                        
                                           mat_index = (1:1:200);


                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           salven_lh = (44:54); % 
                                           salven_rh = (148:158);  

                                           salven_index = [salven_lh,salven_rh]; %
                                           
                                           default_salven_index = [default_index,salven_index];

                                           default_salven = Mat(default_index, salven_index);
                                           
                                           default_salven_mat = Mat;    
                                           mat_index(default_salven_index) = []; %löschen der Indices für default
                                         
                                           default_salven_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           default_salven_mat(:,mat_index) = 0;% alle anderen Indices in der Matrix auf 0 setzen
                                           default_salven_mat(default_index,default_index) = 0;
                                           default_salven_mat(dorsal_index,dorsal_index) = 0;


                                           mean_default_salven_mat = tril(default_salven_mat); % for calculating mean only half of the matrix 
                                           mean_default_salven_mat(mean_default_salven_mat==0) = nan;
                                           
                                           mean_default_salven_mat = nanmean(mean_default_salven_mat); % calculating mean for each column
                                           mean_default_salven_mat = mean_default_salven_mat(~isnan(mean_default_salven_mat)); % excluding columns with nan result 
                                           mean_default_salven_mat = mean(mean_default_salven_mat); 
                                           
                                           default_salven_all(:,:,subjind)  = mean_default_salven_mat;
                                                                                      
                                          
%                                            default_salven_mat = Mat;
%                                            mat_index(default_salven_index) = []; %löschen der Indices für default
% 
%                                            default_salven_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
%                                            default_salven_mat(:,mat_index) = 0;
%              
%                                            default_salven_mat(default_index,default_index) = 0;
%                                            default_salven_mat(salven_index,salven_index) = 0;                                          
                                                                                                                                 
                                         
% 
%                                            mean_default_salven = mean(default_salven);
%                                            mean_default_salven = mean(mean_default_salven);


%                                            mean_default_salven_all(subjind,:) = mean_default_salven;
                                                                                                                               
                                        %%  extracting default and sommot connectivity
                                        
                                           mat_index = (1:1:200);

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           sommot_lh = (15:30); % 
                                           sommot_rh = (116:134);  

                                           sommot_index = [ sommot_lh, sommot_rh]; %%
                                           
                                           default_sommot_index = [default_index,sommot_index];                                           
                                           default_sommot = Mat(default_index, sommot_index);
                                           
                                           
                                           default_sommot_mat = Mat;
                                           mat_index(default_sommot_index) = []; %löschen der Indices für default

                                           default_sommot_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           default_sommot_mat(:,mat_index) = 0;
                                           default_sommot_mat(default_index,default_index) = 0;
                                           default_sommot_mat(sommot_index,sommot_index) = 0;                                               
                                          
                                           mean_default_sommot_mat = tril(default_sommot_mat); % for calculating mean only half of the matrix 
                                           mean_default_sommot_mat(mean_default_sommot_mat==0) = nan;
                                           
                                           mean_default_sommot_mat = nanmean(mean_default_sommot_mat); % calculating mean for each column
                                           mean_default_sommot_mat = mean_default_sommot_mat(~isnan(mean_default_sommot_mat)); % excluding columns with nan result 
                                           mean_default_sommot_mat = mean(mean_default_sommot_mat); 
                                           
                                           default_sommot_all(:,:,subjind)  = mean_default_sommot_mat;
                            

%                                            mean_default_sommot = mean(default_sommot);
%                                            mean_default_sommot = mean(mean_default_sommot);

%                                            mean_default_sommot_all(subjind,:) = mean_default_sommot;


                                       %%  extracting default and cont connectivity
                                       
                                           mat_index = (1:1:200);

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           cont_lh = (61:73); % 
                                           cont_rh = (165:181); 

                                           cont_index = [cont_lh,cont_rh]; %%
                                           
                                           default_cont_index = [default_index,cont_index];                                            
                                           default_cont = Mat(default_index, cont_index);
                                           
                                           
                                           default_cont_mat = Mat;
                                           mat_index(default_cont_index) = []; %löschen der Indices für default

                                           default_cont_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           default_cont_mat(:,mat_index) = 0;  
                                           default_cont_mat(default_index,default_index) = 0;
                                           default_cont_mat(cont_index,cont_index) = 0; 
                                           
                                           
                                           mean_default_cont_mat = tril(default_cont_mat); % for calculating mean only half of the matrix 
                                           mean_default_cont_mat(mean_default_cont_mat==0) = nan;
                                           
                                           mean_default_cont_mat = nanmean(mean_default_cont_mat); % calculating mean for each column
                                           mean_default_cont_mat = mean_default_cont_mat(~isnan(mean_default_cont_mat)); % excluding columns with nan result 
                                           mean_default_cont_mat = mean(mean_default_cont_mat); 
                                           
                                           default_cont_all(:,:,subjind)  = mean_default_cont_mat;
                                   

%                                            mean_default_cont = mean(default_cont);
%                                            mean_default_cont = mean(mean_default_cont);
% 
% 
%                                            mean_default_cont_all(subjind,:) = mean_default_cont;



                                       %%  extracting default and vis connectivity
                                       
                                           mat_index = (1:1:200);

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           vis_lh = (1:14); % 
                                           vis_rh = (101:115); 

                                           vis_index = [vis_lh,vis_rh];; %%
                                           default_vis = Mat(default_index, vis_index);
                                           
                                           default_vis_index = [default_index,vis_index];  
                                           default_vis_mat = Mat;
                                           
                                           mat_index(default_vis_index) = []; %löschen der Indices für default

                                           default_vis_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           default_vis_mat(:,mat_index) = 0; 
                                           default_vis_mat(default_index,default_index) = 0;
                                           default_vis_mat(vis_index,vis_index) = 0; 
                                           
                                           mean_default_vis_mat = tril(default_vis_mat); % for calculating mean only half of the matrix 
                                           mean_default_vis_mat(mean_default_vis_mat==0) = nan;
                                           
                                           mean_default_vis_mat = nanmean(mean_default_vis_mat); % calculating mean for each column
                                           mean_default_vis_mat = mean_default_vis_mat(~isnan(mean_default_vis_mat)); % excluding columns with nan result 
                                           mean_default_vis_mat = mean(mean_default_vis_mat); 
                                           
                                           default_vis_all(:,:,subjind)  = mean_default_vis_mat;
                                 

                                           
%                                            mean_default_vis = mean(default_vis);
%                                            mean_default_vis = mean(mean_default_vis);
% 
% 
%                                            mean_default_vis_all(subjind,:) = mean_default_vis;        

                                       %%  extracting default and limb connectivity
                                       
                                           mat_index = (1:1:200);


                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 
                                           
                                           limb_lh = (55:60); % 
                                           limb_rh = (159:164); 
                               %
                                           limb_index = [limb_lh,limb_rh]; %
                                                                                      
                                          
                                           default_limb_index = [default_index,limb_index];                                           
                                           default_limb = Mat(default_index, limb_index);
                                           

                                           default_limb_mat = Mat;
                                           mat_index(default_cont_index) = []; %löschen der Indices für default

                                           default_limb_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           default_limb_mat(:,mat_index) = 0; 
                                           default_limb_mat(default_index,default_index) = 0;
                                           default_limb_mat(limb_index,limb_index) = 0;                                            

                                           mean_default_limb_mat = tril(default_limb_mat); % for calculating mean only half of the matrix 
                                           mean_default_limb_mat(mean_default_limb_mat==0) = nan;
                                           
                                           mean_default_limb_mat = nanmean(mean_default_limb_mat); % calculating mean for each column
                                           mean_default_limb_mat = mean_default_limb_mat(~isnan(mean_default_limb_mat)); % excluding columns with nan result 
                                           mean_default_limb_mat = mean(mean_default_limb_mat); 
                                           
                                           
                                           default_limb_all(:,:,subjind)  = mean_default_limb_mat;
                                           

                                        

%                                            mean_default_limb = mean(default_limb);
%                                            mean_default_limb = mean(mean_default_limb);
% 
% 
%                                            mean_default_limb_all(subjind,:) = mean_default_limb; 



                                       %%  extracting dorsal and salven connectivity
                                       
                                           mat_index = (1:1:200);

                                           dorsal_salven = Mat(dorsal_index, salven_index);
                                           
                                           dorsal_salven_index = [dorsal_index,salven_index];    
                                           dorsal_salven_mat = Mat;
                                           
                                           mat_index(dorsal_salven_index) = []; %löschen der Indices für default

                                           dorsal_salven_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           dorsal_salven_mat(:,mat_index) = 0; 
                                           dorsal_salven_mat(dorsal_index,dorsal_index) = 0;
                                           dorsal_salven_mat(salven_index,salven_index) = 0;
                                           
                                                                                      
                                           mean_dorsal_salven_mat = tril(dorsal_salven_mat); % for calculating mean only half of the matrix 
                                           mean_dorsal_salven_mat(mean_dorsal_salven_mat==0) = nan;
                                           
                                           mean_dorsal_salven_mat = nanmean(mean_dorsal_salven_mat); % calculating mean for each column
                                           mean_dorsal_salven_mat = mean_dorsal_salven_mat(~isnan(mean_dorsal_salven_mat)); % excluding columns with nan result 
                                           mean_dorsal_salven_mat = mean(mean_dorsal_salven_mat); 
                                           
                                           dorsal_salven_all(:,:,subjind)  = mean_dorsal_salven_mat;
                                                                                
                                           
                              

%                                            mean_dorsal_salven = mean(dorsal_salven);
%                                            mean_dorsal_salven = mean(mean_dorsal_salven);
% 
% 
%                                            mean_dorsal_salven_all(subjind,:) = mean_dorsal_salven;    

                                       %%  extracting dorsal and sommot connectivity
                                       
                                           mat_index = (1:1:200);
                                           
                                           dorsal_sommot_index = [dorsal_index,sommot_index];   
                                           dorsal_sommot = Mat(dorsal_index, sommot_index);

                                           
                                           dorsal_sommot_mat = Mat;
                                           mat_index(dorsal_sommot_index) = []; %löschen der Indices für default

                                           dorsal_sommot_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           dorsal_sommot_mat(:,mat_index) = 0; 
                                           dorsal_sommot_mat(dorsal_index,dorsal_index) = 0;
                                           dorsal_sommot_mat(sommot_index,sommot_index) = 0; 
                                           
                                           mean_dorsal_sommot_mat = tril(dorsal_sommot_mat); % for calculating mean only half of the matrix 
                                           mean_dorsal_sommot_mat(mean_dorsal_sommot_mat==0) = nan;
                                           
                                           mean_dorsal_sommot_mat = nanmean(mean_dorsal_sommot_mat); % calculating mean for each column
                                           mean_dorsal_sommot_mat = mean_dorsal_sommot_mat(~isnan(mean_dorsal_sommot_mat)); % excluding columns with nan result 
                                           mean_dorsal_sommot_mat = mean(mean_dorsal_sommot_mat); 
                                           
                                           
                                           dorsal_sommot_all(:,:,subjind)  = mean_dorsal_sommot_mat;
                                                                                 
                                                                        
%                                            mean_dorsal_sommot = mean(dorsal_sommot);
%                                            mean_dorsal_sommot = mean(mean_dorsal_sommot);
% 
% 
%                                            mean_dorsal_sommot_all(subjind,:) = mean_dorsal_sommot;    


                                       %%  extracting dorsal and cont connectivity
                                       
                                           mat_index = (1:1:200);
                                           
                                           dorsal_cont_index = [dorsal_index,cont_index];                                         
                                           dorsal_cont = Mat(dorsal_index, cont_index);                                           

                                           
                                           dorsal_cont_mat = Mat;
                                           mat_index(dorsal_cont_index) = []; %löschen der Indices für default
         
                                           dorsal_cont_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           dorsal_cont_mat(:,mat_index) = 0; 
                                           dorsal_cont_mat(dorsal_index,dorsal_index) = 0;
                                           dorsal_cont_mat(cont_index,cont_index) = 0; 
                                           
                                           mean_dorsal_cont_mat = tril(dorsal_cont_mat); % for calculating mean only half of the matrix 
                                           mean_dorsal_cont_mat(mean_dorsal_cont_mat==0) = nan;
                                           
                                           mean_dorsal_cont_mat = nanmean(mean_dorsal_cont_mat); % calculating mean for each column
                                           mean_dorsal_cont_mat = mean_dorsal_cont_mat(~isnan(mean_dorsal_cont_mat)); % excluding columns with nan result 
                                           mean_dorsal_cont_mat = mean(mean_dorsal_cont_mat);                                            
                                           
                                           
                                           dorsal_cont_all(:,:,subjind)  = mean_dorsal_cont_mat;
                                                                                 

%                                            mean_dorsal_cont = mean(dorsal_cont);
%                                            mean_dorsal_cont = mean(mean_dorsal_cont);
% 
% 
%                                            mean_dorsal_cont_all(subjind,:) = mean_dorsal_cont;   


                                       %%  extracting dorsal and vis connectivity
                                       
                                           mat_index = (1:1:200);

                                           dorsal_vis_index = [dorsal_index,vis_index]; 
                                           dorsal_vis = Mat(dorsal_index, vis_index);
                                           
                                           
                                           
                                           dorsal_vis_mat = Mat;
                                           mat_index(dorsal_vis_index) = []; %löschen der Indices für default

                                           dorsal_vis_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           dorsal_vis_mat(:,mat_index) = 0; 
                                           dorsal_vis_mat(dorsal_index,dorsal_index) = 0;
                                           dorsal_vis_mat(vis_index,vis_index) = 0;
                                           
                                                                                                                                 
                                           mean_dorsal_vis_mat = tril(dorsal_vis_mat); % for calculating mean only half of the matrix 
                                           mean_dorsal_vis_mat(mean_dorsal_vis_mat==0) = nan;
                                           
                                           mean_dorsal_vis_mat = nanmean(mean_dorsal_vis_mat); % calculating mean for each column
                                           mean_dorsal_vis_mat = mean_dorsal_vis_mat(~isnan(mean_dorsal_vis_mat)); % excluding columns with nan result 
                                           mean_dorsal_vis_mat = mean(mean_dorsal_vis_mat); 
                                           
                                           dorsal_vis_all(:,:,subjind)  = mean_dorsal_vis_mat;


%                                            mean_dorsal_vis = mean(dorsal_vis);
%                                            mean_dorsal_vis = mean(mean_dorsal_vis);
% 
% 
%                                            mean_dorsal_vis_all(subjind,:) = mean_dorsal_vis;   

                                       %%  extracting dorsal and limb connectivity
                                       
                                           mat_index = (1:1:200);
                                           
                                           dorsal_limb_index = [dorsal_index,limb_index]; 
                                           dorsal_limb = Mat(dorsal_index, limb_index);
                                                                                                                                 
                                                                                                                                 
                                           dorsal_limb_mat = Mat;
                                           mat_index(dorsal_limb_index) = []; %löschen der Indices für default

                                           dorsal_limb_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           dorsal_limb_mat(:,mat_index) = 0; 
                                           dorsal_limb_mat(dorsal_index,dorsal_index) = 0;
                                           dorsal_limb_mat(limb_index,limb_index) = 0;    

                                                                                                                                                                           
                                           mean_dorsal_limb_mat = tril(dorsal_limb_mat); % for calculating mean only half of the matrix 
                                           mean_dorsal_limb_mat(mean_dorsal_limb_mat==0) = nan;
                                           
                                           mean_dorsal_limb_mat = nanmean(mean_dorsal_limb_mat); % calculating mean for each column
                                           mean_dorsal_limb_mat = mean_dorsal_limb_mat(~isnan(mean_dorsal_limb_mat)); % excluding columns with nan result 
                                           mean_dorsal_limb_mat = mean(mean_dorsal_limb_mat);   
                                           
                                           dorsal_limb_all(:,:,subjind)  = mean_dorsal_limb_mat;
                                

%                                            mean_dorsal_limb = mean(dorsal_limb);
%                                            mean_dorsal_limb = mean(mean_dorsal_limb);
% 
% 
%                                            mean_dorsal_limb_all(subjind,:) = mean_dorsal_limb;   



                                       %%  extracting salven and sommot connectivity
                                       
                                           mat_index = (1:1:200);

                                           salven_sommot_index = [salven_index,sommot_index];                                            
                                           salven_sommot = Mat(salven_index, sommot_index);
                                                                                     
           
                                           salven_sommot_mat = Mat;
                                           mat_index(salven_sommot_index) = []; %löschen der Indices für default

                                           salven_sommot_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           salven_sommot_mat(:,mat_index) = 0; 
                                           salven_sommot_mat(salven_index,salven_index) = 0;
                                           salven_sommot_mat(sommot_index,sommot_index) = 0;                                              

                                           
                                                                                      
                                           mean_salven_sommot_mat = tril(salven_sommot_mat); % for calculating mean only half of the matrix 
                                           mean_salven_sommot_mat(mean_salven_sommot_mat==0) = nan;
                                           
                                           mean_salven_sommot_mat = nanmean(mean_salven_sommot_mat); % calculating mean for each column
                                           mean_salven_sommot_mat = mean_salven_sommot_mat(~isnan(mean_salven_sommot_mat)); % excluding columns with nan result 
                                           mean_salven_sommot_mat = mean(mean_salven_sommot_mat);  
                                           
                                           salven_sommot_all(:,:,subjind)  = mean_salven_sommot_mat;
                                           
                                  
                             

%                                            mean_salven_sommot = mean(salven_sommot);
%                                            mean_salven_sommot = mean(mean_salven_sommot);
% 
% 
%                                            mean_salven_sommot_all(subjind,:) = mean_salven_sommot;  



                                      %%  extracting salven and cont connectivity
                                      
                                           mat_index = (1:1:200);
                                           
                                           salven_cont_index = [salven_index,cont_index];                                           
                                           salven_cont = Mat(salven_index, cont_index);

                                           
                                           salven_cont_mat = Mat;
                                           mat_index(salven_cont_index) = []; %löschen der Indices für default

                                           salven_cont_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           salven_cont_mat(:,mat_index) = 0; 
                                           salven_cont_mat(salven_index,salven_index) = 0;
                                           salven_cont_mat(cont_index,cont_index) = 0;                                                 

                                           
                                           mean_salven_cont_mat = tril(salven_cont_mat); % for calculating mean only half of the matrix 
                                           mean_salven_cont_mat(mean_salven_cont_mat==0) = nan;
                                           
                                           mean_salven_cont_mat = nanmean(mean_salven_cont_mat); % calculating mean for each column
                                           mean_salven_cont_mat = mean_salven_cont_mat(~isnan(mean_salven_cont_mat)); % excluding columns with nan result 
                                           mean_salven_cont_mat = mean(mean_salven_cont_mat);                                             
                                           
                                           
                                           salven_cont_all(:,:,subjind)  = mean_salven_cont_mat;
                                               
                                                                                                                                                                                                

%                                            mean_salven_cont = mean(salven_cont);
%                                            mean_salven_cont = mean(mean_salven_cont);
% 
% 
%                                            mean_salven_cont_all(subjind,:) = mean_salven_cont;  



                                       %%  extracting salven and vis connectivity
                                           
                                       
                                           mat_index = (1:1:200);
                                           
                                           salven_vis_index = [salven_index,vis_index];                                            
                                           salven_vis = Mat(salven_index, vis_index);

                                           
                                           salven_vis_mat = Mat;
                                           mat_index(salven_vis_index) = []; %löschen der Indices für default

                                           salven_vis_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           salven_vis_mat(:,mat_index) = 0; 
                                           salven_vis_mat(salven_index,salven_index) = 0;
                                           salven_vis_mat(vis_index,vis_index) = 0;     
                                         
                                           mean_salven_vis_mat = tril(salven_vis_mat); % for calculating mean only half of the matrix 
                                           mean_salven_vis_mat(mean_salven_vis_mat==0) = nan;
                                           
                                           mean_salven_vis_mat = nanmean(mean_salven_vis_mat); % calculating mean for each column
                                           mean_salven_vis_mat = mean_salven_vis_mat(~isnan(mean_salven_vis_mat)); % excluding columns with nan result 
                                           mean_salven_vis_mat = mean(mean_salven_vis_mat);         
                                           
                                           
                                           salven_vis_all(:,:,subjind)  = mean_salven_vis_mat;
                                           
                                                                             

%                                            mean_salven_vis = mean(salven_vis);
%                                            mean_salven_vis = mean(mean_salven_vis);
% 
% 
%                                            mean_salven_vis_all(subjind,:) = mean_salven_vis;  

                                      %%  extracting salven and limb connectivity
                                      
                                           mat_index = (1:1:200);
                                           
                                           salven_limb_index = [salven_index,limb_index];                                               
                                           salven_limb = Mat(salven_index, limb_index);
                                                                                      
                                           
                                           salven_limb_mat = Mat;
                                           mat_index(salven_limb_index) = []; %löschen der Indices für default

                                           salven_limb_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           salven_limb_mat(:,mat_index) = 0; 
                                           salven_limb_mat(salven_index,salven_index) = 0;
                                           salven_limb_mat(limb_index,limb_index) = 0;                                           
                                           
                                           mean_salven_limb_mat = tril(salven_limb_mat); % for calculating mean only half of the matrix 
                                           mean_salven_limb_mat(mean_salven_limb_mat==0) = nan;
                                           
                                           mean_salven_limb_mat = nanmean(mean_salven_limb_mat); % calculating mean for each column
                                           mean_salven_limb_mat = mean_salven_limb_mat(~isnan(mean_salven_limb_mat)); % excluding columns with nan result 
                                           mean_salven_limb_mat = mean(mean_salven_limb_mat);                                                
                                           
                                           salven_limb_all(:,:,subjind)  = mean_salven_limb_mat;
                                

%                                            mean_salven_limb = mean(salven_limb);
%                                            mean_salven_limb = mean(mean_salven_limb);
% 
% 
%                                            mean_salven_limb_all(subjind,:) = mean_salven_limb;  




                                        %%  extracting sommot and cont connectivity
                                          
                                           mat_index = (1:1:200);
                                                
                                           sommot_cont_index = [sommot_index,cont_index];                                           
                                           sommot_cont = Mat(sommot_index, cont_index);
                                                                                      
                                                                                      
                                           sommot_cont_mat = Mat;
                                           mat_index(sommot_cont_index) = []; %löschen der Indices für default

                                           sommot_cont_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           sommot_cont_mat(:,mat_index) = 0; 
                                           sommot_cont_mat(sommot_index,sommot_index) = 0;
                                           sommot_cont_mat(limb_index,limb_index) = 0;  
                                                                                                                                                                            
                                           mean_sommot_cont_mat = tril(sommot_cont_mat); % for calculating mean only half of the matrix 
                                           mean_sommot_cont_mat(mean_sommot_cont_mat==0) = nan;
                                           
                                           mean_sommot_cont_mat = nanmean(mean_sommot_cont_mat); % calculating mean for each column
                                           mean_sommot_cont_mat = mean_sommot_cont_mat(~isnan(mean_sommot_cont_mat)); % excluding columns with nan result 
                                           mean_sommot_cont_mat = mean(mean_sommot_cont_mat);    
                                           
                                           sommot_cont_all(:,:,subjind)  = mean_sommot_cont_mat;
                                

%                                            mean_sommot_cont = mean(sommot_cont);
%                                            mean_sommot_cont = mean(mean_sommot_cont);
% 
% 
%                                            mean_sommot_cont_all(subjind,:) = mean_sommot_cont;  




                                       %%  extracting sommot and vis connectivity
                                       
                                           mat_index = (1:1:200);
                                           
                                           sommot_vis_index = [sommot_index,vis_index];                                           
                                           sommot_vis = Mat(sommot_index, vis_index);
                                                                                      
                                           
                                           sommot_vis_mat = Mat;
                                           mat_index(sommot_vis_index) = []; %löschen der Indices für default

                                           sommot_vis_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           sommot_vis_mat(:,mat_index) = 0;  
                                           sommot_vis_mat(sommot_index,sommot_index) = 0;
                                           sommot_vis_mat(vis_index,vis_index) = 0;                                           

                                           mean_sommot_vis_mat= tril(sommot_vis_mat); % for calculating mean only half of the matrix 
                                           mean_sommot_vis_mat(mean_sommot_vis_mat==0) = nan;
                                           
                                           mean_sommot_vis_mat = nanmean(mean_sommot_vis_mat); % calculating mean for each column
                                           mean_sommot_vis_mat = mean_sommot_vis_mat(~isnan(mean_sommot_vis_mat)); % excluding columns with nan result 
                                           mean_sommot_vis_mat = mean(mean_sommot_vis_mat);                                              
                                           
                                           sommot_vis_all(:,:,subjind)  = mean_sommot_vis_mat;
                                           
                                           

%                                            mean_sommot_vis_all(subjind,:) = mean_sommot_vis;  



                                       %%  extracting sommot and limb connectivity
                                       
                                           mat_index = (1:1:200);
                                           
                                           sommot_limb_index = [sommot_index,limb_index];                                            
                                           sommot_limb = Mat(sommot_index, limb_index);

                                           
                                           sommot_limb_mat = Mat;
                                           mat_index(sommot_limb_index) = []; %löschen der Indices für default

                                           sommot_limb_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           sommot_limb_mat(:,mat_index) = 0;   
                                           sommot_limb_mat(sommot_index,sommot_index) = 0;
                                           sommot_limb_mat(limb_index,limb_index) = 0;                                              
                                                                                      
                                           mean_sommot_limb_mat = tril(sommot_limb_mat); % for calculating mean only half of the matrix 
                                           mean_sommot_limb_mat(mean_sommot_limb_mat==0) = nan;
                                           
                                           mean_sommot_limb_mat = nanmean(mean_sommot_limb_mat); % calculating mean for each column
                                           mean_sommot_limb_mat = mean_sommot_limb_mat(~isnan(mean_sommot_limb_mat)); % excluding columns with nan result 
                                           mean_sommot_limb_mat = mean(mean_sommot_limb_mat);                                            
                                           
                                           sommot_limb_all(:,:,subjind)  = mean_sommot_limb_mat;

                                  

%                                            mean_sommot_limb= mean(sommot_limb);
%                                            mean_sommot_limb = mean(mean_sommot_limb);
% 
% 
%                                            mean_sommot_limb_all(subjind,:) = mean_sommot_limb;  




                                      %%  extracting cont and vis connectivity
                                        
                                           mat_index = (1:1:200); 

                                           cont_vis_index = [cont_index,vis_index];   
                                           cont_vis = Mat(cont_index, vis_index);
                                                                                     

                                           
                                           cont_vis_mat = Mat;
                                           mat_index(cont_vis_index) = []; %löschen der Indices für default
                  
                                           cont_vis_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           cont_vis_mat(:,mat_index) = 0;  
                                           cont_vis_mat(cont_index,cont_index) = 0;
                                           cont_vis_mat(vis_index,vis_index) = 0;  

                                           
                                           mean_cont_vis_mat = tril(cont_vis_mat); % for calculating mean only half of the matrix 
                                           mean_cont_vis_mat(mean_cont_vis_mat==0) = nan;
                                           
                                           mean_cont_vis_mat = nanmean(mean_cont_vis_mat); % calculating mean for each column
                                           mean_cont_vis_mat = mean_cont_vis_mat(~isnan(mean_cont_vis_mat)); % excluding columns with nan result 
                                           mean_cont_vis_mat = mean(mean_cont_vis_mat);  
                                           
                                           cont_vis_all(:,:,subjind)  = mean_cont_vis_mat;
                                          
% 
%                                            mean_cont_vis = mean(cont_vis);
%                                            mean_cont_vis = mean(mean_cont_vis);
% 
% 
%                                            mean_cont_vis_all(subjind,:) = mean_cont_vis;  




                                       %%  extracting cont and limb connectivity
                                          
                                           mat_index = (1:1:200);  
                                           
                                           cont_limb_index = [cont_index,limb_index];   
                                           cont_limb = Mat(sommot_index, limb_index);

                                           
                                           cont_limb_mat = Mat;
                                           mat_index(cont_limb_index) = []; %löschen der Indices für default

                                           cont_limb_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           cont_limb_mat(:,mat_index) = 0; 
                                           cont_limb_mat(cont_index,cont_index) = 0;
                                           cont_limb_mat(limb_index,limb_index) = 0;                                            

                                           
                                           mean_cont_limb_mat = tril(cont_limb_mat); % for calculating mean only half of the matrix 
                                           mean_cont_limb_mat(mean_cont_limb_mat==0) = nan;
                                           
                                           mean_cont_limb_mat = nanmean(mean_cont_limb_mat); % calculating mean for each column
                                           mean_cont_limb_mat = mean_cont_limb_mat(~isnan(mean_cont_limb_mat)); % excluding columns with nan result 
                                           mean_cont_limb_mat = mean(mean_cont_limb_mat);                                             
                                           
                                           cont_limb_all(:,:,subjind)  = mean_cont_limb_mat;
                                       
% 
%                                            mean_cont_limb = mean(cont_limb);
%                                            mean_cont_limb = mean(mean_cont_limb);
% 
% 
%                                            mean_cont_limb_all(subjind,:) = mean_cont_limb;  



                                       %%  extracting vis and limb connectivity
                                           
                                          
                                           mat_index = (1:1:200); 
                                           
                                           
                                           vis_limb_index = [vis_index,limb_index]; 
                                           vis_limb = Mat(vis_index, limb_index);
                                                                                      
                                           
                                           vis_limb_mat = Mat;
                                           mat_index(vis_limb_index) = []; %löschen der Indices für default

                                           vis_limb_mat(mat_index,:) = 0; % alle anderen Indices in der Matrix auf 0 setzen
                                           vis_limb_mat(:,mat_index) = 0;  
                                           vis_limb_mat(vis_index,vis_index) = 0;
                                           vis_limb_mat(limb_index,limb_index) = 0;  
                                           
                                           mean_vis_limb_mat = tril(vis_limb_mat); % for calculating mean only half of the matrix 
                                           mean_vis_limb_mat(mean_vis_limb_mat==0) = nan;
                                           
                                           mean_vis_limb_mat = nanmean(mean_vis_limb_mat); % calculating mean for each column
                                           mean_vis_limb_mat = mean_vis_limb_mat(~isnan(mean_vis_limb_mat)); % excluding columns with nan result 
                                           mean_vis_limb_mat = mean(mean_vis_limb_mat);                                             
                                           
                                           vis_limb_all(:,:,subjind)  = mean_vis_limb_mat;
                                         

%                                            mean_vis_limb = mean(vis_limb);
%                                            mean_vis_limb = mean(mean_vis_limb);
% 
% 
%                                            mean_vis_limb_all(subjind,:) = mean_vis_limb;  

%% Mean between connectivity of all single networks                                     
                                           

                                          default_between = [mean_default_dorsal,mean_default_salven,mean_default_sommot  ...
                                                             mean_default_cont,mean_default_vis,mean_default_limb]
                                          
                                          mean_default_between = mean(default_between)                                          
                                          mean_default_between_all(subjind,:) = mean_default_between; 
                                                         
                                          dorsal_between = [mean_dorsal_default,mean_dorsal_salven,mean_dorsal_sommot  ...
                                                             mean_dorsal_cont,mean_dorsal_vis,mean_dorsal_limb]
                                                         
                                          mean_dorsal_between = mean(dorsal_between)                                          
                                          mean_dorsal_between_all(subjind,:) = mean_dorsal_between; 
                                                         
                                                         
                                          salven_between = [mean_salven_default,mean_salven_dorsal,mean_salven_sommot  ...
                                                             mean_salven_cont,mean_salven_vis,mean_salven_limb]

                                          mean_salven_between = mean(salven_between)                                          
                                          mean_salven_between_all(subjind,:) = mean_salven_between;                                                          
                                                         
                                          sommot_between = [mean_sommot_default,mean_sommot_dorsal,mean_sommot_salven  ...
                                                             mean_sommot_cont,mean_sommot_vis,mean_sommot_limb] 
                                                         
                                          mean_sommot_between = mean(sommot_between)                                          
                                          mean_sommot_between_all(subjind,:) = mean_sommot_between;                                                            
                                                         
                                          cont_between = [mean_cont_default,mean_cont_dorsal,mean_cont_salven  ...
                                                             mean_cont_sommot,mean_cont_vis,mean_cont_limb] 
                                                         
                                          mean_cont_between = mean(cont_between)                                          
                                          mean_cont_between_all(subjind,:) = mean_cont_between;                                                              
                                                         
                                          vis_between = [mean_vis_default,mean_vis_dorsal,mean_vis_salven  ...
                                                             mean_vis_sommot,mean_vis_cont,mean_vis_limb]                                                         
                                                         
                                          mean_vis_between = mean(vis_between)                                          
                                          mean_vis_between_all(subjind,:) = mean_vis_between; 
                                          
                                          limb_between = [mean_limb_default,mean_limb_dorsal,mean_limb_salven  ...
                                                             mean_limb_sommot,mean_limb_cont,mean_limb_vis]  
                                                         
                                          mean_limb_between = mean(limb_between)                                          
                                          mean_limb_between_all(subjind,:) = mean_limb_between;                                                          
%% mean between connecitivity for all networks

% for all networks

                                           global_between = [default_between,dorsal_between,salven_between  ...
                                                      sommot_between,cont_between,vis_between,limb_between]
                                                  
                                           mean_global_between =  mean(global_between)          
                                           mean_global_between_all(subjind,:) = mean_global_between; 
                                           
%% Segregation coefficient 




%% Segregation Coefficient
                        
                    seg = mean_within_all - mean_between_all;
                    seg = seg ./ mean_within_all;
                    
% Segregation association

                    seg_asso = mean_within_asso_all - mean_between_asso_all
                    seg_asso = seg_asso ./ mean_within_asso_all
                    
% Segregation sensory

                    seg_sensor = mean_within_sensor_all - mean_between_sensor_all
                    seg_sensor = seg_sensor ./mean_within_sensor_all
                                           between_asso = [mean_default_dorsal,mean_default_salven  ...
                                                      mean_default_cont,mean_default_limb ...
                                                      mean_dorsal_salven,mean_dorsal_cont, ...
                                                      mean_dorsal_limb,mean_salven_cont, mean_salven_limb ...                                                      
                                                      mean_cont_limb]
                                                  
                                        mean_between_asso = mean(between_asso)
                                        mean_between_asso_all(subjind,:) = mean_between_asso; 

                                        
                                        
% Mean sensor

                                           between_sensor = [mean_default_sommot  ...
                                                      mean_default_vis ...
                                                      mean_dorsal_sommot, mean_dorsal_vis ...
                                                      mean_salven_sommot,mean_salven_vis ...
                                                      mean_sommot_cont, mean_sommot_vis, mean_cont_vis ...
                                                      mean_vis_limb]
                                                  
                                        mean_between_sensor = mean(between_sensor)
                                        mean_between_sensor_all(subjind,:) = mean_between_sensor; 
                                        
                                        
                          end
  
  
                   save([target_dir '/mean_default_between'],'mean_default_between_all');
                   save([target_dir '/mean_dorsal_between'],'mean_dorsal_between_all');
                   save([target_dir '/mean_salven_between'],'mean_salven_between_all');
                   save([target_dir '/mean_sommot_between'],'mean_sommot_between_all');
                   save([target_dir '/mean_cont_between'],'mean_cont_between_all');
                   
                   save([target_dir '/mean_vis_between'],'mean_vis_between_all');
                   save([target_dir '/mean_limb_between'],'mean_limb_between_all');
                   
                   
                   save([target_dir '/mean_between_all'],'mean_between_all');
                   save([target_dir '/mean_between_asso_all'],'mean_between_asso_all');
                   save([target_dir '/mean_between_sensor_all'],'mean_between_sensor_all');
                   
                   save([target_dir '/mean_default_dorsal_all'],'mean_default_dorsal_all');
                   save([target_dir '/mean_default_salven_all'],'mean_default_salven_all');
                   save([target_dir '/mean_default_sommot_all'],'mean_default_sommot_all');
                   save([target_dir '/mean_default_cont_all'],'mean_default_cont_all');
                   save([target_dir '/mean_default_vis_all'],'mean_default_vis_all');
                   save([target_dir '/mean_default_limb_all'],'mean_default_limb_all');
                   
                   save([target_dir '/dorsal_salven_all'],'dorsal_salven_all');
                   save([target_dir '/dorsal_sommot_all'],'dorsal_sommot_all');
                   save([target_dir '/dorsal_cont_all'],'dorsal_cont_all');
                   save([target_dir '/dorsal_vis_all'],'dorsal_vis_all');
                   save([target_dir '/dorsal_limb_all'],'dorsal_limb_all');
                   
                   save([target_dir '/mean_dorsal_salven_all'],'mean_dorsal_salven_all');
                   save([target_dir '/mean_dorsal_sommot_all'],'mean_dorsal_sommot_all');
                   save([target_dir '/mean_dorsal_cont_all'],'mean_dorsal_cont_all');
                   save([target_dir '/mean_dorsal_vis_all'],'mean_dorsal_vis_all');
                   save([target_dir '/mean_dorsal_limb_all'],'mean_dorsal_limb_all');
                   
                   save([target_dir '/salven_sommot_all'],'salven_sommot_all');
                   save([target_dir '/salven_cont_all'],'salven_cont_all');
                   save([target_dir '/salven_vis_all'],'salven_vis_all');
                   save([target_dir '/salven_limb_all'],'salven_limb_all');
                   
                   save([target_dir '/mean_salven_sommot_all'],'mean_salven_sommot_all');
                   save([target_dir '/mean_salven_cont_all'],'mean_salven_cont_all');
                   save([target_dir '/mean_salven_vis_all'],'mean_salven_vis_all');
                   save([target_dir '/mean_salven_limb_all'],'mean_salven_limb_all');
                   
                   save([target_dir '/sommot_cont_all'],'sommot_cont_all');
                   save([target_dir '/sommot_vis_all'],'sommot_vis_all');
                   save([target_dir '/sommot_limb_all'],'sommot_limb_all');
                   
                   save([target_dir '/mean_sommot_cont_all'],'mean_sommot_cont_all');
                   save([target_dir '/mean_sommot_vis_all'],'mean_sommot_vis_all');
                   save([target_dir '/mean_sommot_limb_all'],'mean_sommot_limb_all');
                   
                   save([target_dir '/cont_vis_all'],'cont_vis_all');
                   save([target_dir '/cont_limb_all'],'cont_limb_all');
                   
                   save([target_dir '/mean_cont_vis_all'],'mean_cont_vis_all');
                   save([target_dir '/mean_cont_limb_all'],'mean_cont_limb_all');
                   
                   save([target_dir '/vis_limb_all'],'vis_limb_all');
                   save([target_dir '/mean_vis_limb_all'],'mean_vis_limb_all');
                   
                                   
              
      end 