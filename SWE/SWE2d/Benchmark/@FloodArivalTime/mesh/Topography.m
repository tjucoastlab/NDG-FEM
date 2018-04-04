fid = fopen('Topography.xyz','w');
alpha = pi/60;
for i = -15:0.1:15
    for j = 0:0.1:1
        fprintf(fid,'%f  %f  %f\n',[i j 1-i*tan(alpha)]);
    end
end
fclose(fid);