function velocity = calc_velocity(data,time_total)
velocity(1) = 0;
period      = time_total/(size(data,2)-1)
q           = 1;
while q<size(data,2)   
    velocity(q+1) = (data(q+1)-data(q))/period;
    
    q = q+1;
end

end