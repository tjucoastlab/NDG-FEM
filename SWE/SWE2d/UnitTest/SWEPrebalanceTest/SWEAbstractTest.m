classdef SWEAbstractTest < SWEPreBlanaced2d
    %ABSTRACTSWEPREBALANCETEST 此处显示有关此类的摘要
    %   此处显示详细说明
    methods
        function obj = SWEAbstractTest(N,M,type)
            mesh = makeUniformMesh(N,M,type);
            obj = obj@SWEPreBlanaced2d();
            obj.initPhysFromOptions( mesh );
        end
        
        function [E, G] = testVolumeFlux(obj, fphys)
            [E, G] = obj.matEvaluateFlux(obj.meshUnion(1),fphys);
        end
        
        function [ fM, fP ] = testFaceValue(mesh,fphys,fext)
            [ fM, fP ] = obj.matEvaluateSurfaceValue( mesh, fphys, fext );
        end
        
        function [fluxM] = testFaceFlux( hmin, gra, nx, ny, fm) 
           [fluxM] = obj.mxEvaluateSurfFlux( hmin, gra, nx, ny, fm);
        end
        
        function [fluxS] = testNumFlux( hmin, gra, nx, ny, fm, fp )
            [fluxS] = obj.numfluxSolver.evaluate( hmin, gra, nx, ny, fm, fp );
        end
        
        function [dt] = testTimeStep(fphys)
            [dt] = obj.matUpdataTimeInterval(fphys);
        end
        
        function [ ] = testTopographySourceTerm(fphys)
            [~] = obj.matEvaluateTopographySourceTerm(fphys);
        end
        
        function [] = testCoriolisTerm(fphys)
            [~] = obj.coriolisSolver.evaluateCoriolisTermRHS( fphys);
        end
        
        function [] = testWindForceTerm(fphys)
            [~] = obj.windSolver.evaluateWindTermRHS(fphys);
        end
        
        function [] = testBottomFrictionTerm(fphys)
            [~] = obj.frictionSolver.evaluateFrictionTermRHS(fphys);
        end

    end
    
    methods(Access=protected)
        
        function [ option ] = setOption( ~, option )
            ftime = 20;
            outputIntervalNum = 50;
            option('startTime') = 0.0;
            option('finalTime') = ftime;
            option('obcType') = NdgBCType.None;
            option('outputIntervalType') = NdgIOIntervalType.DeltaTime;
            option('outputTimeInterval') = ftime/outputIntervalNum;
            option('outputNetcdfCaseName') = mfilename;
            option('temporalDiscreteType') = NdgTemporalDiscreteType.RK45;
            option('limiterType') = NdgLimiterType.Vert;
            option('equationType') = NdgDiscreteEquationType.Strong;
            option('integralType') = NdgDiscreteIntegralType.QuadratureFree;
        end
    end
    
end

function mesh = makeUniformMesh(N, M, type)
bctype = [NdgEdgeType.Clamped, NdgEdgeType.Clamped, ...
    NdgEdgeType.Clamped, NdgEdgeType.Clamped];

if (type == NdgCellType.Tri)
    mesh = makeUniformTriMesh(N, [-1, 1], [-1, 1], ...
        M, M-1, bctype);
elseif(type == NdgCellType.Quad)
    mesh = makeUniformQuadMesh(N, [-1, 1], [-1, 1], ...
        M, M-1, bctype);
else
    msgID = [mfilename, ':inputCellTypeError'];
    msgtext = ['The input cell type should be NdgCellType.Tri',...
        ' or NdgCellType.Tri.'];
    ME = MException(msgID, msgtext);
    throw(ME);
end
end% func

