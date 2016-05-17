clear

% Params
nb_digits = 3;

% Read confounds
data = niak_read_csv_cell('subject1_session1_motor_n_confounds.tsv');

% Read the html template
 hf = fopen('motion.html','r');
 str_html = fread(hf,Inf,'uint8=>char')';
 fclose(hf);
 
 % Format the data for the javascript figure
 list_col = {1:3,4:6,7:8};
 list_key_replace = {'TSL','ROT','FD'};
 text_write = str_html;
 for ll = 1:length(list_col)
     cols = list_col{ll};
     key_replace = list_key_replace{ll};
     strdata = '';
     for vv = cols
         if vv > cols(1)
             strdata = sprintf('%s,\n',strdata);
         end
         strdata = [strdata '[''' data{1,vv} ''''];   
         for cc = 2:size(data,1)
             val = data{cc,vv};
             pos = strfind(val,'.');
             if isempty(pos);
                 pos = Inf;
             end
             strdata = [strdata ',' val(1:min(length(val),pos+nb_digits)) ' '];
         end
         strdata = [strdata ']'];
     end 
     % Insert data in the template 
     text_write = strrep(text_write,['$' key_replace],strdata);
 end
 
 % Save the figure 
 hf = fopen('motion_subject1.html','w+');
 fprintf(hf,'%s',text_write);
 fclose(hf);