\page SWE SWE2D unittest

# 1. 测试的函数


1.体通量测试函数：getVolumeFlux

调用公有函数 obj.matEvaluateFlux(mesh,fphys),返回[ E,G ];

2.边界内外值测试函数： getFaceValue

调用Sealed函数 obj.matEvaluateSurfaceValue( mesh, fphys, fext ),返回[ fM, fP ];

3.面通量测试函数：getFaceFlux

调用Sealed函数 obj.mxEvaluateSurfFlux( hmin, gra, nx, ny, fm),返回fluxM;

4.面数值通量测试函数：getNumFlux

调用sealed函数 obj.numfluxSolver.evaluate( hmin, gra, nx, ny, fm, fp )，返回fluxS;

5.时间步测试函数：getTimeStep

调用保护类函数 obj.matUpdataTimeInterval(fphys)，返回[ dt ];

6.底坡源项测试函数: getTopographySourceTerm

调用保护类函数 obj.matEvaluateTopographySourceTerm(fphys);

7.科氏力测试函数： getCoriolisTerm

调用函数obj.coriolisSolver.evaluateCoriolisTermRHS(obj, fphys);

8.风应力测试函数：getWindForceTerm

调用函数 obj.windSolver.evaluateWindTermRHS(fphys);

9.底摩阻测试函数： getBottomFrictionTerm

调用函数 obj.frictionSolver.evaluateFrictionTermRHS(fphys);

`$\delta$`


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
