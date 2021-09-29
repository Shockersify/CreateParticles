% MakePositions.m
% Author: Cameron Shock
% Description: Given a matrix containg atom id's and types, a matrix of box
% size, and a matrix of particle diameters randomly place the first
% particle of a polymer chain and use random walk to create the rest.

function positions = MakePositions(atoms, box, diameter)
    positions = ones(size(atoms,1),3);
    posX = box(1,2) * rand();
    posY = box(2,2) * rand();
    posZ = box(3,2) * rand();
    positions(1,:) = [posX, posY, posZ];
    for x = 1:size(atoms,1)
        % for first particle pick random x,y,z
        if x == 1
            posX = box(1,2) * rand();
            posY = box(2,2) * rand();
            posZ = box(3,2) * rand();
        % for subsequent particles use 3D random walk
        else
            oldX = posX;
            oldY = posY;
            oldZ = posZ;
            while 1
                r = diameter(atoms(x,2));
                phi = 2*pi*rand();
                theta = pi*rand();
                posX = posX + r*sin(theta)*cos(phi);
                posY = posY + r*sin(theta)*sin(phi);
                posZ = posZ + r*cos(theta);
                
                
                % check that new position is within box
                if(posX > box(1,1) && posY > box(2,1) && posZ > box(3,1) && posX < box(1,2) && posY < box(2,2) && posZ < box(3,2))
                    break
                % if not reset position and try again
                else
                    posX = oldX;
                    posY = oldY;
                    posZ = oldZ;
                end
            end
        end
        positions(x,:) = [posX, posY, posZ];
    end
end