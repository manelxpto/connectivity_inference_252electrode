function finaltimedif = timehistogram(target,ref,timewindow)
l1 = length(target);
l2 = length(ref);

timewindow = 20;

timedif = zeros([l1*l2,1]);

for i = 1:l1
    for j = 1:l2
        timedif((i-1)*l2+j) = target(i) - ref(j);
    end
end

timedifround = round(timedif);

indices = zeros([length(timedifround),1]);

for k = 1:length(timedifround)
    if abs(timedifround(k)) > timewindow
        indices(k) = k;
    end
end

finaltimedif = timedifround;

indices = nonzeros(indices);

finaltimedif(indices) = [];

nbins = max(finaltimedif) - min(finaltimedif);

hist(finaltimedif,nbins);
end