classdef ManningFrictionSolver < AbstractFrictionTermSolver
    %MANNINGFRICTIONSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        n
    end
    
    methods
        function obj = ManningFrictionSolver( n )
            obj.n = n;
        end% func
        
        function evaluateFrictionTermRHS( obj, physObj, fphys )
            for m = 1:physObj.Nmesh
                
                mesh = physObj.meshUnion(m);
                ind = (mesh.EToR == int8(NdgRegionType.Wet));
                
                qn  = sqrt( fphys{m}(:,ind,2).^2 + fphys{m}(:,ind,3).^2 );
                % frhs = frhs - rhu   
                physObj.frhs{m}(:,ind,2) = physObj.frhs{m}(:,ind,2)...
                    - obj.n .* physObj.gra * fphys{m}(:,ind,2) .* qn ...
                    ./( fphys{m}(:,ind,1).^(7/3) ) ;
                
                % frhs = frhs - rhv 
                physObj.frhs{m}(:,ind,3) = physObj.frhs{m}(:,ind,3)...
                    - obj.n .* physObj.gra * fphys{m}(:,ind,3) .* qn ...
                    ./( fphys{m}(:,ind,1).^(7/3) ) ;
            end
        end% func
    end
    
end

