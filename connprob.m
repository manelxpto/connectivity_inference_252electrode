function prob = connprob(target,ref,timewindow)

lt = length(target);
lr = length(ref);

spike_bool = zeros([lt,1]);


for i = 1:lt
    for j = 1:lr
        if abs(ref(j)-target(i)) < timewindow
            
            spike_bool(i) = 1;
        end
    end
end

prob = sum(spike_bool)/sqrt(lt*lr);

end