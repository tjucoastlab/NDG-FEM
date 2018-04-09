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
            obj.Assert(ExactRhs{1}, Rhs{1});
        end
        
        function testFaceValve(obj)
            [ExactfM, ExactfP] = obj.getExactFaceValue;
            [fM, fP] = obj.matEvaluateSurfaceValue(obj.meshUnion(1),obj.fphys{1},obj.fext{1});
            obj.Assert(ExactfM, fM);
            obj.Assert(ExactfP, fP);
        end
        
        function Rhs = getExactRhs(obj)
            Rhs{1} = zeros(obj.meshUnion(1).cell.Np, obj.meshUnion(1).K,...
                obj.Nvar);
        end
        
        function [ExactfM, ExactfP] = getExactFaceValue(obj)
            ExactfM = zeros( obj.meshUnion(1).cell.TNfp, obj.meshUnion(1).K, obj.Nvar );
            ExactfP = zeros( obj.meshUnion(1).cell.TNfp, obj.meshUnion(1).K, obj.Nvar );
            ExactfM(:,:,1) = 1;ExactfP(:,:,1) = 1;
        end
    end
    
    methods(Access=protected)
        function fphys = setInitialField( obj )
            fphys = cell( 1, 1 );
            fphys{1} = zeros( obj.meshUnion(1).cell.Np, obj.meshUnion(1).K, obj.Nfield );
            fphys{1}(:,:,1) = 1;
        end% func
        
        function Assert(obj, Exact, Numerical )
            checkinput( Exact, Numerical);
            Ind1 = size(Exact,1);Ind2 = size(Exact,2);Ind3 = size(Exact,3);
            for i = 1:Ind1
                for j = 1:Ind2
                    for k = 1:Ind3
                        assert( abs(Exact(i,j,k)- Numerical(i,j,k)) <= obj.tol );
                    end
                end
            end
        end
        
        function Rhs  = getRhs(obj)
            [E, G] = obj.matEvaluateFlux(obj.meshUnion(1),obj.fphys{1});
            for i = 1:obj.Nvar
                [ obj.frhs{1}(:,:,i) ] = ...
                    - obj.advectionSolver.rx{1}.*( obj.advectionSolver.Dr{1} * E(:,:,i) ) ...
                    - obj.advectionSolver.sx{1}.*( obj.advectionSolver.Ds{1} * E(:,:,i) ) ...
                    - obj.advectionSolver.ry{1}.*( obj.advectionSolver.Dr{1} * G(:,:,i) ) ...
                    - obj.advectionSolver.sy{1}.*( obj.advectionSolver.Ds{1} * G(:,:,i) ) ;
            end
            obj.matEvaluateSourceTerm(obj.fphys);
            Rhs = obj.frhs;
        end
    end
end

function checkinput( Exact, Numerical)
if  sum(size(Exact) ~= size(Numerical))
    msgID = [ mfilename, ':MatrixSize mismatch'];
    msgtext = ('The matrix size is not equal, check again');
    throw( MException(msgID, msgtext) );
end
end
