%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
conn_dir = [hchs_dir, '/structural/conn_mat/matrix']; 
mu_dir = [hchs_dir, '/structural/conn_mat/mu']; 




main_txt_path = [hchs_dir '/sozio_data'];
mu_calc = 0;
%mean_default = []



BCT_path = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis/BCT/2019_03_03_BCT';
addpath(BCT_path);
 

% all_thresh = [ 0.5  ];
% num_thresh = length(all_thresh);



 cd(conn_dir) ;      
 broken_subjects = 'sub-2016203f.mat';
 


         
%% Sorting Subjects
       
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
            all_subjects     = cellstr(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i}; 
            if ~isempty(regexp(broken_subjects, csubj, 'once'));
                all_subjects{i} = [];
            elseif isempty(regexp(csubj, 'sub', 'once')); 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects = sort(all_subjects);


 %% Vorbereiten von Matrizen Datensatz

         id_m = cell(length(all_subjects),1);
         for subjind = 1:length(all_subjects);
             csubj = all_subjects{subjind};
             nsubj=csubj(1:12);   %extract subject name
             nsubj=strsplit(nsubj);% convert into cell
             id_m(subjind,:) = nsubj;       
         end
         
             tbl = readtable([main_txt_path '/data.xlsx']) ; 

             id = tbl.DisclosureID;
          
         
         % Angleichen der Nomenklatur
             str2 = 'sub-';
         for subjind = 1:length(id)
             csubj = id{subjind};
             nsubj=strcat(str2,csubj); % attach "sub"
             nsubj=strsplit(nsubj); %convert into cell
             id(subjind,:)=nsubj;            
         end

            all_mu_str = ls(mu_dir);
            all_mu    = cellstr(all_mu_str);
            
            for i = 1:length(all_mu);
                csubj = all_mu{i}; 

            if isempty(regexp(csubj, 'sub', 'once')); 
                all_mu{i} = [];
            end
            end 

            all_mu = all_mu(~cellfun('isempty', all_mu));
            all_mu = sort(all_mu);
             
             id_mu = cell(length(all_mu),1);
         for subjind = 1:length(all_mu);

             csubj = all_mu{subjind};
             nsubj=csubj(1:12);   %extract subject name
             nsubj=strsplit(nsubj);% convert into cell
             id_mu(subjind,:) = nsubj;       
         end
%% Angleichen von Matrizen an Age Datensatz         
         
         % Index der Subjects die in der Demographie Tabelle aber nicht bei
         % den Matrizen enthalten sind
                       ex0 = setdiff(id,id_mu)
                       [~,idx0] = ismember(id,ex0);
                       [idx00] = find(idx0);
                       id(idx00, :) = []; 
                       tbl(idx00, :) = [];

           
           ex1 = setdiff(id,id_m);  % returns names in id that are not in id_m
           [~,idx] = ismember(id,ex1); % one's on these rows which resemble index of ex1
           [idx1] = find(idx); % returns index numbers of ones 
         
           id(idx1, :) = []; % delete subjects of id which are not in id_m
     
           
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


              
                                            
                      
                      if mu_calc

                         target_dir_with = [hchs_dir, '/structural/conn_mat/with_mu'];
                      else

                         target_dir_with = [hchs_dir, '/structural/conn_mat/without_mu'];
                             
                      end
                      
                      
                       
              for subjind = 1:length(all_subjects)

                            subject = all_subjects{subjind};
                            sub = subject(1:end-4);
                            sub = append(sub,'_mu.txt');
                            Mat = csvread([conn_dir '/' subject]);


                                  if mu_calc
                                     mu = importdata([mu_dir '/' sub]);
                                     Mat = Mat * mu;
                                  else                                    
                                      
                                  end  
                                  
                                %% CONNECTIVITY WITHIN NETWORKS     
                                
                                %% Global Connectivity
                                  
                            %      mean_conn = mean(mean(Mat));
                                  
                                  
                                   mean_conn = tril(Mat); % for calculating mean only half of the matrix 
                                   mean_conn(mean_conn==0) = nan; % for calculating mean changing zeros to nan

                                  % s=mean(half_default(logical(triu(ones(size(half_default))))))

                                   mean_conn = mean(mean_conn,'omitnan'); % calculating mean for each column
                                   mean_conn = mean_conn(~isnan(mean_conn)); % excluding columns with nan result 
                                   mean_conn = mean(mean_conn); % calculating mean of the columns 
                                                                                          
            
                                  mean_str_conn_all(subjind,:) = mean_conn;
                                  
                                  conn_all(:,:,subjind)  = Mat;
                                  conn = Mat;
                                  

