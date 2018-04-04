classdef SWEAbstractTest < SWEConventional2d
    %ABSTRACTSWEPREBALANCETEST 此处显示有关此类的摘要
    %   此处显示详细说明
    methods
        function obj = SWEAbstractTest(N,M,type)
            mesh = makeUniformMesh(N,M,type);
            obj = obj@SWEConventional2d();
            obj.initPhysFromOptions( mesh );
        end
        
        function [E, G] = getVolumeFlux(obj, fphys)
            [E, G] = obj.matEvaluateFlux(obj.meshUnion(1),fphys);
        end
        
        function [ fM, fP ] = getFaceValue(mesh,fphys,fext)
            [ fM, fP ] = obj.matEvaluateSurfaceValue( mesh, fphys, fext );
        end
        
        function [fluxM] = getFaceFlux( hmin, gra, nx, ny, fm)
            [fluxM] = obj.mxEvaluateSurfFlux( hmin, gra, nx, ny, fm);
        end
        
        function [fluxS] = getNumFlux( hmin, gra, nx, ny, fm, fp )
            [fluxS] = obj.numfluxSolver.evaluate( hmin, gra, nx, ny, fm, fp );
        end
        
        function [dt] = getTimeStep(fphys)
            [dt] = obj.matUpdataTimeInterval(fphys);
        end
        
        function [ ] = getTopographySourceTerm(fphys)
            [~] = obj.matEvaluateTopographySourceTerm(fphys);
        end
        
        function [] = getCoriolisTerm(fphys)
            [~] = obj.coriolisSolver.evaluateCoriolisTermRHS( fphys);
        end
        
        function [] = getWindForceTerm(fphys)
            [~] = obj.windSolver.evaluateWindTermRHS(fphys);
        end
        
        function [] = getBottomFrictionTerm(fphys)
            [~] = obj.frictionSolver.evaluateFrictionTermRHS(fphys);
        end
        
        function Rhs  = getRhs(obj)
            [E, G] = obj.getVolumeFlux(obj.fphys{1});
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
        M, M, bctype);
elseif(type == NdgCellType.Quad)
    mesh = makeUniformQuadMesh(N, [-1, 1], [-1, 1], ...
        M, M, bctype);
else
    msgID = [mfilename, ':inputCellTypeError'];
    msgtext = ['The input cell type should be NdgCellType.Tri',...
        ' or NdgCellType.Tri.'];
    ME = MException(msgID, msgtext);
    throw(ME);
end
end% func

