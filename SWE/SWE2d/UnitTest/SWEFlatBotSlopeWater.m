classdef SWEFlatBotSlopeWater < SWEAbstractTest
    %< In this case, the bottom level is set to 0, and water depth is
    %< variable, with h(x) = 5 - x, used to verify the capability to
    %< calculate the volume integral
    
    properties( Constant )
        hmin = 1e-1
        gra = 9.81
        tol = 1e-10
    end
    
    methods
        function obj = SWEFlatBotSlopeWater(N,M,type)
            obj = obj@SWEAbstractTest(N,M,type);
        end
        
        function test(obj)
            ExactRhs = obj.getExactRhs;
            Rhs = obj.getRhs;
            for i = 1:obj.Nvar
                for j = 1:obj.meshUnion(1).K
                    for k = 1:obj.meshUnion(1).cell.Np
                        assert( abs(ExactRhs{1}(k,j,i)+Rhs{1}(k,j,i)) <= obj.tol );
                    end
                end
            end
            
            [ExactfM, ExactfP] = obj.getExactFaceValue;
            [fM, fP] = obj.getFaceValue(obj.meshUnion(1),obj.fphys{1},obj.fext{1});
            for i = 1:obj.Nvar
                for j = 1:obj.meshUnion(1).K
                    for k = 1:obj.meshUnion(1).cell.TNfp
                        assert( abs(ExactfM(k,j,i)-fM(k,j,i)) <= obj.tol );
                        assert( abs(ExactfP(k,j,i)-fP(k,j,i)) <= obj.tol );
                    end
                end
            end
        end
        
        function Rhs = getExactRhs(obj)
            Rhs{1} = zeros(obj.meshUnion(1).cell.Np, obj.meshUnion(1).K,...
                obj.Nvar);
            Rhs{1}(:,:,2) = -1 * obj.gra * obj.fphys{1}(:,:,1);
        end
        
        function [ExactfM, ExactfP] = getExactFaceValue(obj)
            ExactfM = zeros( obj.meshUnion(1).cell.TNfp, obj.meshUnion(1).K, obj.Nfield );
            ExactfP = zeros( obj.meshUnion(1).cell.TNfp, obj.meshUnion(1).K, obj.Nfield );
            ExactfM(:,:,1) = 5 - obj.meshUnion(1).x(obj.meshUnion(1).eidM);
            ExactfP(:,:,1) = 5 - obj.meshUnion(1).x(obj.meshUnion(1).eidP);
        end 
        
    end
    
    methods(Access=protected)
        function fphys = setInitialField( obj )
            fphys = cell( 1, 1 );
            fphys{1} = zeros( obj.meshUnion(1).cell.Np, obj.meshUnion(1).K, obj.Nfield );
            fphys{1}(:,:,1) = 5 - obj.meshUnion(1).x;
        end% func
    end
end

