stim = 1;
for i = 1:100
    
    x = rand(3*10,1);
    CW(i) = sum(x<=0.67);
    ACW(i) = sum(x>0.67);

end

mean(CW)
mean(ACW)
%%
nstim = (3*9)*50
s = 0.150*nstim;
min = s/60


