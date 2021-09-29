% myscript.m
% Author: Cameron Shock
% Description: Create atom data files for LAMMPS. First construct the
% polymer cell matrix which consists of arrays of whatever atom types you
% want. Next numOfPolymers determines the number of each polymer chain you
% want. The next section is defining all of properties for each atom type
% (each column for each type).


% set size of the simulation box
box = [0.0000,10.0000;0.0000,10.0000;0.0000,10.0000]; %box dimensions

% info based on polymer sets
polymers = {{[1]}}; % each matrix is a different polymer chain, each element of a matrix is the atom type of that particle
numOfPolymers = [100]; %number of each polymer chain
bondTypes = {[1]}; %ignore for now

% info based on atom types (each element is value for that type)
charge = [0];
moment = [0];
diameter = [0];
density = [0];
masses = [18];

% do not touch
position = ones(numel(masses));
molecule = ones(numel(masses));
required = struct('box',box,'masses',masses,'polymers',polymers,'numOfPolymers',numOfPolymers,'bondTypes',bondTypes);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%ion = cell2mat(ions1(i));
filename = ['../Example/example.txt']; 

% order and name of properties needed for this atom type
properties = struct('position',position);

CreateAtoms(required,properties,filename);
    
