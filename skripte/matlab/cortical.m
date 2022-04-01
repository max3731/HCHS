hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
target_dir = [hchs_dir, '/csv_for_R'];

main_txt_path = [hchs_dir '/sozio_data'];

tbl = readtable([main_txt_path '/976_participants.csv']);

ID = tbl.id;

cd (main_txt_path);


tbl_c_lh = readtable([main_txt_path '/thickness_lh_summary_longformat.txt']);
tbl_c_rh = readtable([main_txt_path '/thickness_rh_summary_longformat.txt']);

tbl_c = [ tbl_c_lh; tbl_c_rh];



 tbl_c.Var1 = string(tbl_c.Var1);
 tbl_c.Var2 = string(tbl_c.Var2);

networks = ["Default", "Dors", "Sal" ,"Cont"];


for subjind = 1:length(ID);
    
    subject = ID{subjind};
    
    display(subject);
    
    id=tbl_c(tbl_c.Var1== subject,:);
    
            for network = 1: length(networks);

            net = networks{network} ;
            
            mask = contains(id{:,2}, net);

            mean_net=mean(id{mask,3});
            
            if regexp('Default', net, 'once');
                 Default_all(subjind,:) = mean_net;
            elseif regexp('Dors', net, 'once');
                 Dorsal_all(subjind,:) = mean_net;
            elseif regexp('Sal', net, 'once');
                 Salience_all(subjind,:) = mean_net;
            elseif regexp('Cont', net, 'once');
                 Cont_all(subjind,:) = mean_net;                           
            end                

    
            end   
    
end


                   all_val = table(Default_all, Dorsal_all, Salience_all, Cont_all)
                   
                   writetable(all_val,[target_dir '/cortical.csv'])
                   save([target_dir '/all_val_aroma_abs', 'all_val'])

%                    save([target_dir '/Default_all'],'Default_all');
%                    save([target_dir '/Dorsal_all'],'Dorsal_all');
%                    save([target_dir '/Salience_all'],'Salience_all');
%                    save([target_dir '/Cont_all'],'Cont_all');
                   