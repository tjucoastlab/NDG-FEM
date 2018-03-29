classdef SWEAbstractTest < SWEPreBlanaced2d
    %ABSTRACTSWEPREBALANCETEST 此处显示有关此类的摘要
    %   此处显示详细说明
    methods
        function obj = SWEAbstractTest(N,M,type)
            mesh = makeUniformMesh(N,M,type);
            obj = obj@SWEPreBlanaced2d();
            obj.initPhysFromOptions( mesh );
        end
        
        function PrivateFunctionTest(obj)
        %> determine time interval
        [ ~ ] = matUpdateTimeInterval( obj, fphys );
        
        %> evaluate source term
        [~] = matEvaluateSourceTerm( obj, fphys );
        
        %> evaluate topography source term
        [~] = matEvaluateTopographySourceTerm( obj, fphys );
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

