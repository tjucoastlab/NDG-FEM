classdef SWEVolumeIntegral < SWEAbstractTest
    %SWEVOLUMEINTEGRAL �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties( Constant )
        hmin = 1e-1
        gra = 9.81
    end
    
    methods
        function obj = SWEVolumeIntegral(N,M,type)
            obj = obj@SWEAbstractTest(N,M,type);
        end
    end
    
    methods(Access=protected)
        function fphys = setInitialField( obj )
            fphys = cell( 1, 1 );
            fphys{1} = zeros( obj.meshUnion(1).cell.Np, obj.meshUnion(1).K, obj.Nfield );
            fphys{1}(:,1,1) = 1;
        end% func
    end
end

