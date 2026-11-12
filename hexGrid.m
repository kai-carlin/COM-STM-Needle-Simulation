function [vertsX,vertsY] = hexGrid(atomicSpacing, size)
% hexGrid
% create hexagonal grid representing atomic lattice structure of hopg graphite

% hexagon dimensions
side = atomicSpacing;
size = atomicSpacing*8;
height = (side/2)/(tan(deg2rad(30)));

% number of points
nx = size/atomicSpacing + 1;
ny = size/atomicSpacing + 2;

vertsX = zeros(nx, ny);
vertsY = zeros(nx, ny);

for vx = 1:nx
    for vy = 1:ny
       % grid positions (centered about origin)
        x0 = (vx-1)*side - size/2;
        y0 = (vy-1)*height - size/2;

        if(mod(vy,2)==0)
            x0 = x0 + side/2;
        end

        vertsX(vx,vy) = x0;
        vertsY(vx,vy) = y0;

    end
end

end

%{

function [X,Y] = hexGrid(spacing, size)

size = spacing*16;
side   = spacing;
height = (side/2)/tan(deg2rad(30));

% number of points
nx = round(size/side);
ny = round(size/height);

X = zeros(ny, nx);
Y = zeros(ny, nx);
Z = zeros(ny, nx);

for iy = 1:ny
    for ix = 1:nx
        
        % base coordinates
        x0 = (ix-1)*side;
        y0 = (iy-1)*height;
        
        % odd rows shift
        if mod(iy,2)==0
            x0 = x0 + side/2;
        end
        
        X(iy,ix) = x0;
        Y(iy,ix) = y0;
        Z(iy,ix) = 0;   % flat plane
    end
end

end
%}