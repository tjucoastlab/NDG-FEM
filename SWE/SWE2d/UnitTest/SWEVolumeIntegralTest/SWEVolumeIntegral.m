classdef SWEVolumeIntegral < SWEAbstractTest
    %SWEVOLUMEINTEGRAL 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
    end
    
    methods 
        function obj = SWEVolumeIntegral()
            
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
                bot = fphys{m}(:, :, 4);
                
%                 h = 100 - fphys{m}(:, :, 4);
%                 ind = (mesh.EToR == int8(NdgRegionType.Dry) );
%                 h(:, ind) = 0;
                
                h = zeros(mesh.cell.Np, mesh.K);
                dam_x = [4701.18,4656.5]; 
                dam_y = [4143.41,4392.1];
                k = (dam_y(2)-dam_y(1))/(dam_x(2)-dam_x(1));
                flag = mesh.y - dam_y(1) - k*( mesh.x - dam_x(1) );
                I = find( flag <= 0 );
                h(I) = 100 - bot(I);
                
                I = ( abs( mesh.y - 5250 ) < 150 ) & ...
                    ( abs( mesh.x - 4500 ) < 200 );
                h(I) = 0;
%                 h(:, ind) = 0 - fphys{m}(:, ind, 4);
%                 h( h < 0 ) = 0;
                fphys{m}(:, :, 1) = h;
            end
        end% func
    end
end