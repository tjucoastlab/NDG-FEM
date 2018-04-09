type = [NdgCellType.Quad, NdgCellType.Tri];
Num = [1,2,3];
order = [1,2,3,4,5];
for k = 1: numel(type)
    for M = 1:numel(Num)
        for N = 1:numel(order)
            Solver = SWEFlatBotStillWater(order(N),Num(M),type(k));
            Solver.testRhs;
            Solver.testFaceValve;
        end
    end
end