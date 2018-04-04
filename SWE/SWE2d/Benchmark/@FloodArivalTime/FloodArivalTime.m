classdef FloodArivalTime < SWEPreBlanaced2d
    %FLOODARIVALTIME 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties( Constant )
        hmin = 1e-3
        gra = 9.81
        alpha = pi/60;
    end
    
    properties(SetAccess=private)
        Ng
        xg
        yg
        cellId
        Vg
    end
    
    methods
        function obj = FloodArivalTime(N, M, cellType)
%             [N, M, cellType] = checkinput( varargin );
            [ mesh ] = makeUniformMesh(N, M, cellType );
            obj = obj@SWEPreBlanaced2d();
%             [ obj.Ng, obj.xg, obj.yg ] = setGaugePoint();
%             [ obj.cellId, obj.Vg ] = accessGaugePointMatrix( obj );
            obj.initPhysFromOptions( mesh );
            %             obj.fext = obj.setExtField(  );
        end
        
        function Postprocess(obj)
            
            PostProcess = makeNdgPostProcessFromNdgPhys(obj);
            Ntime = PostProcess.Nt;
            outputTime = ncread( PostProcess.outputFile{1}, 'time' );
            posFront = zeros( Ntime,1 );
            exactPosFront = zeros( Ntime,1 );
            for t = 1:Ntime
                fresult = ncread(PostProcess.outputFile{1}, 'fphys', ...
                    [1, 1, 1, t], [obj.meshUnion(1).cell.Np, obj.meshUnion(1).K, PostProcess.Nvar, 1]);
                h = fresult(:, :, 1);
                index = ( h>=obj.hmin );
                posFront(t) = max( obj.meshUnion(1).x(index) );
                exactPosFront(t) = 2 * outputTime(t) * sqrt(obj.gra * 1 * cos(obj.alpha))...
                    -0.5*obj.gra * outputTime(t)^2 * tan(obj.alpha);
            end
            figure;
            plot(outputTime,posFront,'k','LineWidth',1.5);
            hold on;
            plot(outputTime,exactPosFront,'k--','LineWidth',1.5);
            legend('Simulated','Exact');
%             set(gcf,'position',[1 1 750 463.5]);
            set(gca,'YLim',[0 15],'XLim',[0 2],'Fontsize',15);
            xlabel('time(s)');
            ylabel('front position(m)');       
            
        end
        
        function draw_section( obj )
            %Function used to draw the cross section
            Alpha = obj.alpha;
            time = 0;
            Nintp = 10000; dx = 30/Nintp;
            xd = linspace(-15+dx, 15-dx, Nintp)';
            yd = 0.5*ones(size(xd));
            PostProcess = makeNdgPostProcessFromNdgPhys(obj);
            outputTime = ncread( PostProcess.outputFile{1}, 'time' );
            bot = 1 - xd*tan(Alpha);
            [~,Index] = sort(abs(outputTime-time));
            [ fg ] = PostProcess.interpolateOutputStepResultToGaugePoint(  xd, yd, xd, Index(1) );
            figure;
            plot(xd,fg(:,1)'- bot','k--','Linewidth',1.5);
            hold on;
            plot(xd,- bot','k','Linewidth',1.5);
            legend('water level','bottom');
            set(gca,'Fontsize',15);
            xlabel('x');
            ylabel('surface level, bottom');
        end
    end
    
    methods(Access=protected)
        function fphys = setInitialField( obj )
            fphys = cell( obj.Nmesh, 1 );
            for m = 1:obj.Nmesh
                mesh = obj.meshUnion(m);
                fphys{m} = zeros( mesh.cell.Np, mesh.K, obj.Nfield );
            end
            
            fphys = obj.matInterpolateTopography( fphys );
            for m = 1:obj.Nmesh
                mesh = obj.meshUnion(m);
                temph = 0 -  fphys{m}(:,:,4);   %
                index = any(mesh.x > 0);
                temph(:,index) = 0;
                fphys{m}(:,:,1) = temph;
            end            
%           obj.matUpdateOutputResult( 0, fphys );  
            
        end
        
        function [ option ] = setOption( obj, option )
            obj.ftime = 2;
            outputIntervalNum = 200;
            option('startTime') = 0.0;
            option('finalTime') = obj.ftime;
            option('CFL') = 0.3/obj.meshUnion(1).cell.N;
            option('temporalDiscreteType') = NdgTemporalIntervalType.DeltaTime;
            option('obcType') = NdgBCType.None;
            option('outputIntervalType') = NdgIOIntervalType.DeltaTime;
            option('outputTimeInterval') = obj.ftime/outputIntervalNum;
            option('outputNetcdfCaseName') = mfilename;
            option('temporalDiscreteType') = NdgTemporalDiscreteType.RK45;
            option('limiterType') = NdgLimiterType.Vert;
            option('equationType') = NdgDiscreteEquationType.Strong;
            option('integralType') = NdgDiscreteIntegralType.QuadratureFree;
        end
        
        function fphys = matInterpolateTopography( obj, fphys ) 
            for m = 1:obj.Nmesh
                mesh = obj.meshUnion(m);
                
                tpfile = ...
                     'SWE/SWE2d/Benchmark/@FloodArivalTime/mesh/Topography.xyz';
                fp = fopen(tpfile);
                fgets(fp);
                data = fscanf(fp, '%e %e %e', [3, inf]);
                fclose(fp);
                interp = scatteredInterpolant( ...
                    data(1,:)', data(2,:)', -data(3,:)', 'linear');

                fphys{m}(:,:,4) = interp(mesh.x, mesh.y);
            end
        end% func     
        
    end
end

function [ mesh ] = makeUniformMesh(N, M, type)
bctype = [...
    NdgEdgeType.SlipWall, ...
    NdgEdgeType.SlipWall, ...
    NdgEdgeType.SlipWall, ...
    NdgEdgeType.SlipWall];

xlim = [-15, 15]; Nx = (xlim(2)-xlim(1))/M;
ylim = [0, 1];    Ny = (ylim(2)-ylim(1))/M;


if (type == NdgCellType.Tri)
    mesh = makeUniformTriMesh(N, xlim, ylim, Nx, Ny, bctype);
elseif(type == NdgCellType.Quad)
    mesh = makeUniformQuadMesh(N, xlim, ylim, Nx, Ny, bctype);
else
    msgID = [mfile, ':inputCellTypeError'];
    msgtext = 'The input cell type should be NdgCellType.Tri or NdgCellType.Quad.';
    ME = MException(msgID, msgtext);
    throw(ME);
end
end% func


