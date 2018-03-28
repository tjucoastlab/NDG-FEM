%> @brief Standard line class.
%
%> And here we can put some more detailed informations about the class.
% ======================================================================
%> This class is part of the NDGOM software. 
%> @author li12242, Tianjin University, li12242@tju.edu.cn
% ======================================================================
classdef StdLine < StdCell
    properties(Constant)
        type = NdgCellType.Line
        Nv = 2
        LAV = 2
        vr = [-1, 1]'
        vs = [ 0, 0]'; 
        vt = [ 0, 0]'; 
        Nfv = [1, 1]';
        FToV = [1,2];
        Nface = 2;
        faceType = [NdgCellType.Point, NdgCellType.Point];
    end
    
    methods(Access=protected)
        function [Np,r,s,t] = node_coor_func(obj, N)
            Np = N+1;
            [ r,~ ] = zwglj(Np);
            s = zeros(Np, 1);
            t = zeros(Np, 1);
        end
        
        function [dr, ds, dt] = derivative_orthogonal_func(obj, N, ind, r, s, t)
            dr = GradJacobiP(r, 0, 0, ind-1);
            ds = zeros(obj.Np, 1);
            dt = zeros(obj.Np, 1);
        end

        function [ Nq,rq,sq,tq,wq ] = quad_coor_func(obj, N)
            Nq = N+1;
            [ rq, wq ] = zwglj( Nq );
            sq = zeros(Nq, 1);
            tq = zeros(Nq, 1);
        end
        
%         function [ M, invM ] = assembleMassMatrix( obj )
%             [ ~, rq, sq, tq, wq ] = obj.quad_coor_func( 2*obj.N );
%             [ fq ] = nodal_func( obj, rq, sq, tq );
%             M = zeros( obj.Np, obj.Np );
%             for n = 1:obj.Np
%                 for m = 1:obj.Np
%                     M(n, m) = sum( wq(:) .* fq(:, m) .* fq(:, n) );
%                 end
%             end
%             invM = inv(M);
%         end% func
    end
    
    methods
        function obj = StdLine(N)
            obj = obj@StdCell(N);
        end
        
        function [ nx, ny, nz, Js ] = assembleNormalVector( obj, x, y, z )
            xr = obj.Dr * x;
            
            nr = [-1, 1]';
            nx = 1./xr( obj.Fmask(:),: ) .* nr;
            nx = nx ./ sqrt( nx.^2 ); 
            Js = ones( size(nx) );
            
            ny = zeros( size(nx) );
            nz = zeros( size(nx) );
        end
        
        function [ rx, ry, rz, sx, sy, sz, tx, ty, tz, J ] = assembleJacobianMatrix( obj, x, y, z )
            xr = obj.Dr * x;
            J = xr; rx = 1./J;
            
            ry = ones( size(x) );
            rz = ones( size(x) );
            sx = ones( size(x) );
            sy = ones( size(x) );
            sz = ones( size(x) );
            tx = ones( size(x) );
            ty = ones( size(x) );
            tz = ones( size(x) );
        end
        
        function f = orthogonal_func(obj, N, ind, r, s, t)
            f = JacobiP(r, 0, 0, ind-1);
        end% func
        
        function node_val = project_vert2node(obj, vert_val)
            node_val = 0.5*((1-obj.r)*vert_val(1,:) + (1+obj.r)*vert_val(2,:));
        end
        
    end% methods
    
end

