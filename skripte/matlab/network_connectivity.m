%% General settings
hchs_dir = '/Users/mschu/Documents/CSI/HCHS/analysis'
conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix']; 





main_txt_path = [hchs_dir '/sozio_data'];
absolute_values = 0;
no_negative = 1;
mean_default = []



BCT_path = 'C:\Users\mschu\Documents\CSI\HCHS\analysis\BCT\2019_03_03_BCT';
addpath(BCT_path);
 

 all_thresh = [ 0  ];
 num_thresh = length(all_thresh);



 cd(conn_dir)       
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

%% Angleichen von Matrizen an Age Datensatz         
         
         % Index der Subjects die in der Demographie Tabelle aber nicht bei
         % den Matrizen enthalten sind
           ex1 = setdiff(id,id_m)  % returns names in id that are not in id_m
           [~,idx] = ismember(id,ex1) % one's on these rows which resemble index of ex1
           [idx1] = find(idx) % returns index numbers of ones 
         
           id(idx1, :) = []; % delete subjects of id which are not in id_m
     
           
          tbl(idx1, :) = []; %löschen der subjects für die keine Tabelleneinträge existieren
          [~,idx] = sortrows(tbl(:,3)); % sortieren der Tabelle nach Subject ID
          tbl = tbl(idx,:);
          id = sort(id) %  sortieren des Subject ID arrays
          
          ex3 = setdiff(id_m,id)  % Subjects die in Matrizen aber nicht in Demographie Tabelle exisiteren  
          [~,idx3] = ismember(id_m,ex3)
          [idx3] = find(idx3)
           
          id_m(idx3) = [] % %löschen der subjects für die keine Matrizen existieren
            
           
          all_subjects(idx3) = [] % löschen der Matrizen  die nicht im Demographie Datensatz sind
 
         

           

         setdiff(id_m,id)
         setdiff(id,id_m)

