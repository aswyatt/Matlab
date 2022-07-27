function dirname = find_folder(dirnames)
% find_folder: Finds and returns the first folder that exists from a given list
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)


exists = 0;

%   Find where data is stored
for nd=1:length(dirnames)
    if exist(dirnames{nd}, 'dir')
       dirname = dirnames{nd};
	   exists = 1;
       break;
    end
end

if ~exists
	error('Could not find folder');
end
