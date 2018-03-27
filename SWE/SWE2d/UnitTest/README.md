\page SWE SWE2D unittest

# 1. 测试的函数

Sealed：

1.体通量函数：[ E, G ] = matEvaluateFlux( obj, mesh, fphys )；

2.边界内外值计算函数：[ fM, fP ] = matEvaluateSurfaceValue( obj, mesh, fphys, fext )；

3.面通量函数：[ fluxM ] = mxEvaluateSurfFlux( obj.hmin, obj.gra, nx, ny, fm)；

4.面数值通量函数：[ fluxS ] = obj.numfluxSolver.evaluate( obj.hmin, obj.gra, nx, ny, fm, fp );

5.更新时间步函数：[ dt ] = matUpdateTimeInterval( obj, fphys )；

Abstract：

1.PostFunction函数：[ fphys ] = matEvaluatePostFunc(obj, fphys)；

2.更新干湿状态函数：matUpdateWetDryState(obj, fphys)；

3.源项函数：[ ] = matEvaluateSourceTerm( obj, fphys )；
包括：
3.1底坡源项函数：obj.matEvaluateTopographySourceTerm( fphys );
3.2科氏力项函数：obj.coriolisSolver.evaluateCoriolisTermRHS(obj, fphys);
3.3底摩阻项函数：obj.frictionSolver.evaluateFrictionTermRHS(obj, fphys);
3.4风应力项函数：obj.windSolver.evaluateWindTermRHS(obj, fphys);



# 2. 测试情形

两个四边形网格

1.平底，左干右湿；
2.平底，左湿右干；
3.平底，全湿，静水；
4.平底，全湿，左侧水位高于右侧；
5.平底，全湿，左侧水位低于右侧；
6.台阶状，左低右高，左湿（低于右侧底坡高程）右干；
7.台阶状，左低右高，左湿（高于右侧底坡高程）右干；
8.台阶状，左低右高，全湿，静水；
9.线性底坡，全湿，静水；