% 
%                                    mean_conn_sign = mean(conn_sign);
%                                    mean_conn_sign_all(subjind,:) = mean_conn_sign;


                             %%  extracting default net and mean connectivity
                              
                           
                             
                               default_lh = (74:100);  
                               default_rh = (182:200); 
                               %
                               default_index = [default_lh,default_rh]; % Index right and left
                               default = Mat(default_index, default_index);

                               
                               
 
            
%                                mean_default_sign = mean(default_sign);
%                                mean_default_sign_all(subjind,:) = mean_default_sign;
                               
       
                               default_all(:,:,subjind)  = default; % 3D matrix of all subjects
                               
                               mean_default = tril(default); % for calculating mean only half of the matrix 
                               mean_default(mean_default==0) = nan; % for calculating mean changing zeros to nan

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_default = nanmean(mean_default); % calculating mean for each column
                               mean_default = mean_default(~isnan(mean_default)); % excluding columns with nan result 
                               mean_default = mean(mean_default); % calculating mean of the columns 
                                                                                          
                               mean_str_default_all(subjind,:) = mean_default; % mean values of all subjects
                               
                               [~, mod] = modularity_und(default);
                               modul_default(subjind,:) = mod;


                              %% extracting Dorsal net and mean connectivity 


                               dorsal_lh = (31:43); % 
                               dorsal_rh = (135:147); 
                               %
                               dorsal_index = [ dorsal_lh, dorsal_rh]; %
                               dorsal = Mat(dorsal_index, dorsal_index);
                               