%% Loop through Subjects

      for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              
                                            
                      
                      if absolute_values

                         target_dir_with = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh)];

                      elseif no_negative 

                          target_dir_with = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_no_neg_' num2str(thresh)];

                      else

                         target_dir_with = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh)];
                             
                      end
                      
                      
                       
              for subjind = 1:length(all_subjects)

                            subject = all_subjects{subjind};
                            load([conn_dir '/' subject]);

                                  if absolute_values
                                     Mat = abs(Mat);
                                     Mat = threshold_proportional(abs(Mat), (1-thresh));

                                  elseif no_negative                                                                     
                                     Mat = max(Mat,0);  
                                     Mat = threshold_proportional(Mat, (1-thresh));
                                  else                                      
                                      negat_val = sign(Mat);
                                      Mat = threshold_proportional(abs(Mat), (1-thresh));
                                      Mat = negat_val.*Mat;
                                  end  

                                  
                                %% CONNECTIVITY WITHIN NETWORKS     
                                
                                %% Global Connectivity
                                  
                                  mean_conn = mean(mean(Mat));
                                  mean_conn_all(subjind,:) = mean_conn;
                                  
                                  conn_all(:,:,subjind)  = Mat;
                                  conn = Mat;
                                  

                                    conn_sign1 = conn   (1,2) ;       
                                    conn_sign2 = conn   (1,3) ;       
                                    conn_sign3 = conn   (2,5);        
                                    conn_sign4 = conn   (3,5) ;       
                                    conn_sign5 = conn   (2,7) ;       
                                    conn_sign6 = conn   (2,9);       
                                    conn_sign7 = conn   (5,9) ;      
                                    conn_sign8 = conn   (6,10) ;      
                                    conn_sign9 = conn   (1,11) ;      
                                    conn_sign10 = conn   (2,11);       
                                    conn_sign11 = conn   (3,11)  ;     
                                    conn_sign12 = conn   (6,12);       
                                    conn_sign13 = conn   (2,13);       
                                    conn_sign14 = conn   (4,13) ;      
                                    conn_sign15 = conn   (1,14) ;      
                                    conn_sign16 = conn   (2,14) ;      
                                    conn_sign17 = conn   (3,14);       
                                    conn_sign18 = conn   (5,14);       
                                    conn_sign19 = conn   (9,14);       
                                    conn_sign20 = conn  (11,14);       
                                    conn_sign21 = conn   (8,16);       
                                    conn_sign22 = conn  (15,16);       
                                    conn_sign23 = conn  (16,17);       
                                    conn_sign24 = conn  (15,18);       
                                    conn_sign25 = conn  (16,18);       
                                    conn_sign26 = conn  (17,18);       
                                    conn_sign27 = conn  (15,19);       
                                    conn_sign28 = conn  (16,19);       
                                    conn_sign29 = conn  (17,19);      
                                    conn_sign30 = conn  (18,19);       
                                    conn_sign31 = conn  (17,20);       
                                    conn_sign32 = conn  (18,21);       
                                    conn_sign33 = conn  (16,22);       
                                    conn_sign34 = conn  (17,22);       
                                    conn_sign35 = conn  (18,22);       
                                    conn_sign36 = conn  (19,22);       
                                    conn_sign37 = conn  (17,23);       
                                    conn_sign38 = conn  (17,24);       
                                    conn_sign39 = conn  (23,24);       
                                    conn_sign40 = conn  (16,25);       
                                    conn_sign41 = conn  (19,25);      
                                    conn_sign42 = conn  (17,26);      
                                    conn_sign43 = conn  (22,26);       
                                    conn_sign44 = conn  (24,26);       
                                    conn_sign45 = conn  (22,27);       
                                    conn_sign46 = conn  (24,27);       
                                    conn_sign47 = conn  (25,27);       
                                    conn_sign48 = conn  (19,28);     
                                    conn_sign49 = conn  (22,28)  ;     
                                    conn_sign50 = conn  (25,28);       
                                    conn_sign51 = conn  (27,28);       
                                    conn_sign52 = conn  (17,29);       
                                    conn_sign53 = conn  (26,29);       
                                    conn_sign54 = conn  (28,29);       
                                    conn_sign55 = conn  (17,30);       
                                    conn_sign56 = conn  (22,30);       
                                    conn_sign57 = conn  (29,30);       
                                    conn_sign58 = conn   (3,31);       
                                    conn_sign59 = conn  (11,31);       
                                    conn_sign60 = conn   (3,33);       
                                    conn_sign61 = conn  (31,33);       
                                    conn_sign62 = conn  (32,33);       
                                    conn_sign63 = conn  (31,36);       
                                    conn_sign64 = conn   (3,38);       
                                    conn_sign65 = conn  (34,38);       
                                    conn_sign66 = conn  (12,39);       
                                    conn_sign67 = conn  (19,40);       
                                    conn_sign68 = conn  (25,40);       
                                    conn_sign69 = conn  (27,40);       
                                    conn_sign70 = conn  (28,40);       
                                    conn_sign71 = conn  (31,41);       
                                    conn_sign72 = conn  (35,41);       
                                    conn_sign73 = conn  (40,41);       
                                    conn_sign74 = conn  (34,43);       
                                    conn_sign75 = conn  (35,43);       
                                    conn_sign76 = conn  (33,44);       
                                    conn_sign77 = conn  (15,45);       
                                    conn_sign78 = conn  (19,45);       
                                    conn_sign79 = conn  (34,45);       
                                    conn_sign80 = conn  (40,45);       
                                    conn_sign81 = conn  (41,45);       
                                    conn_sign82 = conn  (18,47);       
                                    conn_sign83 = conn  (19,47);       
                                    conn_sign84 = conn  (22,47);       
                                    conn_sign85 = conn  (44,47);       
                                    conn_sign86 = conn  (45,47);       
                                    conn_sign87 = conn  (47,48);       
                                    conn_sign88 = conn  (18,49);       
                                    conn_sign89 = conn  (19,49);       
                                    conn_sign90 = conn  (22,49);       
                                    conn_sign91 = conn  (25,49);       
                                    conn_sign92 = conn  (45,49);       
                                    conn_sign93 = conn  (47,49);       
                                    conn_sign94 = conn  (41,50);       
                                    conn_sign95 = conn  (18,52);       
                                    conn_sign96 = conn  (19,52);       
                                    conn_sign97 = conn  (28,52);       
                                    conn_sign98 = conn  (40,52);       
                                    conn_sign99 = conn  (45,52);       
                                    conn_sign100 = conn  (47,52);       
                                    conn_sign101 = conn  (48,52);       
                                    conn_sign102 = conn  (49,52);       
                                    conn_sign103 = conn  (19,53);       
                                    conn_sign104 = conn  (28,53);       
                                    conn_sign105 = conn  (40,53);       
                                    conn_sign106 = conn  (41,53);       
                                    conn_sign107 = conn  (47,53);       
                                    conn_sign108 = conn  (48,53);       
                                    conn_sign109 = conn  (49,53);       
                                    conn_sign110 = conn  (52,53);       
                                    conn_sign111 = conn  (18,54);       
                                    conn_sign112 = conn  (19,54);       
                                    conn_sign113 = conn  (22,54);       
                                    conn_sign114 = conn  (27,54);       
                                    conn_sign115 = conn  (28,54);       
                                    conn_sign116 = conn  (40,54);       
                                    conn_sign117 = conn  (44,54);       
                                    conn_sign118 = conn  (47,54);       
                                    conn_sign119 = conn  (49,54);       
                                    conn_sign120 = conn  (52,54);       
                                    conn_sign121 = conn  (53,54);       
                                    conn_sign122 = conn  (54,62);       
                                    conn_sign123 = conn  (31,63);       
                                    conn_sign124 = conn  (32,63);       
                                    conn_sign125 = conn  (43,63);       
                                    conn_sign126 = conn  (44,63);       
                                    conn_sign127 = conn  (32,69);       
                                    conn_sign128 = conn  (63,69);       
                                    conn_sign129 = conn  (12,71);       
                                    conn_sign130 = conn  (36,71);       
                                    conn_sign131 = conn  (71,72);       
                                    conn_sign132 = conn  (16,77);       
                                    conn_sign133 = conn  (16,80);       
                                    conn_sign134 = conn  (18,80);       
                                    conn_sign135 = conn  (19,82);       
                                    conn_sign136 = conn  (41,82);       
                                    conn_sign137 = conn  (48,82);       
                                    conn_sign138 = conn  (52,82);       
                                    conn_sign139 = conn  (53,82);       
                                    conn_sign140 = conn  (68,83);       
                                    conn_sign141 = conn  (82,84);       
                                    conn_sign142 = conn  (14,86);       
                                    conn_sign143 = conn  (41,86);       
                                    conn_sign144 = conn  (84,86);       
                                    conn_sign145 = conn   (7,88);       
                                    conn_sign146 = conn  (32,88);       
                                    conn_sign147 = conn  (46,88);       
                                    conn_sign148 = conn  (83,88);       
                                    conn_sign149 = conn  (84,88);       
                                    conn_sign150 = conn  (32,89);       
                                    conn_sign151 = conn  (45,89);       
                                    conn_sign152 = conn  (46,89);       
                                    conn_sign153 = conn  (82,89);       
                                    conn_sign154 = conn  (83,89);       
                                    conn_sign155 = conn  (84,89);       
                                    conn_sign156 = conn  (86,89);       
                                    conn_sign157 = conn  (88,89);       
                                    conn_sign158 = conn  (48,90);       
                                    conn_sign159 = conn  (88,90);       
                                    conn_sign160 = conn  (41,91);       
                                    conn_sign161 = conn  (75,91);       
                                    conn_sign162 = conn  (76,91);       
                                    conn_sign163 = conn  (82,91);       
                                    conn_sign164 = conn  (83,91);       
                                    conn_sign165 = conn  (84,91);       
                                    conn_sign166 = conn  (85,91);       
                                    conn_sign167 = conn  (88,91);       
                                    conn_sign168 = conn  (89,91);       
                                    conn_sign169 = conn  (64,94);       
                                    conn_sign170 = conn  (66,94);       
                                    conn_sign171 = conn  (84,94);       
                                    conn_sign172 = conn  (12,96);       
                                    conn_sign173 = conn  (14,97);       
                                    conn_sign174 = conn  (41,97);       
                                    conn_sign175 = conn  (84,97);       
                                    conn_sign176 = conn  (88,97);       
                                    conn_sign177 = conn  (89,97);       
                                    conn_sign178 = conn  (41,98);       
                                    conn_sign179 = conn  (84,98);       
                                    conn_sign180 = conn  (88,98);       
                                    conn_sign181 = conn  (89,98);       
                                    conn_sign182 = conn  (41,99);       
                                    conn_sign183 = conn   (1,101);      
                                    conn_sign184 = conn  (11,101);      
                                    conn_sign185 = conn  (31,101);      
                                    conn_sign186 = conn   (1,102);      
                                    conn_sign187 = conn   (2,102);      
                                    conn_sign188 = conn   (1,103);      
                                    conn_sign189 = conn   (2,103);      
                                    conn_sign190 = conn   (3,103);      
                                    conn_sign191 = conn  (11,103);      
                                    conn_sign192 = conn  (13,103);      
                                    conn_sign193 = conn  (14,103);      
                                    conn_sign194 = conn   (2,104);      
                                    conn_sign195 = conn  (13,104);      
                                    conn_sign196 = conn  (85,104);      
                                    conn_sign197 = conn   (1,105);      
                                    conn_sign198 = conn   (2,105);      
                                    conn_sign199 = conn   (3,105);      
                                    conn_sign200 = conn   (5,105);      
                                    conn_sign201 = conn   (8,105);      
                                    conn_sign202 = conn  (11,105);      
                                    conn_sign203 = conn  (14,105);      
                                    conn_sign204 = conn  (31,105);      
                                    conn_sign205 = conn  (98,105);      
                                    conn_sign206 = conn (103,105);      
                                    conn_sign207 = conn   (7,106);      
                                    conn_sign208 = conn   (9,106);      
                                    conn_sign209 = conn  (13,106);      
                                    conn_sign210 = conn (104,106);      
                                    conn_sign211 = conn  (10,107);      
                                    conn_sign212 = conn  (12,107);      
                                    conn_sign213 = conn   (2,108);      
                                    conn_sign214 = conn   (3,108);      
                                    conn_sign215 = conn   (9,108);      
                                    conn_sign216 = conn  (11,108);      
                                    conn_sign217 = conn  (13,108);      
                                    conn_sign218 = conn  (14,108);      
                                    conn_sign219 = conn (103,108);      
                                    conn_sign220 = conn   (6,109);      
                                    conn_sign221 = conn  (10,109);      
                                    conn_sign222 = conn (104,109);      
                                    conn_sign223 = conn (106,109);      
                                    conn_sign224 = conn   (4,110);      
                                    conn_sign225 = conn   (6,110);      
                                    conn_sign226 = conn  (10,110);      
                                    conn_sign227 = conn  (12,110);      
                                    conn_sign228 = conn  (52,110);      
                                    conn_sign229 = conn (104,110);      
                                    conn_sign230 = conn (107,110);      
                                    conn_sign231 = conn (109,110);      
                                    conn_sign232 = conn   (1,111);      
                                    conn_sign233 = conn   (3,111);      
                                    conn_sign234 = conn  (11,111);      
                                    conn_sign235 = conn  (14,111);      
                                    conn_sign236 = conn (102,111);      
                                    conn_sign237 = conn (103,111);      
                                    conn_sign238 = conn (105,111);      
                                    conn_sign239 = conn   (1,112);      
                                    conn_sign240 = conn   (2,112);      
                                    conn_sign241 = conn   (5,112);      
                                    conn_sign242 = conn (103,112);      
                                    conn_sign243 = conn (106,112);      
                                    conn_sign244 = conn (108,112);      
                                    conn_sign245 = conn  (6,113) ;     
                                    conn_sign246 = conn   (10,113);      
                                    conn_sign247 = conn   (12,113);      
                                    conn_sign248 = conn   (66,113);      
                                    conn_sign249 = conn   (68,113);      
                                    conn_sign250 = conn   (70,113);      
                                    conn_sign251 = conn   (72,113);      
                                    conn_sign252 = conn  (107,113);      
                                    conn_sign253 = conn  (110,113);      
                                    conn_sign254 = conn    (1,114);      
                                    conn_sign255 = conn    (2,114);      
                                    conn_sign256 = conn    (4,114);      
                                    conn_sign257 = conn    (8,114);      
                                    conn_sign258 = conn    (61,114);      
                                    conn_sign259 = conn    (82,114);      
                                    conn_sign260 = conn  (84,114) ;     
                                    conn_sign261 = conn  (85,114) ;     
                                    conn_sign262 = conn  (89,114) ;     
                                    conn_sign263 = conn  (92,114) ;     
                                    conn_sign264 = conn  (93,114) ;     
                                    conn_sign265 = conn (103,114) ;     
                                    conn_sign266 = conn (104,114) ;     
                                    conn_sign267 = conn (106,114) ;     
                                    conn_sign268 = conn (110,114) ;     
                                    conn_sign269 = conn   (3,115) ;     
                                    conn_sign270 = conn  (22,115) ;     
                                    conn_sign271 = conn  (31,115) ;     
                                    conn_sign272 = conn (105,115) ;     
                                    conn_sign273 = conn  (15,116) ;     
                                    conn_sign274 = conn  (16,116) ;     
                                    conn_sign275 = conn  (17,116) ;     
                                    conn_sign276 = conn  (18,116) ;     
                                    conn_sign277 = conn  (19,116) ;     
                                    conn_sign278 = conn  (21,116) ;     
                                    conn_sign279 = conn  (22,116) ;     
                                    conn_sign280 = conn  (33,116) ;     
                                    conn_sign281 = conn  (45,116) ;     
                                    conn_sign282 = conn  (47,116) ;     
                                    conn_sign283 = conn  (49,116) ;     
                                    conn_sign284 = conn (115,116) ;     
                                    conn_sign285 = conn  (15,117) ;     
                                    conn_sign286 = conn  (16,117) ;     
                                    conn_sign287 = conn  (17,117) ;     
                                    conn_sign288 = conn  (19,117) ;     
                                    conn_sign289 = conn  (44,117) ;     
                                    conn_sign290 = conn (116,117) ;     
                                    conn_sign291 = conn  (16,118) ;     
                                    conn_sign292 = conn  (17,118) ;     
                                    conn_sign293 = conn  (18,118) ;     
                                    conn_sign294 = conn  (19,118) ;     
                                    conn_sign295 = conn  (20,118)  ;    
                                    conn_sign296 = conn  (22,118)  ;    
                                    conn_sign297 = conn  (23,118)  ;    
                                    conn_sign298 = conn  (24,118)  ;    
                                    conn_sign299 = conn  (26,118)  ;    
                                    conn_sign300 = conn  (27,118)  ;    
                                    conn_sign301 = conn  (29,118)  ;    
                                    conn_sign302 = conn  (30,118)  ;    
                                    conn_sign303 = conn  (33,118)  ;    
                                    conn_sign304 = conn  (115,118) ;     
                                    conn_sign305 = conn (116,118)  ;    
                                    conn_sign306 = conn  (15,119)   ;   
                                    conn_sign307 = conn  (16,119)   ;   
                                    conn_sign308 = conn  (17,119)   ;   
                                    conn_sign309 = conn  (18,119)   ;   
                                    conn_sign310 = conn  (19,119)   ;   
                                    conn_sign311 = conn  (22,119)   ;   
                                    conn_sign312 = conn  (24,119)   ;   
                                    conn_sign313 = conn  (25,119)   ;   
                                    conn_sign314 = conn  (26,119)   ;   
                                    conn_sign315 = conn  (27,119)   ;   
                                    conn_sign316 = conn  (28,119)   ;   
                                    conn_sign317 = conn  (29,119)   ;   
                                    conn_sign318 = conn  (30,119)   ;   
                                    conn_sign319 = conn  (40,119)   ;   
                                    conn_sign320 = conn  (44,119)   ;   
                                    conn_sign321 = conn  (47,119)   ;   
                                    conn_sign322 = conn (115,119)   ;   
                                    conn_sign323 = conn (116,119)   ;   
                                    conn_sign324 = conn (118,119)   ;   
                                    conn_sign325 = conn  (15,120)   ;   
                                    conn_sign326 = conn  (16,120)   ;   
                                    conn_sign327 = conn  (17,120)   ;   
                                    conn_sign328 = conn  (18,120)   ;   
                                    conn_sign329 = conn  (19,120)   ;   
                                    conn_sign330 = conn  (21,120)   ;   
                                    conn_sign331 = conn  (47,120)   ;   
                                    conn_sign332 = conn  (49,120)   ;   
                                    conn_sign333 = conn  (54,120)   ;   
                                    conn_sign334 = conn (116,120)   ;   
                                    conn_sign335 = conn (119,120)   ;   
                                    conn_sign336 = conn  (15,121)   ;   
                                    conn_sign337 = conn  (16,121)   ;   
                                    conn_sign338 = conn  (17,121)   ;   
                                    conn_sign339 = conn  (18,121)   ;   
                                    conn_sign340 = conn  (19,121)   ;   
                                    conn_sign341 = conn  (22,121)   ;   
                                    conn_sign342 = conn  (23,121)   ;   
                                    conn_sign343 = conn  (24,121)   ;   
                                    conn_sign344 = conn  (26,121)   ;   
                                    conn_sign345 = conn  (27,121)   ;   
                                    conn_sign346 = conn  (28,121)   ;   
                                    conn_sign347 = conn  (47,121)   ;   
                                    conn_sign348 = conn  (49,121)   ;   
                                    conn_sign349 = conn (116,121)   ;  
                                    conn_sign350 = conn (118,121)   ;   
                                    conn_sign351 = conn (119,121)   ;   
                                    conn_sign352 = conn  (24,122)   ;   
                                    conn_sign353 = conn (118,122)   ;   
                                    conn_sign354 = conn   (5,123)   ;   
                                    conn_sign355 = conn  (17,123)   ;   
                                    conn_sign356 = conn  (22,123)   ;   
                                    conn_sign357 = conn  (27,123)   ;   
                                    conn_sign358 = conn  (28,123)   ;   
                                    conn_sign359 = conn  (29,123)   ;   
                                    conn_sign360 = conn  (53,123)   ;   
                                    conn_sign361 = conn  (54,123)   ;   
                                    conn_sign362 = conn (117,123)   ;   
                                    conn_sign363 = conn (119,123)   ;   
                                    conn_sign364 = conn  (23,124)   ;   
                                    conn_sign365 = conn (116,124)   ;   
                                    conn_sign366 = conn (118,124)   ;   
                                    conn_sign367 = conn  (18,125)   ;   
                                    conn_sign368 = conn  (21,125)   ;   
                                    conn_sign369 = conn (114,125)   ;   
                                    conn_sign370 = conn (118,125)   ;   
                                    conn_sign371 = conn (120,125)   ;   
                                    conn_sign372 = conn (121,125)   ;   
                                    conn_sign373 = conn  (17,126)   ;   
                                    conn_sign374 = conn  (19,126)   ;   
                                    conn_sign375 = conn  (22,126)   ;   
                                    conn_sign376 = conn  (27,126)   ;   
                                    conn_sign377 = conn  (28,126)   ;   
                                    conn_sign378 = conn  (49,126)   ;   
                                    conn_sign379 = conn  (54,126)   ;   
                                    conn_sign380 = conn (118,126)   ;   
                                    conn_sign381 = conn (119,126)   ;   
                                    conn_sign382 = conn (121,126)   ;   
                                    conn_sign383 = conn  (17,127)   ;   
                                    conn_sign384 = conn  (24,127)   ;   
                                    conn_sign385 = conn  (26,127)   ;   
                                    conn_sign386 = conn (118,127)   ;   
                                    conn_sign387 = conn (121,127)   ;   
                                    conn_sign388 = conn  (17,128)   ;   
                                    conn_sign389 = conn  (18,128)   ;   
                                    conn_sign390 = conn  (19,128)   ;   
                                    conn_sign391 = conn  (23,128)   ;   
                                    conn_sign392 = conn  (25,128)   ;   
                                    conn_sign393 = conn  (26,128)   ;   
                                    conn_sign394 = conn  (27,128)   ;   
                                    conn_sign395 = conn  (28,128)   ;   
                                    conn_sign396 = conn  (40,128)   ;   
                                    conn_sign397 = conn  (44,128)   ;   
                                    conn_sign398 = conn  (54,128)   ;   
                                    conn_sign399 = conn (118,128)   ;   
                                    conn_sign400 = conn (119,128)   ;   
                                    conn_sign401 = conn (121,128)   ;   
                                    conn_sign402 = conn  (17,129)   ;   
                                    conn_sign403 = conn  (24,129)   ;   
                                    conn_sign404 = conn  (26,129)   ;   
                                    conn_sign405 = conn  (30,129)   ;   
                                    conn_sign406 = conn (118,129)   ;   
                                    conn_sign407 = conn (127,129)   ;   
                                    conn_sign408 = conn  (18,130)   ;   
                                    conn_sign409 = conn  (25,130)   ;   
                                    conn_sign410 = conn  (27,130)   ;   
                                    conn_sign411 = conn  (49,130)   ;   
                                    conn_sign412 = conn (119,130)   ;   
                                    conn_sign413 = conn (123,130)   ;   
                                    conn_sign414 = conn  (19,131)   ;   
                                    conn_sign415 = conn  (22,131)   ;   
                                    conn_sign416 = conn  (25,131)   ;   
                                    conn_sign417 = conn  (27,131)   ;   
                                    conn_sign418 = conn  (28,131)   ;   
                                    conn_sign419 = conn  (40,131)   ;   
                                    conn_sign420 = conn  (52,131)   ;   
                                    conn_sign421 = conn  (53,131)   ;   
                                    conn_sign422 = conn  (54,131)   ;   
                                    conn_sign423 = conn (119,131)   ;   
                                    conn_sign424 = conn (126,131)   ;   
                                    conn_sign425 = conn (128,131)   ;   
                                    conn_sign426 = conn  (15,132)   ;   
                                    conn_sign427 = conn  (17,132)   ;   
                                    conn_sign428 = conn  (22,132)   ;  
                                    conn_sign429 = conn  (27,132)   ;   
                                    conn_sign430 = conn  (29,132)   ;   
                                    conn_sign431 = conn (118,132)   ;   
                                    conn_sign432 = conn  (17,133)   ;   
                                    conn_sign433 = conn  (22,133)   ;   
                                    conn_sign434 = conn  (29,133)   ;   
                                    conn_sign435 = conn  (30,133)   ;   
                                    conn_sign436 = conn (118,133)   ;   
                                    conn_sign437 = conn (119,133)   ;   
                                    conn_sign438 = conn (129,133)   ;   
                                    conn_sign439 = conn (132,133)   ;   
                                    conn_sign440 = conn  (29,134)   ;   
                                    conn_sign441 = conn  (30,134)   ;   
                                    conn_sign442 = conn (118,134)   ;   
                                    conn_sign443 = conn (119,134)   ;   
                                    conn_sign444 = conn (129,134)   ;   
                                    conn_sign445 = conn (132,134)   ;   
                                    conn_sign446 = conn (133,134)   ;   
                                    conn_sign447 = conn   (3,135)   ;   
                                    conn_sign448 = conn  (11,135)   ;   
                                    conn_sign449 = conn  (31,135)   ;   
                                    conn_sign450 = conn  (33,135)   ;   
                                    conn_sign451 = conn  (36,135)   ;   
                                    conn_sign452 = conn  (37,135)   ;   
                                    conn_sign453 = conn  (38,135)   ;   
                                    conn_sign454 = conn  (43,135)   ;   
                                    conn_sign455 = conn  (71,135)   ;   
                                    conn_sign456 = conn (115,135)   ;   
                                    conn_sign457 = conn  (19,137)   ;   
                                    conn_sign458 = conn  (34,137)   ;   
                                    conn_sign459 = conn  (35,137)   ;   
                                    conn_sign460 = conn  (41,137)   ;   
                                    conn_sign461 = conn  (42,137)   ;   
                                    conn_sign462 = conn  (45,137)   ;   
                                    conn_sign463 = conn  (47,137)   ;   
                                    conn_sign464 = conn  (49,137)   ;   
                                    conn_sign465 = conn  (54,137)   ;   
                                    conn_sign466 = conn (124,137)   ;   
                                    conn_sign467 = conn  (34,138)   ;   
                                    conn_sign468 = conn  (35,138)   ;   
                                    conn_sign469 = conn  (45,138)   ;   
                                    conn_sign470 = conn  (49,138)   ;   
                                    conn_sign471 = conn  (63,138)   ;   
                                    conn_sign472 = conn  (88,138)   ;   
                                    conn_sign473 = conn (135,138)   ;   
                                    conn_sign474 = conn (137,138)   ;   
                                    conn_sign475 = conn  (34,139)   ;   
                                    conn_sign476 = conn  (35,139)   ;   
                                    conn_sign477 = conn  (41,139)   ;   
                                    conn_sign478 = conn (124,139)   ;   
                                    conn_sign479 = conn (131,139)   ;   
                                    conn_sign480 = conn (137,139)   ;   
                                    conn_sign481 = conn  (72,140)   ;   
                                    conn_sign482 = conn  (91,140)   ;   
                                    conn_sign483 = conn   (3,141)   ;   
                                    conn_sign484 = conn  (19,141)   ;   
                                    conn_sign485 = conn  (31,141)   ;  
                                    conn_sign486 = conn  (44,141)   ;   
                                    conn_sign487 = conn  (86,141)   ;   
                                    conn_sign488 = conn  (97,141)   ;   
                                    conn_sign489 = conn (101,141)   ;   
                                    conn_sign490 = conn (135,141)   ;   
                                    conn_sign491 = conn   (3,142)   ;   
                                    conn_sign492 = conn  (88,142)   ;   
                                    conn_sign493 = conn (105,142)   ;   
                                    conn_sign494 = conn (135,142)   ;   
                                    conn_sign495 = conn  (40,143)   ;   
                                    conn_sign496 = conn  (52,143)   ;   
                                    conn_sign497 = conn  (82,143)   ;   
                                    conn_sign498 = conn  (19,144)   ;   
                                    conn_sign499 = conn  (22,144)   ;   
                                    conn_sign500 = conn  (25,144)   ;   
                                    conn_sign501 = conn  (27,144)   ;   
                                    conn_sign502 = conn  (28,144)   ;   
                                    conn_sign503 = conn  (40,144)   ;   
                                    conn_sign504 = conn  (41,144)   ;   
                                    conn_sign505 = conn  (45,144)   ;   
                                    conn_sign506 = conn  (49,144)   ;   
                                    conn_sign507 = conn  (52,144)   ;   
                                    conn_sign508 = conn  (53,144)   ;   
                                    conn_sign509 = conn (119,144)   ;   
                                    conn_sign510 = conn (121,144)   ;   
                                    conn_sign511 = conn (123,144)   ;   
                                    conn_sign512 = conn (128,144)   ;   
                                    conn_sign513 = conn (131,144)   ;   
                                    conn_sign514 = conn (137,144)   ;   
                                    conn_sign515 = conn (139,144)   ;   
                                    conn_sign516 = conn (143,144)   ;   
                                    conn_sign517 = conn   (3,145)   ;   
                                    conn_sign518 = conn  (41,145)   ;   
                                    conn_sign519 = conn (137,145)   ;   
                                    conn_sign520 = conn (141,145)   ;   
                                    conn_sign521 = conn  (89,147)   ;   
                                    conn_sign522 = conn (141,147)   ;   
                                    conn_sign523 = conn  (15,150)   ;   
                                    conn_sign524 = conn  (16,150)   ;   
                                    conn_sign525 = conn  (17,150)   ;   
                                    conn_sign526 = conn  (18,150)   ;   
                                    conn_sign527 = conn  (19,150)   ;   
                                    conn_sign528 = conn  (25,150)   ;   
                                    conn_sign529 = conn  (27,150)   ;   
                                    conn_sign530 = conn  (28,150)   ;   
                                    conn_sign531 = conn  (40,150)   ;   
                                    conn_sign532 = conn  (41,150)   ;   
                                    conn_sign533 = conn  (44,150)   ;   
                                    conn_sign534 = conn  (45,150)   ;   
                                    conn_sign535 = conn  (47,150)   ;   
                                    conn_sign536 = conn  (48,150)   ;   
                                    conn_sign537 = conn  (49,150)   ;   
                                    conn_sign538 = conn  (52,150)   ;   
                                    conn_sign539 = conn  (53,150)   ;   
                                    conn_sign540 = conn  (54,150)   ;   
                                    conn_sign541 = conn  (82,150)   ;   
                                    conn_sign542 = conn  (84,150)   ;   
                                    conn_sign543 = conn  (89,150)   ;   
                                    conn_sign544 = conn  (99,150)   ;   
                                    conn_sign545 = conn (116,150)   ;   
                                    conn_sign546 = conn (117,150)   ;   
                                    conn_sign547 = conn (119,150)   ;   
                                    conn_sign548 = conn (121,150)   ;   
                                    conn_sign549 = conn (123,150)   ;   
                                    conn_sign550 = conn (128,150)   ;   
                                    conn_sign551 = conn (130,150)   ;   
                                    conn_sign552 = conn (131,150)   ;   
                                    conn_sign553 = conn (143,150)   ;   
                                    conn_sign554 = conn (144,150)   ;   
                                    conn_sign555 = conn   (5,151)   ;   
                                    conn_sign556 = conn  (42,151)   ;   
                                    conn_sign557 = conn  (15,153)   ;   
                                    conn_sign558 = conn  (16,153)   ;   
                                    conn_sign559 = conn  (18,153)   ;   
                                    conn_sign560 = conn  (19,153)   ;   
                                    conn_sign561 = conn  (22,153)   ;   
                                    conn_sign562 = conn  (44,153)   ;   
                                    conn_sign563 = conn  (45,153)   ;   
                                    conn_sign564 = conn  (46,153)   ;   
                                    conn_sign565 = conn  (47,153)   ;   
                                    conn_sign566 = conn  (49,153)   ;   
                                    conn_sign567 = conn  (50,153)   ;   
                                    conn_sign568 = conn  (52,153)   ;   
                                    conn_sign569 = conn  (54,153)   ;   
                                    conn_sign570 = conn  (86,153)   ;   
                                    conn_sign571 = conn  (89,153)   ;   
                                    conn_sign572 = conn (117,153)   ;   
                                    conn_sign573 = conn (119,153)   ;   
                                    conn_sign574 = conn (120,153)   ;   
                                    conn_sign575 = conn (121,153)   ;   
                                    conn_sign576 = conn (129,153)   ;   
                                    conn_sign577 = conn (131,153)   ;   
                                    conn_sign578 = conn (150,153)   ;   
                                    conn_sign579 = conn  (47,154)   ;   
                                    conn_sign580 = conn  (48,154)   ;   
                                    conn_sign581 = conn  (52,154)   ;    
                                    conn_sign582 = conn  (53,154)   ;   
                                    conn_sign583 = conn  (84,154)   ;   
                                    conn_sign584 = conn  (86,154)   ;   
                                    conn_sign585 = conn  (93,154)   ;   
                                    conn_sign586 = conn (143,154)   ;   
                                    conn_sign587 = conn (150,154)   ;   
                                    conn_sign588 = conn  (15,155)   ;   
                                    conn_sign589 = conn  (18,155)   ;   
                                    conn_sign590 = conn  (19,155)   ;   
                                    conn_sign591 = conn  (41,155)   ;   
                                    conn_sign592 = conn  (47,155)   ;   
                                    conn_sign593 = conn  (48,155)   ;   
                                    conn_sign594 = conn  (49,155)   ;   
                                    conn_sign595 = conn  (52,155)   ;   
                                    conn_sign596 = conn  (53,155)   ;   
                                    conn_sign597 = conn  (54,155)   ;   
                                    conn_sign598 = conn  (82,155)   ;   
                                    conn_sign599 = conn  (93,155)   ;   
                                    conn_sign600 = conn (119,155)   ;   
                                    conn_sign601 = conn (120,155)    ;  
                                    conn_sign602 = conn (125,155)   ;   
                                    conn_sign603 = conn (145,155)   ;   
                                    conn_sign604 = conn (150,155)   ;   
                                    conn_sign605 = conn (153,155)   ;   
                                    conn_sign606 = conn (154,155)   ;   
                                    conn_sign607 = conn  (16,156)   ;   
                                    conn_sign608 = conn  (18,156)   ;   
                                    conn_sign609 = conn  (19,156)   ;  
                                    conn_sign610 = conn  (25,156)   ;   
                                    conn_sign611 = conn  (27,156)   ;   
                                    conn_sign612 = conn  (28,156)   ;   
                                    conn_sign613 = conn  (44,156)   ;   
                                    conn_sign614 = conn  (47,156)   ;   
                                    conn_sign615 = conn  (48,156)   ;   
                                    conn_sign616 = conn  (49,156)   ;   
                                    conn_sign617 = conn  (52,156)   ;   
                                    conn_sign618 = conn  (53,156)   ;   
                                    conn_sign619 = conn  (54,156)   ;   
                                    conn_sign620 = conn  (82,156)   ;   
                                    conn_sign621 = conn  (93,156)   ;   
                                    conn_sign622 = conn (116,156)   ;   
                                    conn_sign623 = conn (119,156)   ;   
                                    conn_sign624 = conn (120,156)   ;   
                                    conn_sign625 = conn (121,156)   ;   
                                    conn_sign626 = conn (131,156)   ;   
                                    conn_sign627 = conn (143,156)   ;   
                                    conn_sign628 = conn (144,156)   ;   
                                    conn_sign629 = conn (150,156)   ;   
                                    conn_sign630 = conn (153,156)   ;   
                                    conn_sign631 = conn (155,156)   ;   
                                    conn_sign632 = conn  (28,157)   ;   
                                    conn_sign633 = conn  (40,157)   ;   
                                    conn_sign634 = conn  (47,157)   ;   
                                    conn_sign635 = conn  (48,157)   ;   
                                    conn_sign636 = conn  (52,157)   ;   
                                    conn_sign637 = conn  (53,157)   ;   
                                    conn_sign638 = conn  (82,157)   ;   
                                    conn_sign639 = conn (131,157)   ;   
                                    conn_sign640 = conn (143,157)   ;   
                                    conn_sign641 = conn (144,157)   ;   
                                    conn_sign642 = conn (150,157)   ;   
                                    conn_sign643 = conn (154,157)   ;   
                                    conn_sign644 = conn (155,157)   ;   
                                    conn_sign645 = conn (156,157)   ;   
                                    conn_sign646 = conn  (19,158)   ;   
                                    conn_sign647 = conn  (41,158)   ;   
                                    conn_sign648 = conn  (48,158)   ;   
                                    conn_sign649 = conn  (49,158)   ;   
                                    conn_sign650 = conn  (52,158)   ;   
                                    conn_sign651 = conn  (82,158)   ;   
                                    conn_sign652 = conn  (86,158)   ;   
                                    conn_sign653 = conn  (94,158)   ;   
                                    conn_sign654 = conn  (97,158)   ;   
                                    conn_sign655 = conn (141,158)   ;   
                                    conn_sign656 = conn (149,158)   ;   
                                    conn_sign657 = conn (150,158)   ;   
                                    conn_sign658 = conn (151,158)   ;   
                                    conn_sign659 = conn (154,158)   ;   
                                    conn_sign660 = conn (155,158)   ;   
                                    conn_sign661 = conn (156,158)   ;   
                                    conn_sign662 = conn  (14,161)   ;   
                                    conn_sign663 = conn  (41,161)   ;   
                                    conn_sign664 = conn (153,161)   ;   
                                    conn_sign665 = conn  (48,165)   ;   
                                    conn_sign666 = conn  (84,165)   ;   
                                    conn_sign667 = conn (154,165)   ;   
                                    conn_sign668 = conn (154,166)   ;   
                                    conn_sign669 = conn  (25,167)   ;   
                                    conn_sign670 = conn  (28,167)   ;   
                                    conn_sign671 = conn  (52,167)   ;   
                                    conn_sign672 = conn  (54,167)   ;   
                                    conn_sign673 = conn (150,167)   ;   
                                    conn_sign674 = conn (156,167)   ;   
                                    conn_sign675 = conn   (4,168)   ;   
                                    conn_sign676 = conn (104,168)   ;   
                                    conn_sign677 = conn (107,168)   ;   
                                    conn_sign678 = conn  (90,169)   ;   
                                    conn_sign679 = conn  (12,170)   ;   
                                    conn_sign680 = conn (107,170)   ;   
                                    conn_sign681 = conn (128,170)   ;   
                                    conn_sign682 = conn (137,171)   ;   
                                    conn_sign683 = conn  (22,173)   ;   
                                    conn_sign684 = conn (167,176)   ;   
                                    conn_sign685 = conn  (12,177)   ;   
                                    conn_sign686 = conn  (71,177)   ;   
                                    conn_sign687 = conn  (72,177)   ;   
                                    conn_sign688 = conn (113,177)   ;   
                                    conn_sign689 = conn  (71,178)   ;   
                                    conn_sign690 = conn  (72,178)   ;   
                                    conn_sign691 = conn (113,178)   ;   
                                    conn_sign692 = conn  (48,180)   ;   
                                    conn_sign693 = conn  (90,180)   ;   
                                    conn_sign694 = conn (154,180)   ;   
                                    conn_sign695 = conn (169,180)   ;   
                                    conn_sign696 = conn  (83,181)   ;   
                                    conn_sign697 = conn (169,181)   ;   
                                    conn_sign698 = conn  (34,183)   ;   
                                    conn_sign699 = conn  (47,183)   ;   
                                    conn_sign700 = conn  (81,183)   ;   
                                    conn_sign701 = conn (137,183)   ;   
                                    conn_sign702 = conn  (19,184)   ;   
                                    conn_sign703 = conn  (41,184)   ;   
                                    conn_sign704 = conn  (47,184)   ;   
                                    conn_sign705 = conn  (54,184)   ;   
                                    conn_sign706 = conn (137,184)   ;   
                                    conn_sign707 = conn (150,184)   ;   
                                    conn_sign708 = conn  (65,185)   ;   
                                    conn_sign709 = conn  (89,185)   ;   
                                    conn_sign710 = conn  (91,185)   ;   
                                    conn_sign711 = conn (183,185)   ;   
                                    conn_sign712 = conn  (41,186)   ;   
                                    conn_sign713 = conn  (47,186)   ;   
                                    conn_sign714 = conn  (48,186)   ;   
                                    conn_sign715 = conn  (53,186)   ;   
                                    conn_sign716 = conn  (74,186)   ;   
                                    conn_sign717 = conn  (75,186)   ;   
                                    conn_sign718 = conn  (76,186)   ;   
                                    conn_sign719 = conn  (82,186)   ;   
                                    conn_sign720 = conn  (84,186)   ;   
                                    conn_sign721 = conn  (86,186)   ;   
                                    conn_sign722 = conn  (89,186)   ;   
                                    conn_sign723 = conn  (91,186)   ;   
                                    conn_sign724 = conn  (97,186)   ;   
                                    conn_sign725 = conn (143,186)   ;   
                                    conn_sign726 = conn (150,186)   ;   
                                    conn_sign727 = conn (153,186)   ;   
                                    conn_sign728 = conn (154,186)   ;   
                                    conn_sign729 = conn (155,186)   ;   
                                    conn_sign730 = conn (157,186)   ;   
                                    conn_sign731 = conn (185,186)   ;   
                                    conn_sign732 = conn  (77,187)   ;   
                                    conn_sign733 = conn  (63,188)   ;   
                                    conn_sign734 = conn  (77,188)   ;   
                                    conn_sign735 = conn  (81,188)   ;   
                                    conn_sign736 = conn (183,188)   ;   
                                    conn_sign737 = conn (187,188)   ;   
                                    conn_sign738 = conn (148,189)   ;   
                                    conn_sign739 = conn (188,189)   ;   
                                    conn_sign740 = conn (181,190)   ;   
                                    conn_sign741 = conn (189,190)   ;   
                                    conn_sign742 = conn  (36,191)   ;   
                                    conn_sign743 = conn  (82,191)   ;   
                                    conn_sign744 = conn  (84,191)   ;   
                                    conn_sign745 = conn  (86,191)   ;   
                                    conn_sign746 = conn  (88,191)   ;   
                                    conn_sign747 = conn  (89,191)   ;   
                                    conn_sign748 = conn  (91,191)   ;   
                                    conn_sign749 = conn  (97,191)   ;   
                                    conn_sign750 = conn (150,191)   ;   
                                    conn_sign751 = conn (154,191)   ;   
                                    conn_sign752 = conn (186,191)   ;   
                                    conn_sign753 = conn  (32,192)   ;   
                                    conn_sign754 = conn  (34,192)   ;   
                                    conn_sign755 = conn  (36,192)   ;   
                                    conn_sign756 = conn  (38,192)   ;   
                                    conn_sign757 = conn  (83,192)   ;   
                                    conn_sign758 = conn  (84,192)   ;   
                                    conn_sign759 = conn  (86,192)   ;   
                                    conn_sign760 = conn  (88,192)   ;   
                                    conn_sign761 = conn  (89,192)   ;   
                                    conn_sign762 = conn  (90,192)   ;   
                                    conn_sign763 = conn  (96,192)   ;   
                                    conn_sign764 = conn  (97,192)   ;   
                                    conn_sign765 = conn  (98,192)   ;   
                                    conn_sign766 = conn (135,192)   ;   
                                    conn_sign767 = conn (141,192)   ;   
                                    conn_sign768 = conn (169,192)   ;   
                                    conn_sign769 = conn (186,192)   ;   
                                    conn_sign770 = conn (191,192)   ;   
                                    conn_sign771 = conn  (88,193)   ;   
                                    conn_sign772 = conn  (97,193)   ;   
                                    conn_sign773 = conn  (14,194)   ;   
                                    conn_sign774 = conn  (41,194)   ;   
                                    conn_sign775 = conn  (45,194)   ;   
                                    conn_sign776 = conn  (47,194)   ;   
                                    conn_sign777 = conn  (82,194)   ;   
                                    conn_sign778 = conn  (83,194)   ;   
                                    conn_sign779 = conn  (84,194)   ;   
                                    conn_sign780 = conn  (88,194)   ;   
                                    conn_sign781 = conn  (89,194)   ;   
                                    conn_sign782 = conn  (91,194)   ;   
                                    conn_sign783 = conn (110,194)   ;   
                                    conn_sign784 = conn (114,194)   ;   
                                    conn_sign785 = conn (150,194)   ;   
                                    conn_sign786 = conn (157,194)   ;   
                                    conn_sign787 = conn (185,194)   ;   
                                    conn_sign788 = conn (186,194)   ;   
                                    conn_sign789 = conn (191,194)   ;   
                                    conn_sign790 = conn (192,194)   ;   
                                    conn_sign791 = conn  (47,195)   ;   
                                    conn_sign792 = conn  (82,195)   ;   
                                    conn_sign793 = conn  (88,195)   ;   
                                    conn_sign794 = conn  (89,195)   ;   
                                    conn_sign795 = conn (150,195)   ;   
                                    conn_sign796 = conn (155,195)   ;   
                                    conn_sign797 = conn (183,195)   ;   
                                    conn_sign798 = conn (186,195)   ;   
                                    conn_sign799 = conn (191,195)   ;   
                                    conn_sign800 = conn (192,195)   ;   
                                    conn_sign801 = conn (194,195)   ;   
                                    conn_sign802 = conn (108,196)   ;   
                                    conn_sign803 = conn (182,196)   ;   
                                    conn_sign804 = conn  (41,197)   ;   
                                    conn_sign805 = conn  (84,197)   ;   
                                    conn_sign806 = conn (150,197)   ;   
                                    conn_sign807 = conn (184,197)   ;   
                                    conn_sign808 = conn  (12,198)   ;   
                                    conn_sign809 = conn (113,198)   ;   
                                    conn_sign810 = conn  (36,199)   ;   
                                    conn_sign811 = conn  (41,199)   ;   
                                    conn_sign812 = conn  (45,199)   ;   
                                    conn_sign813 = conn  (84,199)    ;  
                                    conn_sign814 = conn  (88,199)   ;   
                                    conn_sign815 = conn  (89,199)   ;   
                                    conn_sign816 = conn (141,199)   ;   
                                    conn_sign817 = conn (150,199)   ;  
                                    conn_sign818 = conn (186,199)   ;   
                                    conn_sign819 = conn (191,199)   ;   
                                    conn_sign820 = conn (192,199)   ;   
                                    conn_sign821 = conn (193,199)   ;   
                                    conn_sign822 = conn (195,199)   ;   
                                    conn_sign823 = conn   (3,200)   ;   
                                    conn_sign824 = conn (188,200)   ;   


