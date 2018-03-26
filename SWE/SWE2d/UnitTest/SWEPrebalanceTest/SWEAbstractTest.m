classdef SWEAbstractTest < SWEPreBlanaced2d
    %ABSTRACTSWEPREBALANCETEST 此处显示有关此类的摘要
    %   此处显示详细说明
    methods
        function obj = SWEAbstractTest(mesh)
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

