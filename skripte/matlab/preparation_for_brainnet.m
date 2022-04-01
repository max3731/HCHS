%% Commands for preparation of matrices for BrainNetViewer
effect_size = 0

global nbs 

nbs.NBS

M = ans.test_stat



%set diagonal in matrix to one
 v = repelem(1,length(M))


 if effect_size

     b = sqrt( 2261)
     M =  M./b
 end

 
 
M = M - diag(diag(M)) + diag(v)

 %save matrix in edge format
 save('m.edge','M','-ascii');
 