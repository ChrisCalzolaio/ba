function [phi_WZ,r_WZ,h_WZ] = WZ(d_WZ, m, al_n, h_a0f, h_f0f, z_WZ)
   be= -atan2(m,d_WZ);
   r_WZ_basis = d_WZ/2 + [-m*h_f0f, m*h_a0f, m*h_a0f,-m*h_f0f];
   h_WZ_basis = tand(al_n)*[-m*h_f0f, m*h_a0f, -m*h_a0f, m*h_f0f] + m*pi/4 *[-1, -1, 1, 1];
   phi_WZ_basis = atan2(h_WZ_basis * sin(be), r_WZ_basis);
   h_WZ_basis = h_WZ_basis * cos(be);

   phi_WZ= ones(z_WZ,1)*phi_WZ_basis + 2*pi*[0:z_WZ-1]'/z_WZ * ones(size(phi_WZ_basis));
   r_WZ= ones(z_WZ,1)*r_WZ_basis;
   h_WZ= ones(z_WZ,1)*h_WZ_basis + m*pi*[0:z_WZ-1]'/z_WZ * ones(size(phi_WZ_basis));

%  [X_WZ, Y_WZ,] = pol2cart(phi_WZ,r_WZ);
%  hold on;
%  axis equal; plot3(X_WZ', Y_WZ', h_WZ')
%  axis equal; plot3(X_WZ, Y_WZ, h_WZ, 'b')
end