conn_sign = [conn_sign1,conn_sign2,conn_sign3,conn_sign4,conn_sign5,conn_sign6,conn_sign7,conn_sign8,conn_sign9 ...
             conn_sign10,conn_sign11,conn_sign12,conn_sign13,conn_sign14,conn_sign15,conn_sign16,conn_sign17,conn_sign18,conn_sign19 ...
             conn_sign20,conn_sign21,conn_sign22,conn_sign23,conn_sign24,conn_sign25,conn_sign26,conn_sign27,conn_sign28,conn_sign29 ...
             conn_sign30,conn_sign31,conn_sign32,conn_sign33,conn_sign34,conn_sign35,conn_sign36,conn_sign37,conn_sign38,conn_sign39 ...
             conn_sign40,conn_sign41,conn_sign42,conn_sign43,conn_sign44,conn_sign45,conn_sign46,conn_sign47,conn_sign48,conn_sign49 ...
             conn_sign50,conn_sign51,conn_sign52,conn_sign53,conn_sign54,conn_sign55,conn_sign56,conn_sign57,conn_sign58,conn_sign59 ...
             conn_sign60,conn_sign61,conn_sign62,conn_sign63,conn_sign64,conn_sign65,conn_sign66,conn_sign67,conn_sign68,conn_sign69 ... 
             conn_sign70,conn_sign71,conn_sign72,conn_sign73,conn_sign74,conn_sign75,conn_sign76,conn_sign77,conn_sign78,conn_sign79 ...
             conn_sign80,conn_sign81,conn_sign82,conn_sign83,conn_sign84,conn_sign85,conn_sign86,conn_sign87,conn_sign88,conn_sign89 ...
             conn_sign90,conn_sign91,conn_sign92,conn_sign93,conn_sign94,conn_sign95,conn_sign96,conn_sign97,conn_sign98,conn_sign99 ...
             conn_sign100,conn_sign101,conn_sign102,conn_sign103,conn_sign104,conn_sign105,conn_sign106,conn_sign107,conn_sign108,conn_sign109 ...
             conn_sign110,conn_sign111,conn_sign112,conn_sign113,conn_sign114,conn_sign115,conn_sign116,conn_sign117,conn_sign118,conn_sign119 ...
             conn_sign120,conn_sign121,conn_sign122,conn_sign123,conn_sign124,conn_sign125,conn_sign126,conn_sign127,conn_sign128,conn_sign129 ...
             conn_sign130,conn_sign131,conn_sign132,conn_sign133,conn_sign134,conn_sign135,conn_sign136,conn_sign137,conn_sign138,conn_sign139 ...
             conn_sign140,conn_sign141,conn_sign142,conn_sign143,conn_sign144,conn_sign145,conn_sign146,conn_sign147,conn_sign148,conn_sign149 ...
             conn_sign150,conn_sign151,conn_sign152,conn_sign153,conn_sign154,conn_sign155,conn_sign156,conn_sign157,conn_sign158,conn_sign159 ...
             conn_sign160,conn_sign161,conn_sign162,conn_sign163,conn_sign164,conn_sign165,conn_sign166,conn_sign167,conn_sign168,conn_sign169 ...
             conn_sign170,conn_sign171,conn_sign172,conn_sign173,conn_sign174,conn_sign175,conn_sign176,conn_sign177,conn_sign178,conn_sign179 ...
             conn_sign180,conn_sign181,conn_sign182,conn_sign183,conn_sign184,conn_sign185,conn_sign186,conn_sign187,conn_sign188,conn_sign189 ...
             conn_sign190,conn_sign191,conn_sign192,conn_sign193,conn_sign194,conn_sign195,conn_sign196,conn_sign197,conn_sign198,conn_sign199 ...
             conn_sign200,conn_sign201,conn_sign202,conn_sign203,conn_sign204,conn_sign205,conn_sign206,conn_sign207,conn_sign208,conn_sign209 ...
             conn_sign210,conn_sign211,conn_sign212,conn_sign213,conn_sign214,conn_sign215,conn_sign216,conn_sign217,conn_sign218,conn_sign219 ...
             conn_sign220,conn_sign221,conn_sign222,conn_sign223,conn_sign224,conn_sign225,conn_sign226,conn_sign227,conn_sign228,conn_sign229 ...
             conn_sign230,conn_sign231,conn_sign232,conn_sign233,conn_sign234,conn_sign235,conn_sign236,conn_sign237,conn_sign238,conn_sign239 ...
             conn_sign240,conn_sign241,conn_sign242,conn_sign243,conn_sign244,conn_sign245,conn_sign246,conn_sign247,conn_sign248,conn_sign249 ...
             conn_sign250,conn_sign251,conn_sign252,conn_sign253,conn_sign254,conn_sign255,conn_sign256,conn_sign257,conn_sign258,conn_sign259 ...
             conn_sign260,conn_sign261,conn_sign262,conn_sign263,conn_sign264,conn_sign265,conn_sign266,conn_sign267,conn_sign268,conn_sign269 ...                conn_sign200,conn_sign201,conn_sign202,conn_sign203,conn_sign204,conn_sign205,conn_sign206,conn_sign207,conn_sign208,conn_sign209 ...               conn_sign200,conn_sign201,conn_sign202,conn_sign203,conn_sign204,conn_sign205,conn_sign206,conn_sign207,conn_sign208,conn_sign209 ...
             conn_sign270,conn_sign271,conn_sign272,conn_sign273,conn_sign274,conn_sign275,conn_sign276,conn_sign277,conn_sign278,conn_sign279 ...
             conn_sign280,conn_sign281,conn_sign282,conn_sign283,conn_sign284,conn_sign285,conn_sign286,conn_sign287,conn_sign288,conn_sign289 ...
             conn_sign290,conn_sign291,conn_sign292,conn_sign293,conn_sign294,conn_sign295,conn_sign296,conn_sign297,conn_sign298,conn_sign299 ...
             conn_sign300,conn_sign301,conn_sign302,conn_sign303,conn_sign304,conn_sign305,conn_sign306,conn_sign307,conn_sign308,conn_sign309 ...
             conn_sign310,conn_sign311,conn_sign312,conn_sign313,conn_sign314,conn_sign315,conn_sign316,conn_sign317,conn_sign318,conn_sign319 ...
             conn_sign320,conn_sign321,conn_sign322,conn_sign323,conn_sign324,conn_sign325,conn_sign326,conn_sign327,conn_sign328,conn_sign329 ...
             conn_sign330,conn_sign331,conn_sign332,conn_sign333,conn_sign334,conn_sign335,conn_sign336,conn_sign337,conn_sign338,conn_sign339 ...
             conn_sign340,conn_sign341,conn_sign342,conn_sign343,conn_sign344,conn_sign345,conn_sign346,conn_sign347,conn_sign348,conn_sign349 ...
             conn_sign350,conn_sign351,conn_sign352,conn_sign353,conn_sign354,conn_sign355,conn_sign356,conn_sign357,conn_sign358,conn_sign359 ...
             conn_sign360,conn_sign361,conn_sign362,conn_sign363,conn_sign364,conn_sign365,conn_sign366,conn_sign367,conn_sign368,conn_sign369 ...
             conn_sign370,conn_sign371,conn_sign372,conn_sign373,conn_sign374,conn_sign375,conn_sign376,conn_sign377,conn_sign378,conn_sign379 ...
             conn_sign380,conn_sign381,conn_sign382,conn_sign383,conn_sign384,conn_sign385,conn_sign386,conn_sign387,conn_sign388,conn_sign329 ...
             conn_sign390,conn_sign391,conn_sign392,conn_sign393,conn_sign394,conn_sign395,conn_sign396,conn_sign397,conn_sign398,conn_sign399 ...
             conn_sign400,conn_sign401,conn_sign402,conn_sign403,conn_sign404,conn_sign405,conn_sign406,conn_sign407,conn_sign408,conn_sign409 ...
             conn_sign410,conn_sign411,conn_sign412,conn_sign413,conn_sign414,conn_sign415,conn_sign416,conn_sign417,conn_sign418,conn_sign419 ...
             conn_sign420,conn_sign421,conn_sign422,conn_sign423,conn_sign424,conn_sign425,conn_sign426,conn_sign427,conn_sign428,conn_sign429 ...
             conn_sign430,conn_sign431,conn_sign432,conn_sign433,conn_sign434,conn_sign435,conn_sign436,conn_sign437,conn_sign438,conn_sign439 ...
             conn_sign440,conn_sign441,conn_sign442,conn_sign443,conn_sign444,conn_sign445,conn_sign446,conn_sign447,conn_sign448,conn_sign449 ...
             conn_sign450,conn_sign451,conn_sign452,conn_sign453,conn_sign454,conn_sign455,conn_sign456,conn_sign457,conn_sign458,conn_sign459 ...
             conn_sign460,conn_sign461,conn_sign462,conn_sign463,conn_sign464,conn_sign465,conn_sign466,conn_sign467,conn_sign468,conn_sign469 ...
             conn_sign470,conn_sign471,conn_sign472,conn_sign473,conn_sign474,conn_sign475,conn_sign476,conn_sign477,conn_sign478,conn_sign479 ...
             conn_sign480,conn_sign481,conn_sign482,conn_sign483,conn_sign484,conn_sign485,conn_sign486,conn_sign487,conn_sign488,conn_sign489 ...
             conn_sign490,conn_sign491,conn_sign492,conn_sign493,conn_sign494,conn_sign495,conn_sign496,conn_sign497,conn_sign498,conn_sign499 ...
             conn_sign500,conn_sign501,conn_sign502,conn_sign503,conn_sign504,conn_sign505,conn_sign506,conn_sign507,conn_sign508,conn_sign509 ...
             conn_sign510,conn_sign511,conn_sign512,conn_sign513,conn_sign514,conn_sign515,conn_sign516,conn_sign517,conn_sign518,conn_sign519 ...
             conn_sign520,conn_sign521,conn_sign522,conn_sign523,conn_sign524,conn_sign525,conn_sign526,conn_sign527,conn_sign528,conn_sign529 ...
             conn_sign530,conn_sign531,conn_sign532,conn_sign533,conn_sign534,conn_sign535,conn_sign536,conn_sign537,conn_sign538,conn_sign539 ...
             conn_sign540,conn_sign541,conn_sign542,conn_sign543,conn_sign544,conn_sign545,conn_sign546,conn_sign547,conn_sign548,conn_sign549 ...
             conn_sign550,conn_sign501,conn_sign502,conn_sign503,conn_sign504,conn_sign505,conn_sign506,conn_sign507,conn_sign508,conn_sign509 ...
             conn_sign560,conn_sign561,conn_sign562,conn_sign563,conn_sign564,conn_sign565,conn_sign566,conn_sign567,conn_sign568,conn_sign569 ...
             conn_sign570,conn_sign571,conn_sign572,conn_sign573,conn_sign574,conn_sign575,conn_sign576,conn_sign577,conn_sign578,conn_sign579 ...
             conn_sign580,conn_sign581,conn_sign582,conn_sign583,conn_sign584,conn_sign585,conn_sign586,conn_sign587,conn_sign588,conn_sign589 ...
             conn_sign590,conn_sign591,conn_sign592,conn_sign593,conn_sign594,conn_sign595,conn_sign596,conn_sign597,conn_sign598,conn_sign599 ...
             conn_sign600,conn_sign601,conn_sign602,conn_sign603,conn_sign604,conn_sign605,conn_sign606,conn_sign607,conn_sign608,conn_sign609 ...
             conn_sign610,conn_sign611,conn_sign612,conn_sign613,conn_sign614,conn_sign615,conn_sign616,conn_sign617,conn_sign618,conn_sign619 ...
             conn_sign620,conn_sign621,conn_sign622,conn_sign623,conn_sign624,conn_sign625,conn_sign626,conn_sign627,conn_sign628,conn_sign629 ...
             conn_sign630,conn_sign631,conn_sign632,conn_sign633,conn_sign634,conn_sign635,conn_sign636,conn_sign637,conn_sign638,conn_sign639 ...
             conn_sign640,conn_sign641,conn_sign642,conn_sign643,conn_sign644,conn_sign645,conn_sign646,conn_sign647,conn_sign648,conn_sign649 ...
             conn_sign650,conn_sign651,conn_sign652,conn_sign653,conn_sign654,conn_sign655,conn_sign656,conn_sign657,conn_sign658,conn_sign659 ...
             conn_sign660,conn_sign661,conn_sign662,conn_sign663,conn_sign664,conn_sign665,conn_sign666,conn_sign667,conn_sign668,conn_sign669 ...
             conn_sign670,conn_sign671,conn_sign672,conn_sign673,conn_sign674,conn_sign675,conn_sign676,conn_sign677,conn_sign678,conn_sign679 ...
             conn_sign680,conn_sign681,conn_sign682,conn_sign683,conn_sign684,conn_sign685,conn_sign686,conn_sign687,conn_sign688,conn_sign689 ...
             conn_sign690,conn_sign691,conn_sign692,conn_sign693,conn_sign694,conn_sign695,conn_sign696,conn_sign697,conn_sign698,conn_sign699 ...
             conn_sign700,conn_sign701,conn_sign702,conn_sign703,conn_sign704,conn_sign705,conn_sign706,conn_sign707,conn_sign708,conn_sign709 ...
             conn_sign710,conn_sign711,conn_sign712,conn_sign713,conn_sign714,conn_sign715,conn_sign716,conn_sign717,conn_sign718,conn_sign719 ...
             conn_sign720,conn_sign721,conn_sign722,conn_sign723,conn_sign724,conn_sign725,conn_sign726,conn_sign727,conn_sign728,conn_sign729 ...
             conn_sign730,conn_sign731,conn_sign732,conn_sign733,conn_sign734,conn_sign735,conn_sign736,conn_sign737,conn_sign738,conn_sign739 ...
             conn_sign740,conn_sign741,conn_sign742,conn_sign743,conn_sign744,conn_sign745,conn_sign746,conn_sign747,conn_sign748,conn_sign749 ...
             conn_sign750,conn_sign751,conn_sign752,conn_sign753,conn_sign754,conn_sign755,conn_sign756,conn_sign757,conn_sign758,conn_sign759 ...
             conn_sign760,conn_sign761,conn_sign762,conn_sign763,conn_sign764,conn_sign765,conn_sign766,conn_sign767,conn_sign768,conn_sign769 ...
             conn_sign770,conn_sign771,conn_sign772,conn_sign773,conn_sign774,conn_sign775,conn_sign776,conn_sign777,conn_sign778,conn_sign779 ...
             conn_sign780,conn_sign781,conn_sign782,conn_sign783,conn_sign784,conn_sign785,conn_sign786,conn_sign787,conn_sign788,conn_sign789 ...
             conn_sign790,conn_sign791,conn_sign792,conn_sign793,conn_sign794,conn_sign795,conn_sign796,conn_sign797,conn_sign798,conn_sign799 ...
             conn_sign800,conn_sign801,conn_sign802,conn_sign803,conn_sign804,conn_sign805,conn_sign806,conn_sign807,conn_sign808,conn_sign809 ...
             conn_sign810,conn_sign811,conn_sign812,conn_sign813,conn_sign814,conn_sign815,conn_sign816,conn_sign817,conn_sign818,conn_sign819 ...
             conn_sign820,conn_sign821,conn_sign822,conn_sign823,conn_sign824];

                              

                               mean_conn_sign = mean(conn_sign);
                               mean_conn_sign_all(subjind,:) = mean_conn_sign;


                             %%  extracting default net and mean connectivity
                              
                           
                             
                               default_lh = (74:100);  
                               default_rh = (182:200); 
                               %
                               default_index = [default_lh,default_rh]; % Index right and left
                               default = Mat(default_index, default_index);

                               
                               
                                default_sign1 = default   (9,11)  ;        
                                default_sign2 = default  (11,13)   ;       
                                default_sign3 = default  (10,15)    ;      
                                default_sign4 = default  (11,15)    ;      
                                default_sign5 = default   (9,16)   ;       
                                default_sign6 = default  (10,16)   ;       
                                default_sign7 = default  (11,16)    ;      
                                default_sign8 = default  (13,16)    ;      
                                default_sign9 = default  (15,16)    ;      
                                default_sign10 = default  (15,17)  ;        
                                default_sign11 = default   (2,18)    ;      
                                default_sign12 = default   (3,18)   ;       
                                default_sign13 = default   (9,18)    ;      
                                default_sign14 = default  (10,18)    ;      
                                default_sign15 = default  (11,18)    ;      
                                default_sign16 = default  (12,18)    ;      
                                default_sign17 = default  (15,18)    ;      
                                default_sign18 = default  (16,18)    ;      
                                default_sign19 = default  (11,21)    ;      
                                default_sign20 = default  (11,24)    ;      
                                default_sign21 = default  (15,24)   ;       
                                default_sign22 = default  (16,24)   ;       
                                default_sign23 = default  (11,25)   ;       
                                default_sign24 = default  (15,25)   ;       
                                default_sign25 = default  (16,25)  ;        
                                default_sign26 = default   (8,29)  ;        
                                default_sign27 = default  (16,31)   ;       
                                default_sign28 = default  (18,31)   ;       
                                default_sign29 = default  (29,31)   ;       
                                default_sign30 = default   (1,32)     ;     
                                default_sign31 = default   (2,32)     ;     
                                default_sign32 = default   (3,32)     ;     
                                default_sign33 = default   (9,32)       ;   
                                default_sign34 = default  (11,32)     ;     
                                default_sign35 = default  (13,32)    ;      
                                default_sign36 = default  (16,32)     ;     
                                default_sign37 = default  (18,32)    ;      
                                default_sign38 = default  (24,32)   ;       
                                default_sign39 = default  (31,32)   ;       
                                default_sign40 = default   (4,33)   ;       
                                default_sign41 = default   (4,34)   ;       
                                default_sign42 = default   (8,34)   ;       
                                default_sign43 = default  (29,34)    ;      
                                default_sign44 = default  (33,34)    ;      
                                default_sign45 = default  (34,35)    ;      
                                default_sign46 = default  (35,36)   ;       
                                default_sign47 = default   (9,37)   ;       
                                default_sign48 = default  (11,37)   ;       
                                default_sign49 = default  (13,37)   ;       
                                default_sign50 = default  (15,37)   ;       
                                default_sign51 = default  (16,37)    ;      
                                default_sign52 = default  (18,37)    ;      
                                default_sign53 = default  (24,37)    ;      
                                default_sign54 = default  (32,37)   ;       
                                default_sign55 = default  (10,38)    ;      
                                default_sign56 = default  (11,38)    ;      
                                default_sign57 = default  (13,38)    ;      
                                default_sign58 = default  (15,38)    ;      
                                default_sign59 = default  (16,38)    ;      
                                default_sign60 = default  (17,38)   ;       
                                default_sign61 = default  (23,38)   ;       
                                default_sign62 = default  (24,38)     ;     
                                default_sign63 = default  (25,38)    ;      
                                default_sign64 = default  (32,38)    ;      
                                default_sign65 = default  (37,38)    ;      
                                default_sign66 = default  (15,39)    ;      
                                default_sign67 = default  (24,39)    ;      
                                default_sign68 = default   (9,40)    ;      
                                default_sign69 = default  (10,40)   ;       
                                default_sign70 = default  (11,40)   ;       
                                default_sign71 = default  (15,40)     ;     
                                default_sign72 = default  (16,40)     ;     
                                default_sign73 = default  (18,40)      ;    
                                default_sign74 = default  (31,40)     ;     
                                default_sign75 = default  (32,40)    ;      
                                default_sign76 = default  (37,40)    ;      
                                default_sign77 = default  (38,40)    ;      
                                default_sign78 = default   (9,41)    ;      
                                default_sign79 = default  (15,41)   ;       
                                default_sign80 = default  (16,41)   ;       
                                default_sign81 = default  (29,41)    ;      
                                default_sign82 = default  (32,41)     ;     
                                default_sign83 = default  (37,41)      ;    
                                default_sign84 = default  (38,41)      ;    
                                default_sign85 = default  (40,41)     ;     
                                default_sign86 = default  (11,43)    ;  ;      
                                default_sign87 = default  (30,43)     ;     
                                default_sign88 = default  (11,45)    ;      
                                default_sign89 = default  (15,45)     ;     
                                default_sign90 = default  (16,45)    ;     
                                default_sign91 = default  (32,45)     ;     
                                default_sign92 = default  (37,45)     ;     
                                default_sign93 = default  (38,45)    ;      
                                default_sign94 = default  (39,45)    ;      
                                default_sign95 = default  (41,45)    ;      
                                default_sign96 = default  (34,46)   ;       

