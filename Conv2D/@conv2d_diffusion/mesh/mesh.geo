c = 5;
xmin = -100; xmax = 100;
ymin = -100; ymax = 100;

Point(1) = {xmin, ymin, 0, c};
Point(2) = {xmax, ymin, 0, c};
Point(3) = {xmax, ymax, 0, c};
Point(4) = {xmin, ymax, 0, c};
Line(1) = {1, 2};
Line(2) = {2, 3}; // east boundary
Line(3) = {3, 4}; 
Line(4) = {4, 1}; // west boundary
Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

Recombine Surface{1};
Mesh.Smoothing = 10;

Physical Line(5) = {1,2,3,4}; // east bc - clamped
Physical Surface(1) = {1};Coherence;
