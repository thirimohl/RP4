% clear all
% close all
% File = mni.file.F06;
% % help mni.file.F06
% % help mni.file.F06.import
% myfile = mni.file.F06;
% myfile.FileName = 'normal_modes_newmodel.f06';
% results = import(myfile,'ImportAll',true);
% Rotational x y z are fixed.
% E1 gives the eigenvectors but it needed to be looped to include all the eigenvectors corresponding
% to all the eigenvalues. For example, E1 = [results.Eigenvectors(1).T1 results.Eigenvectors(1).T2 results.Eigenvectors(1).T3;
% results.Eigenvectors(2).T1 results.Eigenvectors(2).T2 results.Eigenvectors(2).T3;]
% E2 gives the eigenvalues; E2 = results.Eigenvalues.Eigenvalue
% Need to count the number of modes using; E3 = length(results.Eigenvalues.ModeNo)
% [h5Raw, h5Meta, h5Results] = h5extract;
%% Write a text file: write in a matrix first 
% myfile = 'FEG_xyz.txt';
% fid = fopen(myfile,'w');
% Substract the last mode because it doesnt make sense
function [C] = import2D(h5Raw, h5Meta, h5Results)
E3 = length(h5Results.SUMMARY.EIGENVALUE.EIGEN);
%h5Results.SUMMARY.EIGENVALUE.EIGEN  
E2 = h5Results.SUMMARY.EIGENVALUE.EIGEN;
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
%% Optional for the 2nd grid file to translate the coordinates so that the
%quater chord point is the orgin
GRID(:,1) = GRID(:,1)+0.915;
[C,IA,IC] = unique(GRID,'rows','stable');
T1 = T1(IA,:);
T2 = T2(IA,:);
T3 = T3(IA,:);
%% Write: Actually loop to write the text file 
% count the columns and put the 1 2 3 4 in between
File1 = 'FEG_xyz.cba';
fid   = fopen(File1,'w');
% for the eigenmodes
txt = fprintf(fid,'%1d\n%1s\n%2d\n%2s\n%4e\n',1,'Number of Modes',E3,'eigenvalues:',E2);
txt = fprintf(fid,'%s\n','PLT1');
% Number of grid points
txt = fprintf(fid,'%d\n',length(C));
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
txt = fprintf(fid,'%s \n','grid');
for  j = 1:length(C)
    txt = fprintf(fid,'% 1.9f% 15.9f % 15.9f\n',C(j,1),C(j,2),C(j,3));
end
fclose(fid); 
%% Dont need this 
% dataMAT = [];
% for i =1: length(data)
% dataMAT = [dataMAT;data{i}(1) data{i}(2) data{i}(3);];
% end
% 
% T = dataMAT(IA,:);
% for j = 1:N
%     for the eigenvectors
%     txt = fprintf(fid,'%5d\n',j) 
%     for i = 1:length(T)
%         data = num2cell([T(i,:),T(i,:),T(i,:)], 2)
%     end
%     txt = fprintf(fid,'% 2.9 \n',T{:});
% end

%This is for GRID DATA

end