default_sign = [default_sign1,default_sign2,default_sign3,default_sign4,default_sign5,default_sign6,default_sign7,default_sign8,default_sign9 ...
                default_sign10,default_sign11,default_sign12,default_sign13,default_sign14,default_sign15,default_sign17,default_sign18 ...
                default_sign19,default_sign12,default_sign21,default_sign22,default_sign23,default_sign24,default_sign25,default_sign26 ...
                default_sign27,default_sign28,default_sign29,default_sign30,default_sign31,default_sign32,default_sign33,default_sign34 ...
                default_sign35,default_sign36,default_sign37,default_sign38,default_sign39,default_sign40,default_sign41,default_sign42 ...
                default_sign43,default_sign44,default_sign45,default_sign46,default_sign47,default_sign48,default_sign49,default_sign50 ...
                default_sign51,default_sign52,default_sign53,default_sign54,default_sign55,default_sign56,default_sign57,default_sign58];
            
                               mean_default_sign = mean(default_sign);
                               mean_default_sign_all(subjind,:) = mean_default_sign;
                               
       
                               default_all(:,:,subjind)  = default; % 3D matrix of all subjects
                               
                               mean_default = tril(default); % for calculating mean only half of the matrix 
                               mean_default(mean_default==0) = nan; % for calculating mean changing zeros to nan

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_default = nanmean(mean_default); % calculating mean for each column
                               mean_default = mean_default(~isnan(mean_default)); % excluding columns with nan result 
                               mean_default = mean(mean_default); % calculating mean of the columns 
                                                                                          
                               mean_default_all(subjind,:) = mean_default; % mean values of all subjects
                               
                               [~, mod] = modularity_und(default);
                               modul_default(subjind,:) = mod;


                              %% extracting Dorsal net and mean connectivity 


                               dorsal_lh = (31:43); % 
                               dorsal_rh = (135:147); 
                               %
                               dorsal_index = [ dorsal_lh, dorsal_rh]; %
                               dorsal = Mat(dorsal_index, dorsal_index);
                               
                               dorsal_sign1 = dorsal(1,3);
                               dorsal_sign2 = dorsal(1,6) ;
                               dorsal_sign3 = dorsal(1,11);  
                               dorsal_sign4 = dorsal(5,11)  ; 
                               dorsal_sign5 = dorsal(10,11);
                               dorsal_sign6 = dorsal(1,14) ;
                               dorsal_sign7 =  dorsal(3,14) ;  
                               dorsal_sign8 =  dorsal(7,14)  ;
                               dorsal_sign9 =   dorsal(8,14)  ;
                               dorsal_sign10 =  dorsal(13,14) ;
                               dorsal_sign11 =  dorsal(4,16) ; 
                               dorsal_sign12 =  dorsal(5,16)  ;
                               dorsal_sign13 =  dorsal(10,16)  ;
                               dorsal_sign14 =  dorsal(11,16)  ; 
                               dorsal_sign15 =  dorsal(12,16)  ;   
                               dorsal_sign16 =  dorsal(4,17)  ;
                               dorsal_sign17 =  dorsal(5,17);
                               dorsal_sign18 =  dorsal(14,17) ; 
                               dorsal_sign19 =  dorsal(16,17) ;   
                               dorsal_sign20 =  dorsal(4,18);  
                               dorsal_sign21 =  dorsal(5,18)   ;  
                               dorsal_sign22 =  dorsal(10,18)   ; 
                               dorsal_sign23 =  dorsal(11,18)   ; 
                               dorsal_sign24 =  dorsal(16,18)  ; 
                               dorsal_sign25 =  dorsal(17,18)  ; 
                               dorsal_sign26 =  dorsal(1,20)  ;   
                               dorsal_sign27 =  dorsal(14,20) ; 
                               dorsal_sign28 =  dorsal(14,21) ;    
                               dorsal_sign29 =  dorsal(10,22) ; 
                               dorsal_sign30 =  dorsal(10,23) ; 
                               dorsal_sign31 =  dorsal(11,23) ; 
                               dorsal_sign32 =  dorsal(16,23) ;   
                               dorsal_sign33 =  dorsal(18,23) ;  
                               dorsal_sign34 =  dorsal(22,23) ;   
                               dorsal_sign35 =  dorsal(11,24) ;   
                               dorsal_sign36 =  dorsal(16,24) ;  
                               dorsal_sign37 =  dorsal(20,24) ;  
                               dorsal_sign38 =  dorsal(23,24) ;   
                               dorsal_sign39 =  dorsal(20,26) ;  
                               
   dorsal_sign =  [dorsal_sign1,dorsal_sign2,dorsal_sign3,dorsal_sign4,dorsal_sign5,dorsal_sign6, dorsal_sign7...
                   dorsal_sign8,dorsal_sign9,dorsal_sign10,dorsal_sign11,dorsal_sign12,dorsal_sign13,dorsal_sign13...
                   dorsal_sign14,dorsal_sign15,dorsal_sign16,dorsal_sign17,dorsal_sign18,dorsal_sign19,dorsal_sign20...
                   dorsal_sign21,dorsal_sign22,dorsal_sign23,dorsal_sign24,dorsal_sign25,dorsal_sign26,dorsal_sign27...
                   dorsal_sign28,dorsal_sign29,dorsal_sign30,dorsal_sign31,dorsal_sign32,dorsal_sign33,dorsal_sign34...
                   dorsal_sign35,dorsal_sign36,dorsal_sign37,dorsal_sign37,dorsal_sign38,dorsal_sign39];

                               mean_dorsal_sign = mean(dorsal_sign);
                               mean_dorsal_sign_all(subjind,:) = mean_dorsal_sign;
                      
                               dorsal_all(:,:,subjind)  = dorsal;
                               
                               mean_dorsal = tril(dorsal);
                               mean_dorsal(mean_dorsal==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_dorsal = nanmean(mean_dorsal);
                               mean_dorsal = mean_dorsal(~isnan(mean_dorsal));
                               mean_dorsal = mean(mean_dorsal);
                               mean_dorsal_all(subjind,:) = mean_dorsal;
                               
                               
                               [~, mod] = modularity_und(dorsal);
                               modul_dorsal(subjind,:) = mod;

                             %%  extracting SalVen net and mean connectivity     


                               salven_lh = (44:54); % 
                               salven_rh = (148:158); 
                               %
                               salven_index = [salven_lh,salven_rh]; %
                               salven = Mat(salven_index, salven_index);
                               

                               
                                salven_sign1 = salven   (1,4)     ;      
                                salven_sign2 = salven   (2,4)    ;       
                                salven_sign3 = salven   (4,5)    ;       
                                salven_sign4 = salven   (2,6)   ;        
                                salven_sign5 = salven   (4,6)   ;        
                                salven_sign6 = salven   (2,9)   ;        
                                salven_sign7 = salven   (4,9)   ;        
                                salven_sign8 = salven   (5,9)   ;        
                                salven_sign9 = salven   (6,9)     ;      
                                salven_sign10 = salven   (4,10)   ;       
                                salven_sign11 = salven   (5,10)  ;        
                                salven_sign12 = salven   (6,10)   ;       
                                salven_sign13 = salven   (9,10)   ;       
                                salven_sign14 = salven   (1,11)   ;       
                                salven_sign15 = salven   (4,11)   ;       
                                salven_sign16 = salven   (6,11)   ;       
                                salven_sign17 = salven   (9,11)   ;       
                                salven_sign18 = salven  (10,11)   ;       
                                salven_sign19 = salven   (1,14)   ;       
                                salven_sign20 = salven   (2,14)   ;       
                                salven_sign21 = salven   (4,14)   ;       
                                salven_sign22 = salven   (5,14)   ;       
                                salven_sign23 = salven   (6,14)   ;       
                                salven_sign24 = salven   (9,14)   ;       
                                salven_sign25 = salven  (10,14)   ;       
                                salven_sign26 = salven  (11,14)  ;        
                                salven_sign27 = salven   (1,17)  ;        
                                salven_sign28 = salven   (2,17)  ;        
                                salven_sign29 = salven   (3,17)    ;      
                                salven_sign30 = salven   (4,17)    ;      
                                salven_sign31 = salven   (6,17)    ;      
                                salven_sign32 = salven   (7,17)   ;       
                                salven_sign33 = salven   (9,17)   ;       
                                salven_sign34 = salven  (11,17)   ;       
                                salven_sign35 = salven  (14,17)    ;      
                                salven_sign36 = salven   (4,18)   ;       
                                salven_sign37 = salven   (5,18)  ;        
                                salven_sign38 = salven   (9,18)  ;        
                                salven_sign39 = salven  (10,18)   ;       
                                salven_sign40 = salven  (14,18)   ;       
                                salven_sign41 = salven   (4,19)    ;      
                                salven_sign42 = salven   (5,19)   ;       
                                salven_sign43 = salven   (6,19)   ;       
                                salven_sign44 = salven   (9,19)   ;       
                                salven_sign45 = salven  (10,19)   ;       
                                salven_sign46 = salven  (11,19)   ;       
                                salven_sign47 = salven  (14,19)   ;       
                                salven_sign48 = salven  (17,19)   ;       
                                salven_sign49 = salven  (18,19)     ;     
                                salven_sign50 = salven   (1,20)   ;       
                                salven_sign51 = salven   (4,20)   ;       
                                salven_sign52 = salven   (5,20)   ;       
                                salven_sign53 = salven   (6,20)   ;       
                                salven_sign54 = salven   (9,20)    ;      
                                salven_sign55 = salven  (10,20)    ;      
                                salven_sign56 = salven  (11,20)    ;      
                                salven_sign57 = salven  (14,20)     ;     
                                salven_sign58 = salven  (17,20)     ;     
                                salven_sign59 = salven  (19,20)     ;     
                                salven_sign60 = salven   (4,21)     ;     
                                salven_sign61 = salven   (5,21)    ;      
                                salven_sign62 = salven   (9,21)   ;       
                                salven_sign63 = salven  (10,21)    ;      
                                salven_sign64 = salven  (14,21)   ;       
                                salven_sign65 = salven  (18,21)   ;       
                                salven_sign66 = salven  (19,21)   ;       
                                salven_sign67 = salven  (20,21)    ;      
                                salven_sign68 = salven   (5,22)    ;      
                                salven_sign69 = salven   (6,22)    ;      
                                salven_sign70 = salven   (9,22)    ;      
                                salven_sign71 = salven  (13,22)    ;      
                                salven_sign72 = salven  (14,22)    ;      
                                salven_sign73 = salven  (15,22)    ;      
                                salven_sign74 = salven  (18,22)    ;      
                                salven_sign75 = salven  (19,22)    ;      
                                salven_sign76 = salven  (20,22)      ;    
 
                               
salven_sign = [salven_sign1,salven_sign2,salven_sign3,salven_sign4,salven_sign5,salven_sign6,salven_sign7...
               salven_sign8,salven_sign9,salven_sign10,salven_sign11,salven_sign12,salven_sign13,salven_sign13...
               salven_sign14,salven_sign15,salven_sign16,salven_sign17,salven_sign18,salven_sign19,salven_sign20...
               salven_sign21,salven_sign22,salven_sign23,salven_sign24,salven_sign25,salven_sign26,salven_sign27...
               salven_sign28,salven_sign29,salven_sign30,salven_sign31,salven_sign32,salven_sign33,salven_sign34...
               salven_sign35,salven_sign36,salven_sign37,salven_sign31,salven_sign38,salven_sign39,salven_sign40...
               salven_sign41,salven_sign42,salven_sign43,salven_sign44,salven_sign45,salven_sign46,salven_sign47...
               salven_sign48,salven_sign49,salven_sign50,salven_sign51,salven_sign52,salven_sign53,salven_sign54...
               salven_sign55,salven_sign56,salven_sign57,salven_sign58,salven_sign59,salven_sign60,salven_sign61...
               salven_sign62,salven_sign63,salven_sign64,salven_sign65,salven_sign66,salven_sign67,salven_sign68...
               salven_sign69];
                                
                               mean_salven_sign = mean(salven_sign);
                               mean_salven_sign_all(subjind,:) = mean_salven_sign;                                                                                             
                               
                               salven_all(:,:,subjind)  = salven;
                               
                               mean_salven = tril(salven);
                               mean_salven(mean_salven==0) = nan;

                               mean_salven = nanmean(mean_salven);
                               mean_salven = mean_salven(~isnan(mean_salven));
                               mean_salven = mean(mean_salven);
                               mean_salven_all(subjind,:) = mean_salven;


                               [~, mod] = modularity_und(salven);
                               modul_salven(subjind,:) = mod;


                            %%  extracting SomMot net and mean connectivity     


                               sommot_lh = (15:30); % 
                               sommot_rh = (116:134); 
                               %
                               sommot_index = [ sommot_lh, sommot_rh]; %
                               sommot = Mat(sommot_index, sommot_index);
                               


                               
                               sommot_sign1 = sommot   (1,2)   ;        
                               sommot_sign2 = sommot   (2,3)   ;        
                               sommot_sign3 = sommot   (1,4)   ;        
                               sommot_sign4 = sommot   (2,4)   ;        
                               sommot_sign5 = sommot   (3,4)   ;        
                               sommot_sign6 = sommot   (1,5)    ;       
                               sommot_sign7 = sommot   (2,5)   ;        
                               sommot_sign8 = sommot   (3,5)   ;        
                               sommot_sign9 = sommot   (4,5)   ;        
                               sommot_sign10 = sommot   (3,6)  ;         
                               sommot_sign11 = sommot   (4,7)  ;         
                               sommot_sign12 = sommot   (2,8)  ;         
                               sommot_sign13 = sommot   (3,8)   ;        
                               sommot_sign14 = sommot   (4,8)   ;        
                               sommot_sign15 = sommot   (5,8)   ;        
                               sommot_sign16 = sommot   (3,9)   ;        
                               sommot_sign17 = sommot   (3,10)  ;        
                               sommot_sign18 = sommot   (9,10)   ;       
                               sommot_sign19 = sommot      (2,11)  ;        
                               sommot_sign20 = sommot      (5,11)  ;        
                               sommot_sign21 = sommot      (3,12)  ;        
                               sommot_sign22 = sommot      (8,12)  ;        
                               sommot_sign23 = sommot     (10,12)  ;        
                               sommot_sign24 = sommot      (8,13)   ;       
                               sommot_sign25 = sommot     (10,13)  ;        
                               sommot_sign26= sommot     (11,13)   ;       
                               sommot_sign27 = sommot      (5,14)  ;        
                               sommot_sign28 = sommot      (8,14)  ;        
                               sommot_sign29 = sommot     (11,14)   ;       
                               sommot_sign30 = sommot     (13,14)  ;        
                               sommot_sign31 = sommot      (3,15)   ;       
                               sommot_sign32 = sommot     (12,15)   ;       
                               sommot_sign33 = sommot     (14,15)  ;        
                               sommot_sign34 = sommot      (3,16)  ;        
                               sommot_sign35 = sommot      (8,16)  ;        
                               sommot_sign36 = sommot     (15,16)  ;        
                               sommot_sign37 = sommot      (1,17)  ;        
                               sommot_sign38 = sommot      (2,17)   ;       
                               sommot_sign39 = sommot      (3,17)   ;       
                               sommot_sign40 = sommot      (4,17)   ;       
                               sommot_sign41 = sommot      (5,17)   ;       
                               sommot_sign42 = sommot      (7,17)   ;       
                               sommot_sign43 = sommot      (8,17)   ;       
                               sommot_sign44 = sommot      (1,18)   ;       
                               sommot_sign45 = sommot      (2,18)   ;       
                               sommot_sign46 = sommot      (3,18)    ;         
                               sommot_sign47 = sommot      (5,18)   ;       
                               sommot_sign48 = sommot     (17,18)   ;       
                               sommot_sign49 = sommot      (2,19)  ;        
                               sommot_sign50 = sommot      (3,19)   ;       
                               sommot_sign51 = sommot      (4,19)  ;        
                               sommot_sign52 = sommot      (5,19)   ;       
                               sommot_sign53 = sommot      (6,19)   ;       
                               sommot_sign54 = sommot      (8,19)   ;       
                               sommot_sign55 = sommot      (9,19)    ;      
                               sommot_sign56 = sommot     (10,19)    ;      
                               sommot_sign57 = sommot     (12,19)   ;       
                               sommot_sign58 = sommot     (13,19)   ;       
                               sommot_sign59 = sommot     (15,19)    ;      
                               sommot_sign60 = sommot     (16,19)   ;       
                               sommot_sign61 = sommot     (17,19)    ;     
                               sommot_sign62 = sommot      (1,20)   ;      
                               sommot_sign63 = sommot      (2,20)  ;        
                               sommot_sign64 = sommot      (3,20)   ;       
                               sommot_sign65 = sommot      (4,20)  ;        
                               sommot_sign66 = sommot      (5,20)  ;        
                               sommot_sign67 = sommot      (8,20)  ;        
                               sommot_sign68 = sommot     (10,20)  ;        
                               sommot_sign69 = sommot     (11,20)   ;       
                               sommot_sign70 = sommot     (12,20)   ;       
                               sommot_sign71 = sommot     (13,20)  ;        
                               sommot_sign72 = sommot     (14,20)   ;       
                               sommot_sign73 = sommot     (15,20)   ;       
                               sommot_sign74 = sommot     (16,20)    ;      
                               sommot_sign75 = sommot     (17,20)   ;       
                               sommot_sign76 = sommot     (19,20)    ;      
                               sommot_sign77 = sommot      (1,21)  ;        
                               sommot_sign78 = sommot      (2,21)    ;      
                               sommot_sign79 = sommot      (3,21)   ;       
                               sommot_sign80 = sommot      (4,21)   ;       
                               sommot_sign81 = sommot      (5,21)   ;       
                               sommot_sign82 = sommot      (7,21)   ;       
                               sommot_sign83 = sommot     (17,21)   ;       
                               sommot_sign84 = sommot     (20,21)   ;       
                               sommot_sign85 = sommot      (1,22)  ;        
                               sommot_sign86 = sommot      (2,22)   ;       
                               sommot_sign87 = sommot      (3,22)   ;       
                               sommot_sign88 = sommot      (4,22)    ;      
                               sommot_sign89 = sommot      (5,22)    ;      
                               sommot_sign90 = sommot      (8,22)  ;        
                               sommot_sign91 = sommot      (9,22)  ;        
                               sommot_sign92 = sommot     (10,22)  ;        
                               sommot_sign93 = sommot     (12,22)  ;        
                               sommot_sign94 = sommot     (13,22)   ;       
                               sommot_sign95 = sommot     (14,22)  ;        
                               sommot_sign96 = sommot     (17,22)  ;       
                               sommot_sign97 = sommot     (19,22)  ;        
                               sommot_sign98 = sommot     (20,22)   ;       
                               sommot_sign99 = sommot     (10,23)  ;        
                               sommot_sign100 = sommot     (19,23)  ;        
                               sommot_sign101 = sommot      (3,24)   ;       
                               sommot_sign102 = sommot      (8,24)  ;        
                               sommot_sign103 = sommot     (13,24)  ;        
                               sommot_sign104 = sommot     (14,24)  ;        
                               sommot_sign105 = sommot     (15,24)   ;       
                               sommot_sign106 = sommot     (18,24)  ;        
                               sommot_sign107 = sommot     (20,24)  ;        
                               sommot_sign108 = sommot      (9,25)  ;        
                               sommot_sign109 = sommot     (17,25)   ;       
                               sommot_sign110 = sommot     (19,25)  ;        
                               sommot_sign111 = sommot      (4,26)   ;       
                               sommot_sign112 = sommot      (7,26)   ;       
                               sommot_sign113 = sommot     (19,26)   ;       
                               sommot_sign114 = sommot     (21,26)   ;       
                               sommot_sign115 = sommot     (22,26)   ;       
                               sommot_sign116 = sommot      (3,27)   ;       
                               sommot_sign117 = sommot      (5,27)    ;      
                               sommot_sign118 = sommot      (8,27)    ;      
                               sommot_sign119 = sommot     (13,27)   ;       
                               sommot_sign120 = sommot     (14,27)  ;        
                               sommot_sign121 = sommot     (19,27)  ;        
                               sommot_sign122 = sommot     (20,27)  ;        
                               sommot_sign123 = sommot     (22,27)   ;       
                               sommot_sign124 = sommot     (3,28)    ;      
                               sommot_sign125 = sommot     (10,28)   ;       
                               sommot_sign126 = sommot     (12,28)   ;       
                               sommot_sign127 = sommot     (19,28)   ;       
                               sommot_sign128 = sommot     (22,28)   ;       
                               sommot_sign129 = sommot      (3,29)   ;       
                               sommot_sign130 = sommot      (4,29)   ;       
                               sommot_sign131 = sommot      (5,29)   ;       
                               sommot_sign132 = sommot      (9,29)   ;       
                               sommot_sign133 = sommot     (11,29)   ;       
                               sommot_sign134 = sommot     (12,29)   ;       
                               sommot_sign135 = sommot     (13,29)   ;       
                               sommot_sign136 = sommot     (14,29)   ;       
                               sommot_sign137 = sommot     (19,29)   ;       
                               sommot_sign138 = sommot     (20,29)   ;       
                               sommot_sign139 = sommot     (22,29)   ;       
                               sommot_sign140 = sommot      (3,30)   ;       
                               sommot_sign141 = sommot     (10,30)   ;       
                               sommot_sign142 = sommot     (12,30)  ;        
                               sommot_sign143 = sommot     (16,30)   ;       
                               sommot_sign144 = sommot     (19,30)  ;        
                               sommot_sign145 = sommot     (28,30)  ;        
                               sommot_sign146 = sommot      (4,31)   ;       
                               sommot_sign147 = sommot     (11,31)   ;       
                               sommot_sign148 = sommot     (13,31)   ;       
                               sommot_sign149 = sommot     (20,31)   ;         
                               sommot_sign150 = sommot     (24,31)   ;        
                               sommot_sign151 = sommot      (5,32)    ;      
                               sommot_sign152 = sommot      (8,32)   ;       
                               sommot_sign153 = sommot     (11,32)   ;       
                               sommot_sign154 = sommot     (13,32)    ;      
                               sommot_sign155 = sommot     (14,32)    ;      
                               sommot_sign156 = sommot     (20,32)    ;      
                               sommot_sign157 = sommot     (27,32)    ;     
                               sommot_sign158 = sommot     (29,32)    ;        
                               sommot_sign159 = sommot      (1,33)   ;       
                               sommot_sign160 = sommot      (3,33)     ;     
                               sommot_sign161 = sommot      (8,33)     ;     
                               sommot_sign162 = sommot     (13,33)    ;      
                               sommot_sign163 = sommot     (15,33)   ;       
                               sommot_sign164 = sommot     (19,33)   ;       
                               sommot_sign165= sommot      (3,34)    ;      
                               sommot_sign166 = sommot      (8,34)   ;       
                               sommot_sign167 = sommot     (15,34)    ;      
                               sommot_sign168 = sommot     (16,34)    ;      
                               sommot_sign169 = sommot     (19,34)   ;       
                               sommot_sign170 = sommot     (20,34)    ;      
                               sommot_sign171 = sommot     (30,34)   ;       
                               sommot_sign172 = sommot     (33,34)    ;      
                               sommot_sign173 = sommot     (15,35)    ;      
                               sommot_sign174 = sommot     (16,35)    ;      
                               sommot_sign175 = sommot     (19,35)    ;      
                               sommot_sign176 = sommot     (30,35)     ;     
                               sommot_sign177 = sommot     (33,35)     ;     
                               sommot_sign178 = sommot     (34,35)     ;     

sommot_sign = [sommot_sign1,sommot_sign2,sommot_sign3,sommot_sign4,sommot_sign5,sommot_sign6,sommot_sign7...
               sommot_sign8,sommot_sign9,sommot_sign10,sommot_sign11,sommot_sign12,sommot_sign13,sommot_sign13...
               sommot_sign14,sommot_sign15,sommot_sign16,sommot_sign17,sommot_sign18,sommot_sign19,sommot_sign20...
               sommot_sign21,sommot_sign22,sommot_sign23,sommot_sign24,sommot_sign25,sommot_sign26,sommot_sign27...
               sommot_sign28,sommot_sign29,sommot_sign30,sommot_sign31,sommot_sign32,sommot_sign33,sommot_sign34...
               sommot_sign35,sommot_sign36,sommot_sign37,sommot_sign31,sommot_sign38,sommot_sign39,sommot_sign40...
               sommot_sign41,sommot_sign42,sommot_sign43,sommot_sign44,sommot_sign45,sommot_sign46,sommot_sign47...
               sommot_sign48,sommot_sign49,sommot_sign50,sommot_sign51,sommot_sign52,sommot_sign53,sommot_sign54...
               sommot_sign55,sommot_sign56,sommot_sign57,sommot_sign58,sommot_sign59,sommot_sign60,sommot_sign61...
               sommot_sign62,sommot_sign63,sommot_sign64,sommot_sign65,sommot_sign66,sommot_sign67,sommot_sign68...
               sommot_sign69,sommot_sign70,sommot_sign71,sommot_sign72,sommot_sign73,sommot_sign74,sommot_sign75...
               sommot_sign76,sommot_sign77,sommot_sign78,sommot_sign79,sommot_sign80,sommot_sign81...
               sommot_sign82,sommot_sign83,sommot_sign84,sommot_sign85,sommot_sign86,sommot_sign87,sommot_sign88...
               sommot_sign89,sommot_sign90,sommot_sign91,sommot_sign92,sommot_sign93,sommot_sign94,sommot_sign95...
               sommot_sign96,sommot_sign97,sommot_sign98,sommot_sign99,sommot_sign100,sommot_sign101,sommot_sign102...
               sommot_sign103,sommot_sign104,sommot_sign105,sommot_sign106,sommot_sign107,sommot_sign108,sommot_sign109...
               sommot_sign110,sommot_sign111,sommot_sign112,sommot_sign113,sommot_sign114,sommot_sign115,sommot_sign116...
               sommot_sign117,sommot_sign118,sommot_sign119,sommot_sign120,sommot_sign121,sommot_sign122,sommot_sign123...
               sommot_sign124,sommot_sign125,sommot_sign126,sommot_sign127,sommot_sign128,sommot_sign129,sommot_sign130...
               sommot_sign131,sommot_sign132,sommot_sign133,sommot_sign134,sommot_sign135,sommot_sign136,sommot_sign137...
               sommot_sign138,sommot_sign139,sommot_sign140,sommot_sign141,sommot_sign142,sommot_sign143,sommot_sign144...
               sommot_sign145,sommot_sign146,sommot_sign147,sommot_sign148,sommot_sign149,sommot_sign150,sommot_sign151...
               sommot_sign152,sommot_sign153,sommot_sign154,sommot_sign155,sommot_sign156,sommot_sign157,sommot_sign158...
               sommot_sign159,sommot_sign160,sommot_sign161,sommot_sign162,sommot_sign163,sommot_sign164,sommot_sign165...
               sommot_sign166,sommot_sign167,sommot_sign168,sommot_sign169,sommot_sign170,sommot_sign171,sommot_sign172...
               sommot_sign173,sommot_sign174,sommot_sign175,sommot_sign176,sommot_sign177,sommot_sign178];
                                
                            mean_sommot_sign = mean(sommot_sign);
                            mean_sommot_sign_all(subjind,:) = mean_sommot_sign;                                
                               
                               
                               
                             
                               
                               
                               
                               sommot_all(:,:,subjind)  = sommot;
                               
                               mean_sommot = tril(sommot);
                               mean_sommot(mean_sommot==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_sommot = nanmean(mean_sommot);
                               mean_sommot = mean_sommot(~isnan(mean_sommot));
                               mean_sommot = mean(mean_sommot);
                               mean_sommon_all(subjind,:) = mean_sommot;
                               
                               
                               [~, mod] = modularity_und(sommot);
                               modul_sommot(subjind,:) = mod;


                            %%  extracting Cont net and mean connectivity     


                               cont_lh = (61:73); % 
                               cont_rh = (165:181); 
                               %
                               cont_index = [cont_lh,cont_rh]; %
                               cont = Mat(cont_index, cont_index);
                               cont_all(:,:,subjind)  = cont;
                               
                               cont_sign1 = cont  (11,12)  ;        
                               cont_sign2 = cont    (11,26)   ;       
                               cont_sign3 = cont    (12,26)   ;       
                               cont_sign4 = cont    (11,27)    ;      
                               cont_sign5 = cont    (12,27)    ;      

                            cont_sign = [cont_sign1,cont_sign2,cont_sign3,cont_sign4,cont_sign5];

                                mean_cont_sign = mean(cont_sign);
                                mean_cont_sign_all(subjind,:) = mean_cont_sign;   
                               
                               mean_cont = tril(cont);
                               mean_cont(mean_cont==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_cont = nanmean(mean_cont);
                               mean_cont = mean_cont(~isnan(mean_sommot));
                               mean_cont = mean(mean_cont);
                               mean_cont_all(subjind,:) = mean_cont;

                               [~, mod] = modularity_und(cont);
                               modul_cont(subjind,:) = mod;



                           %%  extracting Vis net and mean connectivity     


                               vis_lh = (1:14); % 
                               vis_rh = (101:115); 
                               %
                               vis_index = [vis_lh,vis_rh]; %
                               vis = Mat(vis_index, vis_index);

                               


                               vis_sign1 = vis   (1,2)  ;         
                               vis_sign2 = vis   (1,3)  ;         
                               vis_sign3 = vis   (2,5)  ;         
                               vis_sign4 = vis   (3,5)  ;         
                               vis_sign5 = vis   (2,7)  ;         
                               vis_sign6 = vis   (2,9)  ;         
                               vis_sign7 = vis   (5,9)  ;         
                               vis_sign8 = vis   (6,10)  ;        
                               vis_sign9 = vis   (1,11)  ;        
                               vis_sign10 = vis   (2,11)  ;        
                               vis_sign11 = vis   (3,11)  ;        
                               vis_sign12 = vis   (6,12)  ;        
                               vis_sign13 = vis   (2,13)  ;        
                               vis_sign14 = vis   (4,13)  ;        
                               vis_sign15 = vis   (1,14)  ;        
                               vis_sign16 = vis   (2,14)  ;        
                               vis_sign17 = vis   (3,14)  ;        
                               vis_sign18 = vis  (5,14)  ;        
                               vis_sign19 = vis   (9,14)  ;        
                               vis_sign20 = vis  (11,14)  ;        
                               vis_sign21 = vis   (1,15)  ;        
                               vis_sign22 = vis  (11,15)  ;        
                               vis_sign23 = vis   (1,16)  ;        
                               vis_sign24 = vis   (2,16)  ;        
                               vis_sign25 = vis   (1,17)  ;        
                               vis_sign26 = vis   (2,17)  ;        
                               vis_sign27 = vis   (3,17)  ;        
                               vis_sign28 = vis  (11,17)  ;        
                               vis_sign29 = vis  (13,17)  ;        
                               vis_sign30 = vis  (14,17)  ;        
                               vis_sign31 = vis   (2,18)  ;        
                               vis_sign32 = vis  (13,18)  ;        
                               vis_sign33 = vis   (1,19)   ;       
                               vis_sign34 = vis   (2,19)  ;        
                               vis_sign35 = vis   (3,19)  ;        
                               vis_sign36 = vis   (5,19)  ;        
                               vis_sign37 = vis   (8,19)  ;        
                               vis_sign38 = vis  (11,19)  ;        
                               vis_sign39 = vis  (14,19)  ;        
                               vis_sign40 = vis  (17,19)  ;        
                               vis_sign41 = vis   (7,20)  ;        
                               vis_sign42 = vis   (9,20)  ;        
                               vis_sign43 = vis  (13,20)  ;        
                               vis_sign44 = vis  (18,20)  ;        
                               vis_sign45 = vis  (10,21)  ;        
                               vis_sign46 = vis  (12,21)  ;        
                               vis_sign47 = vis   (2,22)  ;        
                               vis_sign48 = vis   (3,22)  ;        
                               vis_sign49 = vis   (9,22)   ;       
                               vis_sign50 = vis  (11,22)   ;       
                               vis_sign51 = vis  (13,22)   ;       
                               vis_sign52 = vis  (14,22)   ;       
                               vis_sign53 = vis  (17,22)   ;       
                               vis_sign54 = vis   (6,23)   ;       
                               vis_sign55 = vis  (10,23)   ;       
                               vis_sign56 = vis  (18,23)   ;       
                               vis_sign57 = vis  (20,23)   ;      
                               vis_sign58 = vis   (4,24)   ;       
                               vis_sign59 = vis   (6,24)   ;       
                               vis_sign60 = vis  (10,24)  ;        
                               vis_sign61 = vis  (12,24)  ;        
                               vis_sign62 = vis  (18,24)  ;        
                               vis_sign63 = vis  (21,24)   ;       
                               vis_sign64 = vis  (23,24)   ;       
                               vis_sign65 = vis   (1,25)   ;       
                               vis_sign66 = vis   (3,25)  ;        
                               vis_sign67 = vis  (11,25)   ;       
                               vis_sign68 = vis  (14,25)   ;       
                               vis_sign69 = vis  (16,25)   ;       
                               vis_sign70 = vis  (17,25)   ;       
                               vis_sign71 = vis  (19,25)  ;        
                               vis_sign72 = vis   (1,26)  ;       
                               vis_sign73 = vis   (2,26)  ;        
                               vis_sign74 = vis   (5,26)  ;        
                               vis_sign75 = vis  (17,26)   ;       
                               vis_sign76 = vis  (20,26)   ;       
                               vis_sign77 = vis  (22,26)   ;       
                               vis_sign78 = vis   (6,27)   ;       
                               vis_sign79 = vis  (10,27)   ;       
                               vis_sign80 = vis  (12,27)  ;        
                               vis_sign81 = vis  (21,27)  ;        
                               vis_sign82 = vis  (24,27)  ;        
                               vis_sign83 = vis   (1,28)   ;       
                               vis_sign84 = vis   (2,28)   ;       
                               vis_sign85 = vis   (4,28)  ;        
                               vis_sign86 = vis   (8,28)   ;       
                               vis_sign87 = vis  (17,28)  ;        
                               vis_sign88 = vis  (18,28)  ;        
                               vis_sign89 = vis  (20,28)  ;       
                               vis_sign90 = vis  (24,28)   ;       
                               vis_sign91 = vis   (3,29)  ;        
                               vis_sign92 = vis  (19,29)  ;        

                               
                       
   vis_sign = [vis_sign1,vis_sign2,vis_sign3,vis_sign4,vis_sign5,vis_sign6,vis_sign7...
               vis_sign8,vis_sign9,vis_sign10,vis_sign11,vis_sign12,vis_sign13,vis_sign13...
               vis_sign14,vis_sign15,vis_sign16,vis_sign17,vis_sign18,vis_sign19,vis_sign20...
               vis_sign21,vis_sign22,vis_sign23,vis_sign24,vis_sign25,vis_sign26,vis_sign27...
               vis_sign28,vis_sign29,vis_sign30,vis_sign31,vis_sign32,vis_sign33,vis_sign34...
               vis_sign35,vis_sign36,vis_sign37,vis_sign31,vis_sign38,vis_sign39,vis_sign40...
               vis_sign41,vis_sign42,vis_sign43,vis_sign44,vis_sign45,vis_sign46,vis_sign47...
               vis_sign48,vis_sign49,vis_sign50,vis_sign51,vis_sign52,vis_sign53,vis_sign54...
               vis_sign55,vis_sign56,vis_sign57,vis_sign58,vis_sign59,vis_sign60,vis_sign61...
               vis_sign62,vis_sign63,vis_sign64,vis_sign65,vis_sign66,vis_sign67,vis_sign68...
               vis_sign69,vis_sign70,vis_sign71,vis_sign72,vis_sign73,vis_sign74,vis_sign75...
               vis_sign76,vis_sign77,vis_sign78,vis_sign79,vis_sign80,vis_sign81,vis_sign82...
               vis_sign83,vis_sign84,vis_sign85,vis_sign86,vis_sign87,vis_sign88,vis_sign89...
               vis_sign90,vis_sign91,vis_sign92];

                               mean_vis_sign = mean(vis_sign);
                               mean_vis_sign_all(subjind,:) = mean_vis_sign;
                               
                               vis_all(:,:,subjind)  = vis;
                               
                               mean_vis = tril(vis);
                               mean_vis(mean_vis==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_vis = nanmean(mean_vis);
                               mean_vis = mean_vis(~isnan(mean_vis));
                               mean_vis = mean(mean_vis);
                               mean_vis_all(subjind,:) = mean_vis;
                               
                               
                               

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
                               mean_limb_all(subjind,:) = mean_limb;         
                               
%                                [~, mod] = modularity_und(limb);
%                                modul_limb(subjind,:) = mod;
%% Mean within connectivity                               
                               within = [mean_default,mean_dorsal,mean_salven, mean_sommot,mean_cont,mean_vis,mean_limb]
                               mean_within = mean(within)
                               mean_within_all(subjind,:) = mean_within;   
                               
                               
                               %% CONNECTIVITY BETWEEN NETWORKS
                               
                               
                               
                               
                                  if absolute_values

                                     target_dir_bet = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh) '/between_net'];

                                  elseif no_negative 

                                     target_dir_bet = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_no_neg_' num2str(thresh) '/between_net'];

                                  else

                                     target_dir_bet = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh) '/between_net'];

                                  end
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
                                           
                                           mean_default_rest_mat = nanmean(mean_default_rest_mat); % calculating mean for each column
                                           mean_default_rest_mat = mean_default_rest_mat(~isnan(mean_default_rest_mat)); % excluding columns with nan result 
                                           mean_default_rest_mat = mean(mean_default_rest_mat); 
                                           
                                           default_betw_all(subjind,:) = mean_default_rest_mat;
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
                                           
                                           mean_dorsal_rest_mat = nanmean(mean_dorsal_rest_mat); % calculating mean for each column
                                           mean_dorsal_rest_mat = mean_dorsal_rest_mat(~isnan(mean_dorsal_rest_mat)); % excluding columns with nan result 
                                           mean_dorsal_rest_mat = mean(mean_dorsal_rest_mat); 
                                           
                                           dorsal_betw_all(subjind,:) = mean_dorsal_rest_mat;
                                                                                
                                                                         


                                



                                       %%  extracting salven and rest connectivity
                                       
                                           mat_index = (1:1:200);
                                           
                                           salven_lh = (44:54); % 
                                           salven_rh = (148:158)
                                           
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
                                           
                                           mean_salven_rest_mat = nanmean(mean_salven_rest_mat); % calculating mean for each column
                                           mean_salven_rest_mat = mean_salven_rest_mat(~isnan(mean_salven_rest_mat)); % excluding columns with nan result 
                                           mean_salven_rest_mat = mean(mean_salven_rest_mat);  
                                           
                                           salven_betw_all(subjind,:)  = mean_salven_rest_mat;
                                           
                                  
                             


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
                                           
                                           mean_sommot_rest_mat = nanmean(mean_sommot_rest_mat); % calculating mean for each column
                                           mean_sommot_rest_mat = mean_sommot_rest_mat(~isnan(mean_sommot_rest_mat)); % excluding columns with nan result 
                                           mean_sommot_rest_mat = mean(mean_sommot_rest_mat);    
                                           
                                           sommot_betw_all(subjind,:)  = mean_sommot_rest_mat;
                                




                                  

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
                                           
                                           mean_cont_rest_mat = nanmean(mean_cont_rest_mat); % calculating mean for each column
                                           mean_cont_rest_mat = mean_cont_rest_mat(~isnan(mean_cont_rest_mat)); % excluding columns with nan result 
                                           mean_cont_rest_mat = mean(mean_cont_rest_mat);  
                                           
                                           cont_betw_all(subjind,:)  = mean_cont_rest_mat;
                                          







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
                                           
                                           mean_vis_rest_mat = nanmean(mean_vis_rest_mat); % calculating mean for each column
                                           mean_vis_rest_mat = mean_vis_rest_mat(~isnan(mean_vis_rest_mat)); % excluding columns with nan result 
                                           mean_vis_rest_mat = mean(mean_vis_rest_mat);                                             
                                           
                                           vis_betw_all(subjind,:)  = mean_vis_rest_mat;
                                         

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
                                           
                                           mean_limb_rest_mat = nanmean(mean_limb_rest_mat); % calculating mean for each column
                                           mean_limb_rest_mat = mean_limb_rest_mat(~isnan(mean_limb_rest_mat)); % excluding columns with nan result 
                                           mean_limb_rest_mat = mean(mean_limb_rest_mat);                                             
                                           
                                           limb_betw_all(subjind,:)  = mean_limb_rest_mat;
                                                                                                  
