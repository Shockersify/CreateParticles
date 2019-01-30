% MakeMoments.m
% Author: Cameron Shock
% Description: Given a matrix of atom id's and types and a matrix of the
% dipole moments for each type, create a matrix giving random dipole moment
% directions to the atoms.

function moments = MakeMoments(atoms, moment)
    moments = ones(size(atoms,1),3);
    for p = 1:size(atoms,1) 
       phi = 2*pi*rand();
       theta = pi*rand();
       x = moment(atoms(p,2))*sin(theta)*cos(phi);
       y = moment(atoms(p,2))*sin(theta)*sin(phi);
       z = moment(atoms(p,2))*cos(theta);
       moments(p,:) = [x,y,z];
    end
end