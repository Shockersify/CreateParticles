% MakeFile.m
% Author: Cameron Shock
% Description: Given all of the matrices containg the atom information and
% all other info (should hopefully be obvious) create the atom data file
% for LAMMPS.

function file = MakeFile(atomMatrix, bondMatrix, atomTypes, bondTypes, masses, box, filename)
    %generate file
    fileID = fopen(filename,'w');
    fprintf(fileID,'# Model for \n\n');
    fprintf(fileID,'%d\tatoms\n', atomMatrix(end,1));
    if(size(bondMatrix,1) > 0)
        fprintf(fileID,'%d\tbonds\n\n', bondMatrix(end,1));
    else
        fprintf(fileID,'%d\tbonds\n\n', 0);
    end
    fprintf(fileID,'%d\tatom types\n', atomTypes);
    fprintf(fileID,'%d\tbond types\n\n', bondTypes);
    fprintf(fileID,'%f\t%f\txlo xhi\n',box(1,1),box(1,2));
    fprintf(fileID,'%f\t%f\tylo yhi\n',box(2,1),box(2,2));
    fprintf(fileID,'%f\t%f\tzlo zhi\n',box(3,1),box(3,2));
    fprintf(fileID,'\n\nMasses\n\n');
    for i = 1:size(masses,2)
        fprintf(fileID,'%d\t%f\n',i,masses(i));
    end
    fprintf(fileID,'\n\nAtoms\n\n');
    % for each atom
    for i = 1:atomMatrix(end,1)
        fprintf(fileID,'%d\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%d\n',atomMatrix(i,1),atomMatrix(i,2),atomMatrix(i,3),atomMatrix(i,4),atomMatrix(i,5),atomMatrix(i,6),atomMatrix(i,7),atomMatrix(i,8),atomMatrix(i,9),atomMatrix(i,10),atomMatrix(i,11),atomMatrix(i,12));
    end
    % if bonds exist create the bonds section for each bond
    if(size(bondMatrix,1) > 0)
        fprintf(fileID,'\n\nBonds\n\n');
        for i = 1:bondMatrix(end,1)
            fprintf(fileID,'%d\t%d\t%d\t%d\n',bondMatrix(i,1),bondMatrix(i,2),bondMatrix(i,3),bondMatrix(i,4));
        end
    end
    fclose(fileID);
end