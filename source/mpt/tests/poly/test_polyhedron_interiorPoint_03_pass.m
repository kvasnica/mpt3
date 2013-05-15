function test_polyhedron_interiorPoint_03_pass
%
% H-V array of polyhedra
%

H=[  -0.34713       1.1341      0.65951       1.0453      0.29442       7.6759
       1.2182     -0.12278      0.35517     -0.75666        0.188       3.9136
    -0.061407      -1.2995      0.23139      0.28898      0.36875       0.3055
     -0.23988     -0.67135       2.6521       0.2661      0.98158       7.4386
       1.3682     -0.44373     -0.60148     -0.64247       0.1544       5.2698
       2.3315      0.84398       1.2948      0.66776     -0.43266       1.4102
      0.40283       1.2925      0.74083      -1.7834       1.3649        5.162
     -0.50882    -0.045929      0.38611      0.32522      0.27755       3.8248
       1.1276       1.9359       1.3122      -1.4218     -0.46594       4.0188
      0.56657     -0.67162      -2.0717      -0.5355      -1.6841       1.9842
     -0.39542      -1.0668      0.75501    -0.066949      0.28966       7.8513
      0.11343     -0.21143       1.7685       1.6671       -1.386       4.6656
       2.3168      -1.0688      -1.4155      0.50747       1.8264       6.0466
     -0.60626      -0.8879    -0.015746      -2.3804     -0.78691       2.3368];
V = [  5.9645       7.9494       5.9921      -4.1919
       4.8721       8.6418        8.308      -2.0714
       3.1617       7.9081       7.9091      -2.7398
       4.7171       7.8957       7.4006      -2.7245
       4.3411       7.4287         6.85      -3.3462
       4.1446       8.1587       7.6696      -3.8286
       6.1944       8.8921       6.2575      -3.4262
       4.7719       7.3177       6.0858      -3.7187
       4.7504       8.0975       7.4495      -2.1634
       6.2924       10.118       4.4639      -1.2555
       5.4945       8.6366       8.8558      -2.8614
       5.5457       7.9934       7.8333      -4.2242
       6.9596       8.9259       6.9579      -1.2722
       6.5916       7.3329       7.1183      -1.8283
       4.4587       8.8727        5.705      -2.5546
       4.3427       6.6542       8.0621      -1.5567
       4.1819       7.2591        7.231      -3.4098
       6.3375       7.3296        6.926      -4.8053];
P(1) = Polyhedron('H',H);
P(2) = Polyhedron(V);

res = P.interiorPoint;

for i=1:2
    if ~P(i).contains(res{i}.x)
        error('The point must lie inside the set.');
    end    
end

end