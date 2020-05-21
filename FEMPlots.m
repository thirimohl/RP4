
%% 1D MODEL
% [h5Raw, h5Meta, h5Results] = h5extract('sol103_fully_fixed_new.h5');
% [h5Raw, h5Meta, h5Results] = h5extract('NewModelWoXsection.h5');
[h5Raw, h5Meta, h5Results] = h5extract('wingbox_14mm.h5');
[GRID] = import1D(h5Raw, h5Meta, h5Results);
% figure
% s1 = scatter3(GRID(:,1),GRID(:,2),GRID(:,3),'r')
% s1.LineWidth = 2;
% axis equal
% % s1.MarkerEdgeColor = '#0072BD'
% set(gca,'visible','off')
% hold on 
% plot3(GRID(51,1),GRID(51,2),GRID(51,3),'x')

% %% 2D MODEL
% [h5Raw, h5Meta, h5Results] = h5extract('24BeamAerofoil.h5');
% [h5Raw, h5Meta, h5Results] = h5extract('NewModelWithXsection.h5');
% [C] = import2D(h5Raw, h5Meta, h5Results);
% 
% %Plot Function
% Beam = [C(1:51,1) C(1:51,2) C(1:51,3);C(5050:5151,1) C(5050:5151,2) C(5050:5151,3)];
% Profile = [C(52:5049,1) C(52:5049,2) C(52:5049,3)];
% figure
% s1 = scatter3(Beam(:,1),Beam(:,2),Beam(:,3),'r')
% s1.LineWidth = 4
% axis equal
% hold on
% s2 = scatter3(C(:,1),C(:,2),C(:,3),'g')
% 
% s2.MarkerEdgeColor = '#0072BD'
% set(gca,'visible','off')