
%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';

  main_dir = [hchs_dir,'/structural/conn_mat/conn_matrix']
  struc_dir = [hchs_dir,'/structural/conn_mat/with_mu']

absolute_values = 1;
target_dir = [hchs_dir, '/csv_for_R'];
main_txt_path = [hchs_dir '/sozio_data'];
mu_calc = 0;
all_thresh = [0.5 ];% 0.9 0.7 0 0.1 0.3
num_thresh = length(all_thresh);
mu_dir = [hchs_dir, '/structural/conn_mat/mu']; 
%% Sorting Subjects
       
      cd(main_dir)
        
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
         
         
%%

       age = tbl.age;
       
       


              
                                            
                      
                      if mu_calc

                         target_dir_with = [hchs_dir, '/structural/conn_mat/with_mu'];
                      else

                         target_dir_with = [hchs_dir, '/structural/conn_mat/without_mu'];
                             
                      end
                      
                      cd(target_dir_with)
                      all_val_struc = ls('m*');
                      all_val_struc     = cellstr(all_val_struc)
                      
                      all_val_struc = all_val_struc(~cellfun('isempty', all_val_struc));
                    %    all_val_betw(1) = []
                   %     all_val_betw(1) = []
                      all_val_struc = sort(all_val_struc);
                      
                      for val_b = 1:length(all_val_struc);
                          
                          value_b = all_val_struc{val_b};
                          load([target_dir_with '/' value_b]);
                          %  value_b(idx2) = []
                      end
%% 
                      all_val = table(id,age,mean_str_conn_all,mean_str_default_all,mean_str_dorsal_all,mean_str_salven_all,mean_str_sommon_all ...
                          ,mean_str_cont_all,mean_str_vis_all,mean_str_limb_all)

                      
                      
                        if mu_calc
                            writetable(all_val,[target_dir '/HCHS_conn_mu.csv'])
                            save([target_dir '/all_val_aroma_abs', 'all_val'])
                        else
                            writetable(all_val,[target_dir '/HCHS_conn.csv'])
                            save([target_dir '/all_val_aroma_abs', 'all_val'])
                        end
            
      