%                                mean_dorsal_sign = mean(dorsal_sign);
%                                mean_dorsal_sign_all(subjind,:) = mean_dorsal_sign;
                      
                               dorsal_all(:,:,subjind)  = dorsal;
                               
                               mean_dorsal = tril(dorsal);
                               mean_dorsal(mean_dorsal==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_dorsal = nanmean(mean_dorsal);
                               mean_dorsal = mean_dorsal(~isnan(mean_dorsal));
                               mean_dorsal = mean(mean_dorsal);
                               mean_str_dorsal_all(subjind,:) = mean_dorsal;
                               
                               
                               [~, mod] = modularity_und(dorsal);
                               modul_dorsal(subjind,:) = mod;

                             %%  extracting SalVen net and mean connectivity     


                               salven_lh = (44:54); % 
                               salven_rh = (148:158); 
                               %
                               salven_index = [salven_lh,salven_rh]; %
                               salven = Mat(salven_index, salven_index);
                               

                               

                                
%                                mean_salven_sign = mean(salven_sign);
%                                mean_salven_sign_all(subjind,:) = mean_salven_sign;                                                                                             
                               
                               salven_all(:,:,subjind)  = salven;
                               
                               mean_salven = tril(salven);
                               mean_salven(mean_salven==0) = nan;

                               mean_salven = nanmean(mean_salven);
                               mean_salven = mean_salven(~isnan(mean_salven));
                               mean_salven = mean(mean_salven);
                               mean_str_salven_all(subjind,:) = mean_salven;


                               [~, mod] = modularity_und(salven);
                               modul_salven(subjind,:) = mod;


                            %%  extracting SomMot net and mean connectivity     


                               sommot_lh = (15:30); % 
                               sommot_rh = (116:134); 
                               %
                               sommot_index = [ sommot_lh, sommot_rh]; %
                               sommot = Mat(sommot_index, sommot_index);
                               


                               

                                
%                                mean_sommot_sign = mean(sommot_sign);
%                                mean_sommot_sign_all(subjind,:) = mean_sommot_sign;                                
                               
                               
                               
                             
                               
                               
                               
                               sommot_all(:,:,subjind)  = sommot;
                               
                               mean_sommot = tril(sommot);
                               mean_sommot(mean_sommot==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_sommot = nanmean(mean_sommot);
                               mean_sommot = mean_sommot(~isnan(mean_sommot));
                               mean_sommot = mean(mean_sommot);
                               mean_str_sommon_all(subjind,:) = mean_sommot;
                               
                               
                               [~, mod] = modularity_und(sommot);
                               modul_sommot(subjind,:) = mod;


                            %%  extracting Cont net and mean connectivity     


                               cont_lh = (61:73); % 
                               cont_rh = (165:181); 
                               %
                               cont_index = [cont_lh,cont_rh]; %
                               cont = Mat(cont_index, cont_index);
                               cont_all(:,:,subjind)  = cont;
                               

%                                 mean_cont_sign = mean(cont_sign);
%                                 mean_cont_sign_all(subjind,:) = mean_cont_sign;   
                               
                               mean_cont = tril(cont);
                               mean_cont(mean_cont==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_cont = nanmean(mean_cont);
                               mean_cont = mean_cont(~isnan(mean_sommot));
                               mean_cont = mean(mean_cont);
                               mean_str_cont_all(subjind,:) = mean_cont;

                               [~, mod] = modularity_und(cont);
                               modul_cont(subjind,:) = mod;



                           %%  extracting Vis net and mean connectivity     


                               vis_lh = (1:14); % 
                               vis_rh = (101:115); 
                               %
                               vis_index = [vis_lh,vis_rh]; %
                               vis = Mat(vis_index, vis_index);

                               




%                                mean_vis_sign = mean(vis_sign);
%                                mean_vis_sign_all(subjind,:) = mean_vis_sign;
                               
                               vis_all(:,:,subjind)  = vis;
                               
                               mean_vis = tril(vis);
                               mean_vis(mean_vis==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_vis = nanmean(mean_vis);
                               mean_vis = mean_vis(~isnan(mean_vis));
                               mean_vis = mean(mean_vis);
                               mean_str_vis_all(subjind,:) = mean_vis;
                               
                               
                               

                               [~, mod] = modularity_und(vis);
                               modul_vis(subjind,:) = mod;

                          %%  extracting Limb net and mean connectivity     


                               limb_lh = (55:60); % 
                               limb_rh = (159:164); 
                               %
                               limb_index = [limb_lh,limb_rh]; %
                               limb = Mat(limb_index, limb_index);
                               limb_all(:,:,subjind)  = limb;
                               
                               mean_limb = tril(limb);
                               mean_limb(mean_limb==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_limb = nanmean(mean_limb);
                               mean_limb = mean_limb(~isnan(mean_limb));
                               mean_limb = mean(mean_limb);
                               mean_str_limb_all(subjind,:) = mean_limb;         
                               
                               [~, mod] = modularity_und(limb);
                               modul_limb(subjind,:) = mod;
%% Mean within connectivity                               
                               within = [mean_default,mean_dorsal,mean_salven, mean_sommot,mean_cont,mean_vis,mean_limb];
                               mean_within = mean(within);
                               mean_within_all(subjind,:) = mean_within;   
                               
                               

                                           
%% mean within connecitivity for all networks

                                           global_within = [mean_default,mean_dorsal,mean_salven  ...
                                                      mean_sommot,mean_cont,mean_vis,mean_limb];
                                                  
                                           mean_global_within =  mean(global_within);          
                                           mean_str_global_within_all(subjind,:) = mean_global_within; 


                                        
              end
  
                    mkdir(target_dir_with)
                    % Saving mean within connetivity networks                   
                    save([target_dir_with '/mean_str_default'],'mean_str_default_all');
                    save([target_dir_with '/mean_str_dorsal'],'mean_str_dorsal_all');
                    save([target_dir_with '/mean_str_salven'],'mean_str_salven_all');
                    save([target_dir_with '/mean_str_sommon'],'mean_str_sommon_all');
                    save([target_dir_with '/mean_str_cont'],'mean_str_cont_all');
                     
                    save([target_dir_with '/mean_str_conn'],'mean_str_conn_all');
                   
                    save([target_dir_with '/mean_str_vis'],'mean_str_vis_all');
                    save([target_dir_with '/mean_str_limb'],'mean_str_limb_all');
                   
                    save([target_dir_with '/mean_str_global_within'],'mean_str_global_within_all');
                    
              

      