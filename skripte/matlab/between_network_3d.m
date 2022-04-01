%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];
conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];


% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];

main_txt_path = [hchs_dir '/sozio_data'];

 absolute_values = 1
 
 all_thresh = [0 0.1 0.3 0.5 0.7 ];0.9
 num_thresh = length(all_thresh);

BCT_path = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis/BCT/2019_03_03_BCT';
addpath(BCT_path);


% default_dorsal_mean = zeros(46,26,987);
% default_salven_mean = zeros(:,:,987);
% default_sommot_mean = zeros(:,:,987);
% default_cont_mean   = zeros(:,:,987);
% default_vis_mean    = zeros(:,:,987);
 broken_subjects = 'sub-2016203f.mat'








%% excluding for age array
        tbl = readtable([main_txt_path '/WML.dat'])
        id  = tbl.ID    
        id(115) = [] 
         id(925) = [] % nur bei 36p
        
         tbl2 = readtable([main_txt_path '/demographics.csv'],'Delimiter','space')
         age_sub = tbl2.sub;
         str2 = 'sub-';
         for subjind = 1:length(age_sub)
             csubj = age_sub{subjind};
             nsubj=strcat(str2,csubj);
             nsubj=strsplit(nsubj);
             age_sub(subjind,:)=nsubj;            
         end
           ex2 = setdiff(id,age_sub)  
           [~,idx] = ismember(id,ex2)
           [idx2] = find(idx)

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
all_subjects(idx2) = [];

conn = nan(200,200,length(all_subjects));
%% Loop through Subjects

          for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              
%                        if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/3d_aroma_abs' num2str(thresh)];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/3d_aroma' num2str(thresh)];
%                              
%                       end


% 
%                        if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/3d_aroma_pval_abs' num2str(thresh)];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/3d_aroma_pval' num2str(thresh)];
%                              
%                        end
                      
                       
                       
                       
                      if absolute_values

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/3d_aroma_gsr_abs' num2str(thresh)];
                      else

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/3d_aroma_gsr' num2str(thresh)];
                             
                      end
%               
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/3d_36_abs' num2str(thresh)];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/3d_36' num2str(thresh)];
%                              
%                       end
                      
                        mkdir(target_dir)
                        
                             for subjind = 1:length(all_subjects)
                    
                                  subject = all_subjects{subjind};
                                  load([conn_dir '/' subject]);
                                  if absolute_values
                                     Mat = abs(Mat);
                                  end  
                                  mat_thr = threshold_proportional(Mat, (1-thresh));
                
                    m = mean(mat_thr);
                    conn(:,:,subjind) = mat_thr;
                    mean_conn = mean(conn,3) ;
                
                
                
                
                
                     
                 %%  extracting default and dorsal connectivity
                 
                   default_lh = (74:100); % 
                   default_rh = (182:200); 
                   %
                   default_index = [default_lh,default_rh]; 
                   
                   dorsal_lh = (31:43); % 
                   dorsal_rh = (135:147);   
                   
                   dorsal_index = [ dorsal_lh, dorsal_rh]; %
                  
                   
                   default_dorsal = mean_conn(default_index, dorsal_index);
                   
               %% 3d Matrix Default 
                   
                   default_index = [default_lh,default_rh];
              
                  

                   
                %%  extracting default and salven connectivity
                 
                   default_lh = (74:100); % 
                   default_rh = (182:200); 
                   %
                   default_index = [default_lh,default_rh]; 
                   
                   salven_lh = (44:54); % 
                   salven_rh = (148:158);  
                   
                   salven_index = [salven_lh,salven_rh]; %
                   
                  
                   
                   default_salven = mean_conn(default_index, salven_index);
                                
                  

                   
                %%  extracting default and sommot connectivity
                 
                   default_lh = (74:100); % 
                   default_rh = (182:200); 
                   %
                   default_index = [default_lh,default_rh]; 
                   
                   sommot_lh = (15:30); % 
                   sommot_rh = (116:134);  
                   
                   sommot_index = [ sommot_lh, sommot_rh]; %%
                               
                   
                   default_sommot = mean_conn(default_index, sommot_index);
                                  
                                

                   
               %%  extracting default and cont connectivity
                 
                   default_lh = (74:100); % 
                   default_rh = (182:200); 
                   %
                   default_index = [default_lh,default_rh]; 
                   
                   cont_lh = (61:73); % 
                   cont_rh = (165:181); 
                   
                   cont_index = [cont_lh,cont_rh]; %%
                   
                   
                   default_cont = mean_conn(default_index, cont_index);
                  
              
                  

                   
               %%  extracting default and vis connectivity
                 
                   default_lh = (74:100); % 
                   default_rh = (182:200); 
                   %
                   default_index = [default_lh,default_rh]; 
                   
                   vis_lh = (1:14); % 
                   vis_rh = (101:115); 
                   
                   vis_index = [vis_lh,vis_rh];; %%
                   
                   default_vis = mean_conn(default_index, vis_index);
                   

               %%  extracting default and vis connectivity
                 
                   default_lh = (74:100); % 
                   default_rh = (182:200); 
                   %
                   default_index = [default_lh,default_rh]; 
                   
                   limb_lh = (55:68); % 
                   limb_rh = (159:164); 
                   
                   limb_index = [limb_lh,limb_rh]; %%
                   
                   default_limb_mean = nan(46,20,987);
                   
                   default_limb = mean_conn(default_index, limb_index);   
                   
                   save([target_dir '/mean_conn_3d'],'mean_conn');
                   save([target_dir '/default_dorsal_3d'],'default_dorsal');
                   save([target_dir '/default_salven_3d'],'default_salven');
                   save([target_dir '/default_sommot_3d'],'default_sommot');
                   save([target_dir '/default_cont_3d'],'default_cont');
                   save([target_dir '/default_vis_3d'],'default_vis');
                   save([target_dir '/default_limb_3d'],'default_limb');
              

                             end
          end
  

              
   