function var = Convection2DSetUp
% 2D convection problem
% dc/dt + udc/dx + vdu/dy = 0

N = 1;
% read triangle mesh
[EToV, VX, VY, EToR, BC] = Utilities.Mesh.MeshReaderTriangle('Convection2D/mesh/rectangle');

tri = StdRegions.Triangle(N);
mesh = MultiRegions.RegionTriBC(tri, EToV, VX, VY, BC);
var = ConvectionInit(mesh);

Speed = [1,0]; % speed of domain, [u, v]
FinalTime = 1;

var = Convection2DSolver(mesh, var, FinalTime, Speed);

postprocess(mesh, var, VX, VY, EToV);
end% func

function postprocess(mesh, var, VX, VY, EToV)

interp = TriScatteredInterp(mesh.x(:), mesh.y(:), var(:));
c = interp(VX, VY);

patch('Faces',EToV,...
    'Vertices',[VX, VY, c],...
    'edgecol','k','facecol',[.8,.9,1])
end% func

function var = ConvectionInit(mesh)
% var = ones(size(mesh.x));
% var = mesh.x;
xc = mean(mesh.x);
left = xc < 0.5; right = xc > 0.5;
% var = sin(pi*mesh.x);%.*sin(2*pi*mesh.y);
var = zeros(size(mesh.x));
var(:,left) = 1; var(:,right) = 0;
end% func