classdef SWEFlatBotStillWater < SWEAbstractTest
    %< In this case, the bottom level is set to 0, and water depth is set
    %< to 1, used to verify the capability to calculate the volume
    %< intergral
    
    properties( Constant )
        hmin = 1e-1
        gra = 9.81
        tol = 1e-10
    end
    
    methods
        function obj = SWEFlatBotStillWater(N,M,type)
            obj = obj@SWEAbstractTest(N,M,type);
        end
        
        function testRhs(obj)
            ExactRhs = obj.getExactRhs;
            Rhs = obj.getRhs;
                for i = 1:obj.Nvar
                    for j = 1:obj.meshUnion(1).K
                        for k = 1:obj.meshUnion(1).cell.Np
                            assert( abs(ExactRhs{1}(k,j,i)-Rhs{1}(k,j,i)) <= obj.tol );
                        end
                    end
                end
        end
        
        function Rhs = getExactRhs(obj)
                Rhs{1} = zeros(obj.meshUnion(1).cell.Np, obj.meshUnion(1).K,...
                    obj.Nvar);
        end
    end
    
    methods(Access=protected)
        function fphys = setInitialField( obj )
            fphys = cell( 1, 1 );
            fphys{1} = zeros( obj.meshUnion(1).cell.Np, obj.meshUnion(1).K, obj.Nfield );
            fphys{1}(:,:,1) = 1;
        end% func
    end
end

