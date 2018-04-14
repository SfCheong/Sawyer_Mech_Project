function result = interpolate(data,lost_frames)            
result(1)= data(1);
p=1;
q=1;
while p <=sum(lost_frames)
    while p <= sum(lost_frames(1:q+1))
    result(p+1) = result(p)+((data(q+1)-data(q))/lost_frames(q+1));
    p = p+1;
    end
    q = q+1;
end
end