function SWE2dTest
tol = 1*10^(-10);
for N = 1:5
    M = 2;
    type = NdgCellType.Quad;
    Solver = SWEVolumeIntegral(N,M,type);
    [E, G] = Solver.testVolumeFlux(Solver.fphys{1});
    [Eexact, Gexact] = getExactVolumeFlux(Solver.meshUnion(1),Solver.Nvar,Solver.fphys{1});
    for i = 1:Solver.Nvar
        for j = 1:Solver.meshUnion(1).K
            for k = 1:Solver.meshUnion(1).cell.Np
                assert( abs(E(k,j,i)-Eexact(k,j,i)) <= tol );
                assert( abs(G(k,j,i)-Gexact(k,j,i)) <= tol );
            end
        end
    end
end
end

function [Eexact, Gexact] = getExactVolumeFlux( mesh, Nvar, fphys )
Eexact = zeros(mesh.cell.Np,mesh.K,Nvar);
Gexact = zeros(mesh.cell.Np,mesh.K,Nvar);

Eexact(:,:,1) = fphys(:,:,2);
Eexact(:,1,2) = 0.5 * 9.81 * ( fphys(:,1,1).^2 - fphys(:,1,4).^2 );

Gexact(:,:,1) = fphys(:,:,3);
Gexact(:,1,3) = 0.5 * 9.81 * ( fphys(:,1,1).^2 - fphys(:,1,4).^2 );
end