p       = 1;
pos_arr = [0 0 0 0 0 0 0];
[fileName, pathName] = uigetfile('*.mat','Select interpolated data');
load(fileName);
while p <= size(interp_list.pos_j01_interp,2)  
        %pos_seq is array contains all joints' position at same time
        %example: pos_seq(1) is the first position of all joints
        pos_seq(1) = interp_list.pos_j01_interp(p);
        pos_seq(2) = interp_list.pos_j02_interp(p);
        pos_seq(3) = interp_list.pos_j03_interp(p);
        pos_seq(4) = interp_list.pos_j04_interp(p);
        pos_seq(5) = interp_list.pos_j05_interp(p);
        pos_seq(6) = interp_list.pos_j06_interp(p); 
        pos_seq(7) = interp_list.pos_j07_interp(p);
        
        vel_seq(1) = interp_list.vel_j01_calc_60(p);
        vel_seq(2) = interp_list.vel_j02_calc_60(p);
        vel_seq(3) = interp_list.vel_j03_calc_60(p);
        vel_seq(4) = interp_list.vel_j04_calc_60(p);
        vel_seq(5) = interp_list.vel_j05_calc_60(p);
        vel_seq(6) = interp_list.vel_j06_calc_60(p);
        vel_seq(7) = interp_list.vel_j07_calc_60(p);
        
        eff_seq(1) = interp_list.eff_j01_interp(p);
        eff_seq(2) = interp_list.eff_j02_interp(p);
        eff_seq(3) = interp_list.eff_j03_interp(p);
        eff_seq(4) = interp_list.eff_j04_interp(p);
        eff_seq(5) = interp_list.eff_j05_interp(p);
        eff_seq(6) = interp_list.eff_j06_interp(p);
        eff_seq(7) = interp_list.eff_j07_interp(p);
        
        pos_arr(p,:) = pos_seq;
        vel_arr(p,:) = vel_seq;
        eff_arr(p,:) = eff_seq;
        p = p+1;
end

%%
id_field    = 'id';
position = 'position';
velocity = 'velocity';
effort   = 'effort';

q=1;
while q <= size(interp_list.pos_j01_interp,2)
id_val  = interp_list.id_interp(q);
pos_val = pos_arr(q,:);
vel_val = vel_arr(q,:);
eff_val = eff_arr(q,:);
s=struct(id_field,id_val,position,pos_val,velocity,vel_val,effort,eff_val);
list_send(q) = s;
q=q+1;
end
%%
[interpFileName,savePathName]=uiputfile('jointStateList_sendFormat.mat','Save interpolate Data in send-format')
save(interpFileName,'list_send');
