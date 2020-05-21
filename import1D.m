function [GRID] = import1D(h5Raw, h5Meta, h5Results)

%% Write a text file: write in a matrix first 
% myfile = 'FEG_xyz.txt';
% fid = fopen(myfile,'w');
% Substract the last mode because it doesnt make sense
E3 = length(h5Results.SUMMARY.EIGENVALUE.EIGEN);
%h5Results.SUMMARY.EIGENVALUE.EIGEN  
E2 = h5Results.SUMMARY.EIGENVALUE.EIGEN; %h5Results.SUMMARY.EIGENVALUE.EIGEN  
% txt = fprintf(fid,'%d\n%s\n%d\n%s\n%e\n%s\n%d\n%s\n%d\n%s\n%d%d%d\n%s',...
% 1,'Number of Modes',E3,'eigenvalues:',E2,'PLT1',...
% 2515,'Number of Dof',3,'degrees of freedom (x=1,y=2,z=3,rotx=4,roty=5,rotz=6)',1,2,3,'eigenvectors:')
% fclose(fid);
N = length(h5Results.SUMMARY.EIGENVALUE.EIGEN);
M = length(h5Results.EIGENVECTOR(1).X);
for i = 1:M
    for j = 1:N
% gives 154x20
    T1(i,j) = h5Results.EIGENVECTOR(j).X(i);
    T2(i,j) = h5Results.EIGENVECTOR(j).Y(i);
    T3(i,j) = h5Results.EIGENVECTOR(j).Z(i);
   end 
end 
% you could reshape(T1,3080,1) but still need to write 1 2 3.. inbetween 
% error Index exceeds the number of array elements (153).
% Some how the last mode only has 153 rows => use N-1 to get rid of the
% last mode
%% Input Grid File 
% run(h5extract) 
% The raw data from the extraction .m gives the grid node positions in the 
% colunms. So need to transpose it. After this, just write 
GRID = transpose(h5Raw.NASTRAN.INPUT.NODE.GRID.X);  
%% Write: Actually loop to write the text file 
% count the columns and put the 1 2 3 4 in between
File1 = 'FEG_xyz.cba';
fid   = fopen(File1,'w');
% for the eigenmodes
txt = fprintf(fid,'%1d\n%1s\n%2d\n%2s\n%4e\n',1,'Number of Modes',E3,'eigenvalues:',E2);
txt = fprintf(fid,'%s\n','PLT1');
% Number of grid points
txt = fprintf(fid,'%d\n',M);
txt = fprintf(fid,'%s\n','Number of Dof');
txt = fprintf(fid,'%1d\n',3);
txt = fprintf(fid,'%s\n','degrees of freedom (x=1,y=2,z=3,rotx=4,roty=5,rotz=6)');
txt = fprintf(fid,'%5d%3d%3d\n',1,2,3);
txt = fprintf(fid,'%s\n','eigenvectors:');
for j = 1:N
   % for the eigenvectors
   txt = fprintf(fid,'%5d\n',j); 
   data = num2cell([T1(:,j),T2(:,j),T3(:,j)], 2);
   txt = fprintf(fid,'% 2.9f% 15.9f % 15.9f\n',data{:});
   % for the grids: x,y,z fixed position of the nodesg
end
%This is for GRID DATA
txt = fprintf(fid,'%s \n','grid');
for  j = 1:length(GRID)
    txt = fprintf(fid,'% 1.9f% 15.9f % 15.9f\n',GRID(j,1),GRID(j,2),GRID(j,3));
end
fclose(fid);
end