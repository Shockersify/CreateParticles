% MakeBonds.m
% Author: Cameron Shock
% Description: For a given matrix of atom id's, int of bondType, and int of
% last particle id, create a matrix of the bond connection info for given
% atoms.

function bonds = MakeBonds(atoms, bondType, lastID)
    bonds = [];
    if size(atoms,1) > 1
        bonds = ones(size(atoms,1)-1,4);
        for x = 1:size(atoms,1)-1
            bonds(x,:) = [x+lastID, bondType, atoms(x), atoms(x+1)];
        end
    end
end