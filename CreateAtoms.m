% CreateAtoms.m
% Author: Cameron Shock
% Description: Create atom data files for LAMMPS. Use the myscript.m file
% or your own as an interface with this function. Parameters required and
% properties are structs and filename is a string.
% required must contain: box, masses, polymers, numOfPolymers, bondTypes.
% properties contains the properties of each particle type.

function atoms = CreateAtoms(required,properties,filename)

    % MAIN PART OF CODE DO NOT TOUCH*********************************

    bondType = 1;
    atomTypes = max(cell2mat(required.polymers));
    totalcolumns = numel(fieldnames(properties)) + 2;
    if any(strcmp(fieldnames(properties),'position'))
        totalcolumns = totalcolumns + 2;
    end
    if any(strcmp(fieldnames(properties),'moment'))
        totalcolumns = totalcolumns + 2;
    end

    % start particle id sequence
    atomMatrix = [];
    bondMatrix = [];
    id = 1;
    lastID = 0;
    offset = 0;

    ion = -1.0;
    % for each polymer chain
    for polymer = 1:numel(required.polymers)
        % for the total number of this particular polymer chain
        for n = 1:required.numOfPolymers(polymer)
            % initialize matrix holding polymer group info
            polymerGroupInfo = ones(numel(cell2mat(required.polymers(polymer))),totalcolumns);
            % for each element in this particular polymer chain
            for element = 1:numel(cell2mat(required.polymers(polymer)))
                types = cell2mat(required.polymers(polymer));
                
                %polymerGroupInfo(element,:) = [id, types(element)];
                info = [id, types(element)];
                propertyFields = (fieldnames(properties));
                propertyValues = struct2cell(properties);
                momentPosition = 0;
                prop = 2;
                for property = 1:numel(propertyFields)
                    prop = prop + 1;
                    pVal = cell2mat(propertyValues(property));
                    thing = pVal(types(element));
                    if isequal(cell2mat(propertyFields(property)), 'position')
                        thing = [1,1,1];
                        positionPosition = prop;
                        prop = prop + 2;
                    end
                    if isequal(cell2mat(propertyFields(property)), 'moment')
                        thing = [1,1,1];
                        momentPosition = prop;
                        prop = prop + 2;
                    end
                    if isequal(cell2mat(propertyFields(property)), 'molecule')
                        thing = n+offset;
                    end
                    info = [info thing];
                    
                end
                
                % create the polymer group info matrix holding all information
                % about each particle
                polymerGroupInfo(element,:) = info;
                id = id + 1;
            end

            % randomly generate positions and moments then create bond
            % matrix
            if isfield(required,'ionspace') && polymer >= numel(required.polymers)-1
                positions = MakePositionsIonSplit(polymerGroupInfo(:,1:2), required.box, properties.diameter,required.ionspace,ion);
                ion = 1.0;
            elseif isfield(properties,'diameter')
                positions = MakePositions(polymerGroupInfo(:,1:2), required.box, properties.diameter);
            else
                positions = MakePositions(polymerGroupInfo(:,1:2), required.box, ones(atomTypes,1));
            end
            polymerGroupInfo(:,positionPosition:positionPosition+2) = positions;
            if momentPosition ~= 0
                moments = MakeMoments(polymerGroupInfo(:,1:2), properties.moment);
                polymerGroupInfo(:,momentPosition:momentPosition+2) = moments;
            end
            bonds = MakeBonds(polymerGroupInfo(:,1), bondType, lastID);
            if size(bonds,1) > 0
                lastID = bonds(end,1);
            end

            % replace initialization data in polymer group info with actual

            atomMatrix = [atomMatrix;polymerGroupInfo];
            bondMatrix = [bondMatrix;bonds];
        end
        offset = offset + required.numOfPolymers(polymer);
    end

    MakeFile(atomMatrix,bondMatrix,atomTypes,bondType,required.masses,required.box,filename);

    % END OF UNTOUCHABLE CODE**************************************

end