%% mean between connecitivity for all networks

% for all networks

                                           global_between = [mean_default_rest_mat,mean_dorsal_rest_mat,mean_salven_rest_mat  ...
                                                      mean_sommot_rest_mat,mean_cont_rest_mat,mean_vis_rest_mat,mean_limb_rest_mat];
                                                  
                                           mean_global_between =  mean(global_between);          
                                           mean_global_between_all(subjind,:) = mean_global_between; 
                                           
%% mean within connecitivity for all networks

                                           global_within = [mean_default,mean_dorsal,mean_salven  ...
                                                      mean_sommot,mean_cont,mean_vis,mean_limb];
                                                  
                                           mean_global_within =  mean(global_within);          
                                           mean_global_within_all(subjind,:) = mean_global_within; 

%% Segregation Coefficient
   % single networks                     
                    seg_default = mean_default - mean_default_rest_mat;
                    seg_default = seg_default ./ mean_default;
                    seg_default_all(subjind,:) = seg_default; 
                    
                    seg_dorsal = mean_dorsal - mean_dorsal_rest_mat;
                    seg_dorsal = seg_dorsal ./ mean_dorsal;
                    seg_dorsal_all(subjind,:) = seg_dorsal; 
                    
                    seg_salven = mean_salven - mean_salven_rest_mat;
                    seg_salven = seg_salven ./ mean_salven;
                    seg_salven_all(subjind,:) = seg_salven;
                                        
                    seg_sommot = mean_sommot - mean_sommot_rest_mat;
                    seg_sommot = seg_sommot ./ mean_sommot;
                    seg_sommot_all(subjind,:) = seg_sommot; 

                    seg_cont = mean_cont - mean_cont_rest_mat;
                    seg_cont = seg_cont ./ mean_cont;
                    seg_cont_all(subjind,:) = seg_cont; 
                    
                    seg_vis = mean_vis - mean_vis_rest_mat;
                    seg_vis = seg_vis ./ mean_vis;
                    seg_vis_all(subjind,:) = seg_vis;                     
                    
                    seg_limb = mean_limb - mean_limb_rest_mat;
                    seg_limb = seg_limb ./ mean_limb;
                    seg_limb_all(subjind,:) = seg_limb;   
                    
