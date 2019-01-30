% CreateAtoms.m
% Author: Cameron Shock
% Description: Create atom data files for LAMMPS. First construct the
% polymer cell matrix which consists of arrays of whatever atom types you
% want. Next numOfPolymers determines the number of each polymer chain you
% want. The next section is defining all of properties for each atom type
% (each column for each type). Next you can do anything before or after the
% main loop but the main loop should remain untouched unless you know what
% you're doing (like you need to change a certain variable). It will then
% create the atom data files you want.

box = [0.0000,10.0000;0.0000,10.0000;0.0000,10.0000]; %box dimensions
% info based on polymer sets
polymers = {[1],[2]};
numOfPolymers = [10, 10];
bondTypes = 0;
atomTypes = max(cell2mat(polymers));


% info based on atom types
charge = [9.3571, -9.3571];
moment = [0.3896, 0.3896];
diameter = [2.4, 1.8];
density = [1, 1];
masses = [50, 50];


for m = 0.5:0.5:5
    momentUSE = m*moment;
    filename = ['../IonicLiquids/Solvation9A12C14/atoms' num2str(m*10,'%02d') 'D1E.txt'];

    
    % MAIN PART OF CODE DO NOT TOUCH*********************************

    % start particle id sequence
    atomMatrix = [];
    bondMatrix = [];
    id = 1;
    lastID = 0;
    offset = 0;

    % for each polymer chain
    for polymer = 1:numel(polymers)
        % for the total number of this particular polymer chain
        for n = 1:numOfPolymers(polymer)
            % initialize matrix holding polymer group info
            polymerGroupInfo = ones(numel(cell2mat(polymers(polymer))),12);
            % for each element in this particular polymer chain
            for element = 1:numel(cell2mat(polymers(polymer)))
                types = cell2mat(polymers(polymer));

                % create the polymer group info matrix holding all information
                % about each particle
                polymerGroupInfo(element,:) = [id, types(element), 1, 1, 1, diameter(types(element)), density(types(element)), charge(types(element)), 1, 1, 1, n + offset];
                id = id + 1;
            end
            
            % randomly generate positions and moments then create bond
            % matrix
            positions = MakePositions(polymerGroupInfo(:,1:2), box, diameter);
            moments = MakeMoments(polymerGroupInfo(:,1:2), momentUSE);
            bonds = MakeBonds(polymerGroupInfo(:,1), bondTypes, lastID);
            if size(bonds,1) > 0
                lastID = bonds(end,1);
            end

            % replace initialization data in polymer group info with actual
            polymerGroupInfo(:,3:5) = positions;
            polymerGroupInfo(:,9:11) = moments;
            atomMatrix = [atomMatrix;polymerGroupInfo];
            bondMatrix = [bondMatrix;bonds];
        end
        offset = offset + numOfPolymers(polymer);
    end
    
    MakeFile(atomMatrix,bondMatrix,atomTypes,bondTypes,masses,box,filename);
    
    % END OF UNTOUCHABLE CODE**************************************
    
end