% Segregation global
                    seg_global = [seg_default, seg_dorsal, seg_salven, seg_sommot, seg_cont, seg_vis, seg_limb];
                    seg_global = mean(seg_global);
                    seg_global_all(subjind,:) = seg_global; 
                    
% Segregation association
                    seg_asso = [seg_default, seg_dorsal, seg_salven, seg_sommot, seg_cont,seg_limb];
                    seg_asso = mean(seg_asso);
                    seg_asso_all(subjind,:) = seg_asso; 

% Segregation sensory
                    seg_sensor = [seg_sommot,seg_vis];
                    seg_sensor = mean(seg_sensor);
                    seg_sensor_all(subjind,:) = seg_sensor; 
                                        
                                        
              end
  
                    mkdir (target_dir_with)
                    mkdir (target_dir_bet)

                    % Saving mean within connetivity networks                   
                    save([target_dir_with '/mean_default'],'mean_default_all');
                    save([target_dir_with '/mean_dorsal'],'mean_dorsal_all');
                    save([target_dir_with '/mean_salven'],'mean_salven_all');
                    save([target_dir_with '/mean_sommon'],'mean_sommon_all');
                    save([target_dir_with '/mean_cont'],'mean_cont_all');
                    save([target_dir_with '/mean_conn'],'mean_conn_all');
                   
                    save([target_dir_with '/mean_vis'],'mean_vis_all');
                    save([target_dir_with '/mean_limb'],'mean_limb_all');
                   
                    save([target_dir_with '/mean_global_within'],'mean_global_within_all');
                    
                   % Saving mean within connecitivty of sub-networks
                    save([target_dir_with '/mean_default_sign'],'mean_default_sign_all'); 
                    save([target_dir_with '/mean_dorsal_sign'],'mean_dorsal_sign_all');
                    save([target_dir_with '/mean_salven_sign'],'mean_salven_sign_all'); 
                    save([target_dir_with '/mean_sommot_sign'],'mean_sommot_sign_all'); 
                    
                    save([target_dir_with '/mean_vis_sign'],'mean_vis_sign_all'); 
                    save([target_dir_with '/mean_conn_sign'],'mean_conn_sign_all'); 
                    
                    % Saving mean between connectivity of networks
                    save([target_dir_bet  '/mean_default_between'],'default_betw_all');
                    save([target_dir_bet  '/mean_dorsal_between'],'dorsal_betw_all');
                    save([target_dir_bet  '/mean_salven_between'],'salven_betw_all');
                    save([target_dir_bet  '/mean_sommot_between'],'sommot_betw_all');
                    save([target_dir_bet  '/mean_cont_between'],'cont_betw_all');
                   
                    save([target_dir_bet  '/mean_vis_between'],'vis_betw_all');
                    save([target_dir_bet  '/mean_limb_between'],'limb_betw_all');
                                      
                    save([target_dir_bet  '/mean_global_between'],'mean_global_between_all');     
                    
                    % Saving segregation of networks
                    save([target_dir_bet  '/mean_seg_default'],'seg_default_all');
                    save([target_dir_bet  '/mean_seg_dorsal'],'seg_dorsal_all');
                    save([target_dir_bet  '/mean_seg_salven'],'seg_salven_all');
                    save([target_dir_bet  '/mean_seg_sommot'],'seg_sommot_all');
                    save([target_dir_bet  '/mean_seg_cont'],'seg_cont_all');
                    
                    save([target_dir_bet  '/mean_seg_vis'],'seg_vis_all');
                    save([target_dir_bet  '/mean_seg_limb'],'seg_limb_all');
                    
                    % Saving segregation global
                    save([target_dir_bet  '/mean_seg_global'],'seg_global_all');
                    save([target_dir_bet  '/mean_seg_asso'],'seg_asso_all');
                    save([target_dir_bet  '/mean_seg_sensor'],'seg_sensor_all');


      end