function test_enum_pqp_10
% correctness of mpt_enum_pqp

m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));

n = 10;
r = -ones(1, n);
Ts = 1;
N = 2;

t = tf(1, poly(r));
s = ss(t);
sd = c2d(s, Ts);
model = LTISystem('A', sd.A, 'B', sd.B);
model.x.min = -10*ones(n, 1);
model.x.max = 10*ones(n, 1);
model.x.penalty = QuadFunction(eye(n));
model.u.min = -1;
model.u.max = 1;
model.u.penalty = QuadFunction(1);
ctrl = MPCController(model, N);

% mptopt('pqpsolver', 'plcp');
% c_reg = ctrl.toExplicit(); % 232 regions

mptopt('pqpsolver', 'rlenumpqp');
c_rlenum = ctrl.toExplicit();
assert(c_rlenum.optimizer.Num>=225); % ideally, 232, but those are tiny

mptopt('pqpsolver', 'enumpqp');
c_enum = ctrl.toExplicit();
assert(c_enum.optimizer.Num==232);


X = [-8.6813 9.9712 -9.9712 -4.2381 9.9712 -9.9712 5.4088 -7.1309 9.9712 6.6368;7.9725 -9.9939 -9.9939 1.1431 9.9939 -9.9939 4.7111 9.4476 -9.9939 -7.4503;9.9876 -7.4657 -9.9876 5.6616 -9.9876 9.8443 -9.9876 -3.9112 -2.844 -7.0118;-9.9965 -0.17138 -9.9965 4.4918 3.0397 9.9965 -9.9965 -7.7453 -0.76006 -7.2946;-3.2691 -9.9994 9.9994 -1.9867 -9.9994 5.0666 9.9994 -9.9994 -5.0152 -5.868;-1.6976 -9.9999 -9.9999 9.9999 4.8769 -9.9999 3.8304 9.9999 -9.9999 -7.5077;0.14811 -9.9969 -9.9969 9.9969 -3.2333 4.8216 -2.7843 9.9969 -9.9969 -7.4384;3.0881 -10 -10 3.3283 10 -2.6315 -10 7.0016 7.7587 -10;-9.9995 2.5257 -9.9995 9.9995 -9.9995 7.502 -9.9995 9.9995 3.6838 -9.9995;-10 -10 3.1195 1.0638 10 -10 5.4359 -10 10 7.3172;-4.7522 -9.9954 -9.9954 9.9954 9.9954 -9.5953 -6.227 -0.55032 -4.9015 -6.6748;-8.5438 9.9886 -0.20774 -9.9886 -1.0735 7.3123 -9.9886 -2.7211 -3.6204 9.9886;-9.9999 -4.5296 7.2044 -9.9999 9.8297 4.1856 -9.9999 9.9999 3.2007 6.4969;-6.8765 9.998 -2.7814 -9.998 4.9299 -6.7629 9.998 -8.0508 9.998 6.4724;-4.1997 9.975 -2.4982 -9.975 -0.55505 -1.1453 5.5946 -4.5211 9.975 5.7923;4.2367 -9.9997 -9.9997 5.3534 5.8228 -2.6926 -9.9997 0.14379 -5.0226 -6.6661;-7.9653 9.9905 -0.53641 -9.9905 -0.95375 6.7105 -9.9905 -2.1622 -0.4368 9.9905;10 -8.4917 -10 6.2754 -10 8.8304 -2.9326 -10 0.017203 -7.4826;-9.8347 9.998 0.4425 -9.998 -1.1661 8.2723 -9.998 -3.6876 -2.9816 -6.9953;10 -10 -10 8.9592 -10 -1.1382 10 -4.5281 -8.856 -5.0994;-9.2105 9.9997 0.10721 -9.9997 -1.0938 5.6453 -1.0693 -9.9997 -0.26529 -7.4125;10 -10 -10 8.9593 -10 -1.1382 10 -4.5282 -8.8559 -5.0995;-8.7443 9.9953 -0.1035 -9.9953 -1.0935 7.2638 -9.9953 -2.6751 -3.656 9.9953;-9.9861 -7.4471 9.9861 -9.9861 9.0083 5.2531 -9.9861 9.9861 2.0416 -9.9861;-6.5731 6.5731 -6.5731 2.0233 6.5731 -6.5731 3.3963 0.73673 -5.9785 -3.371;4.0976 -9.9982 -9.9982 5.2928 8.5337 -9.9982 -0.55137 -3.7431 -3.8626 -6.7998;10 2.3276 -10 -10 10 3.1857 -2.8244 10 -10 -7.4359;-10 -7.9045 10 -10 9.237 6.9529 -4.2992 -10 7.456 8.7843;7.1428 -9.9806 -9.9806 -1.1603 9.9806 1.5843 5.6814 -4.8685 -8.4026 -5.1869;9.9968 -5.9517 -9.9968 4.5632 -9.9968 9.9968 -9.9968 -1.5833 -5.1582 -6.4457;-2.0928 9.999 3.7537 -9.999 -9.999 3.69 4.5031 7.7425 -9.999 9.999;9.9951 5.6936 -9.9951 -5.504 -3.745 -0.59999 9.9951 -5.5286 9.9951 5.6988;9.9975 9.9975 -3.8863 -9.9975 1.5895 1.656 -9.9975 9.9975 4.9184 -9.9975;-8.9196 9.9991 9.9991 -9.9991 -9.9991 9.9991 -2.7482 -9.9991 -0.0081159 4.4944;6.2414 10 -7.8022 -4.7609 -10 6.4234 10 -7.4055 -7.6892 -5.1986;9.9998 9.9998 -9.9998 -7.9271 9.9998 -2.3349 -9.9998 4.9966 -9.9998 9.9998;7.9807 10 -10 -3.5845 -10 6.2815 10 -7.4113 -7.6828 -5.1989;9.9921 9.207 -9.9921 -2.4192 9.9921 -9.9921 -3.9973 8.9872 -9.9921 -6.6304;-9.9693 -9.9693 3.3004 9.9693 -6.1434 -9.9693 9.8205 -9.4455 0.064831 9.9693;-9.9938 -9.9938 -0.54302 9.9938 -3.4858 9.9938 -9.9938 -7.4898 4.5883 -9.9938;-9.9988 -0.10674 -7.5711 9.9988 -9.9988 9.5514 3.7711 -7.9409 9.9988 -9.9988;-8.1852 -9.9999 0.91455 9.9999 1.1395 -9.9999 9.9999 7.0938 0.44527 -9.9999;8.8629 -10 -10 4.2251 10 -4.4502 10 0.20766 -10 -5.8435;6.69 10 -8.3093 -10 -0.0829 -1.1168 10 5.7111 -10 -7.1153;10 3.7139 -10 10 -10 10 -7.7261 10 -10 -7.1869;10 1.4826 -10 10 -10 2.6685 10 -0.0907 -10 -5.8311;-9.9942 -9.9942 5.281 9.9942 -9.9942 2.308 9.9942 0.79086 -9.9942 -6.0379;9.6842 -10 -10 -1.744 10 6.6409 -10 2.5305 9.6272 -10;-10 -1.3156 -10 10 4.2288 -3.3372 -10 10 5.1443 -10;-10 2.1464 -10 10 -10 8.5792 -10 10 3.3607 6.4163;-10 10 -0.68149 10 -10 -10 5.0012 2.5644 8.57 -8.9858;-3.7809 -9.999 -6.8758 9.999 -1.2933 2.1043 -9.999 9.999 4.2436 6.1104;-10 10 -2.6002 -10 10 -10 8.6212 -10 10 7.1315;5.6936 -10 -10 10 10 -10 10 -10 5.3792 9.1958;-1.0161 10 -10 -3.7087 -3.9021 -0.45462 10 -10 5.1127 9.2468;-10 -8.409 10 10 -10 -10 10 -9.4854 5.9554 9.0291;10 -9.319 -10 10 10 -7.1561 -9.2852 -1.6104 4.2224 9.154;10 2.0835 -10 2.8079 10 -10 3.2988 -10 10 7.4725;10 -2.7208 10 -10 10 -10 4.9433 -10 7.1554 8.8067;-8.3234 -9.9999 9.9999 -7.2099 5.7132 7.1167 -9.9999 1.838 9.9999 5.0544;-2.2682 -9.9843 -9.9843 9.9843 9.9843 -5.8936 -9.9843 -0.62325 -4.1975 -6.8393;9.978 9.978 -7.4876 -9.978 -4.0572 9.978 0.5967 -9.978 -2.0289 -6.7771;7.3852 -9.9981 -9.9981 9.9981 9.9981 -1.6478 -4.4196 -4.1868 -4.983 9.9981;9.999 9.999 -9.2418 -9.999 3.276 9.999 1.7047 1.5469 4.9123 6.6482;3.2338 8.821 -9.9993 -9.9993 9.9993 2.5865 6.2616 1.4684 4.3298 6.7956;9.9693 9.9693 -3.3004 -9.9693 6.1434 9.9693 -9.8205 9.4455 -0.064831 -9.9693;9.9938 9.9938 -1.2701 -9.9938 4.3519 -9.9938 9.9938 7.4438 -0.079116 -9.9938;4.4803 -10 -10 4.5268 10 -10 2.356 10 0.88658 7.135;9.9998 9.9998 -4.5179 -9.9998 -6.5937 2.3261 9.9998 4.9626 -1.6902 8.8586;10 6.1936 -10 -10 10 -9.8923 10 7.1104 0.82351 7.3378;0.52289 9.9999 2.8807 -9.9999 -9.9999 3.7534 4.683 7.8352 0.75891 7.3361;-10 -5.8972 10 -10 10 -5.3547 10 -5.4495 -8.3719 10;-10 -1.6589 10 -4.1331 -10 5.1613 -0.78707 10 -10 -7.4712;9.9476 9.9476 -4.3818 -9.9476 -6.6258 2.3641 9.9476 4.8644 1.1504 2.1069;9.9988 9.9988 -9.346 6.0998 -5.4363 -7.0919 -2.0899 9.9988 3.4881 6.2492;-10 -5.2442 -10 9.607 10 -10 -5.8518 -0.60987 -4.9147 -6.6737;10 10 -10 -4.1661 -10 3.0052 4.7517 7.9053 0.75961 7.3285;10 -10 -10 10 -10 -3.4969 8.0108 -6.1824 10 6.1401;10 10 -2.7917 -10 10 -10 -2.6496 10 1.594 7.244;-0.931 -0.061707 10 -10 10 -10 -3.1941 -1.0962 10 5.8458;8.929 -10 -10 1.4701 10 -3.7036 -10 5.1495 -10 10;9.9796 9.9796 -3.096 -9.9796 0.4198 2.2845 -9.9796 9.9796 4.836 -6.9149;9.9999 9.9999 -6.4806 -9.9999 1.1293 9.9999 -9.9999 -7.2088 -0.43108 -7.5005;-10 -2.4303 -10 10 10 -6.1591 -10 -0.87255 -3.978 -6.9007;7.8099 -4.9919 10 -10 -10 10 -1.8164 -10 10 7.4507;-10 -10 10 10 -10 -9.4688 10 -9.6592 10 7.0328;2.8902 1.7402 10 -10 10 -10 -3.4874 -1.6339 10 5.994;9.9942 9.9942 -9.9942 -2.2655 -4.6514 9.9942 -9.9942 -6.6533 -0.73536 -7.4481;10 -10 -10 10 -10 10 -5.9208 0.80402 -10 -5.0047;9.999 9.999 -9.3359 -6.7205 9.999 -3.9571 -8.8438 4.7839 -9.999 9.999;-1.6535 9.9999 9.9999 -7.875 1.0643 -8.4293 9.9999 -1.7914 -9.9999 -5.0463;-9.2909 -9.2909 0.063189 9.2909 -4.2292 1.7645 -5.3174 9.2909 1.893 6.3037;2.2682 9.9843 9.9843 -9.9843 -9.9843 5.8936 9.9843 0.62325 4.1975 6.8393;-9.978 -9.978 7.4876 9.978 4.0572 -9.978 -0.5967 9.978 2.0289 6.7771;-9.9476 -9.9476 4.3818 9.9476 6.6258 -2.3641 -9.9476 -4.8644 -1.1504 -2.1069;-9.9796 -9.9796 2.1467 9.9796 -7.4427 9.9796 -1.265 -9.9796 -2.1187 -6.6754;-7.1428 9.9806 9.9806 1.1603 -9.9806 -1.5843 -5.6814 4.8685 8.4026 5.1869;5.297 -9.9712 9.9712 1.1526 5.8858 -9.2485 9.9712 3.8424 2.877 6.9922;9.2909 9.2909 -0.063189 -9.2909 4.2292 -1.7645 5.3174 -9.2909 -1.893 -6.3037;-1.8826 10 2.3865 -9.2491 -10 6.7803 10 -10 -5.1064 -5.8449;10 7.0901 -10 -10 9.746 -10 10 7.1493 -10 -7.2558;10 10 -10 -10 1.7478 4.9394 -10 4.1623 8.9899 -10;-10 10 6.9086 -10 -8.4546 2.1119 5.5691 -1.5741 10 -10;-2.1099 -10 10 -10 10 -2.2635 10 0.93839 -10 -6.0491;-9.9998 -4.3852 6.895 -9.9998 9.9998 3.0605 -3.5028 9.9998 -8.3306 -8.2335;9.3866 -10 -10 -2.1244 10 4.8264 2.6722 -10 -3.5453 -6.2334;10 -2.7838 -10 -6.2496 10 10 -5.887 -10 7.428 8.7996;-1.7074 9.9993 -9.9993 -9.9993 9.9993 -1.0576 -0.014126 9.926 0.2272 -9.9993;-1.3787 -9.9998 8.4746 -9.9998 9.9998 -1.5512 -9.9998 -0.27395 -4.8396 -6.6906;10 10 -9.1495 -10 -1.7546 10 -5.3746 -9.243 10 -10;10 8.7895 -10 -10 3.3777 10 -10 -7.3351 -0.42051 -7.4917;10 10 -5.5614 -10 -0.64901 10 -8.7135 -7.7185 -0.33987 -7.5016;-10 9.9108 10 -10 -10 2.2582 10 5.3625 -10 -7.0629;-0.23316 10 10 -10 0.68961 -10 5.1137 10 0.83053 7.0893;10 10 -2.7715 -10 10 -10 -2.6518 10 3.7141 -1.5474;9.9998 -7.9383 9.9998 -9.9998 9.9998 2.6277 -9.9998 -6.2074 9.9998 7.1729;10 10 1.6987 -10 -0.90715 8.1632 -3.0251 -1.3768 -9.2337 -5.0631;10 -4.2811 10 -10 3.2211 10 -10 1.6759 -10 -5.003;-7.9472 10 10 -0.97049 -10 3.3986 -10 10 -10 -6.698;0.61786 9.9974 5.6509 -9.9974 -1.0535 5.0473 -9.9974 -3.3217 -2.8095 9.9974;-9.9998 9.9998 9.9998 -4.7493 -9.9998 4.6568 -9.9998 9.9998 -8.7124 -7.3537;-7.2182 9.9981 9.9981 -9.9981 -9.9981 1.6299 4.4206 0.38291 8.7904 5.2702;-9.999 -9.999 9.2418 9.999 -3.276 -9.999 -1.7047 -1.5469 -4.9123 -6.6482;-3.2338 -8.821 9.9993 9.9993 -9.9993 -2.5865 -6.2616 -1.4684 -4.3298 -6.7956;9.9999 9.0523 -9.9999 -3.8392 -9.9999 2.9317 9.1541 5.715 -9.9999 -7.1093;9.9999 4.5296 -7.2044 9.9999 -9.8297 -4.1856 9.9999 -9.9999 -3.2007 -6.4969;10 -10 -7.8189 10 10 -3.1689 -5.1693 -0.21265 -8.2583 10;10 -10 -10 10 -2.5043 10 -6.9491 0.61432 -9.8542 -5.0632;10 10 -10 -10 10 9.5241 -8.1556 7.8197 -10 -0.999;7.3684 -9.998 2.5367 9.998 -4.9206 6.7927 -9.998 5.691 -9.998 9.998;9.999 -9.999 -9.999 9.999 -2.4819 9.999 -9.999 2.976 -9.999 9.999;-2.2372 -10 -3.9253 10 10 -3.0632 -10 -4.9532 -1.1357 -7.4477;10 -10 -10 -0.31954 6.928 10 -5.2751 -10 -1.0073 10;10 10 -9.5101 -10 10 -1.6945 10 -10 -4.957 -5.848;8.4858 -4.4529 9.9997 0.59874 -9.9997 3.4538 9.9997 -0.15897 5.0193 6.6674;-6.7003 9.9998 9.9998 -5.462 -9.9998 9.9998 4.9099 0.73342 5.0097 6.6471;6.3126 -10 -10 10 -10 3.647 10 -6.5354 -8.0547 -5.199;10 2.5099 -10 -10 10 6.2298 2.7594 -10 -3.6339 10;0.76338 10 -7.0304 10 -10 0.74049 0.54523 10 0.015151 7.4859;-10 -10 5.5614 10 0.64901 -10 8.7135 7.7185 0.33987 7.5016;-10 7.898 -10 -0.0066713 10 -10 3.5961 10 0.45275 7.2683;2.3793 10 2.126 -10 -10 6.7631 -1.1415 10 0.51415 7.2783;9.9996 -9.9996 -9.9996 -0.99788 7.4173 9.9996 -5.6949 -9.9996 -0.81767 -7.0856;-10 10 10 -1.474 -10 3.7333 10 -0.13869 -10 -5.8308;9.9997 9.9997 -1.738 -9.9997 9.9997 -6.5428 9.9997 -9.9997 -3.8086 -6.2565;-9.154 10 10 -3.2049 1.0988 -10 10 7.3558 0.45156 1.2604;10 10 2.5359 -10 -2.4734 2.8526 10 -0.023362 -10 -5.8596;5.9107 -10 10 8.4225 -10 -7.0994 10 7.1686 -10 -7.2788;8.5707 -9.998 0.22741 9.998 1.0155 -7.2756 9.998 2.7217 3.6249 -9.998;-9.9991 -9.9991 9.9991 9.4468 -9.9991 -1.5373 9.9991 3.6673 2.4571 7.1548;-10 10 10 -8.9592 10 1.1382 -10 4.5281 8.856 5.0994;-10 5.7574 -9.4422 10 10 -6.5171 -10 7.2735 7.7517 5.1935;-10 -10 4.6597 6.5289 -10 9.6972 -5.3748 0.69533 10 4.9931;2.4595 -10 -10 5.7951 10 -4.7389 -10 7.709 7.4829 -10;9.9294 10 -10 -10 4.2621 10 1.3221 1.5341 5.0021 -4.3044;10 10 -2.3024 -10 10 -2.6771 -10 10 4.9566 -10;-5.84 10 10 -0.69612 -10 3.2756 -10 10 4.7851 5.9112;-6.4424 10 10 -5.3951 -10 4.7417 -10 7.3066 7.5084 5.2078;-6.0455 9.9997 -8.6787 9.9997 2.1705 -1.2241 -9.9997 9.9997 4.2464 6.1511;9.9998 -9.9998 -9.9998 9.9998 9.9998 -4.8508 -9.9998 9.9998 4.6398 6.0123;-10 -10 0.99983 10 -10 8.5783 -4.9154 0.65461 10 4.9937;3.8217 -10 10 -10 10 -2.5729 -10 10 5.0874 -10;-6.8756 10 10 -10 10 -3.5003 0.51458 -10 7.4152 8.7709;4.1557 -9.9997 -9.9997 9.9997 9.9997 -8.569 9.9997 -9.9997 -4.0327 -6.1562;-2.4195 -10 0.61862 10 7.6628 -10 10 -10 5.3914 9.1935;-10 -2.2639 10 10 -10 -6.6101 10 -10 5.7575 9.1018;-1.1385 10 -10 4.6001 10 -9.4962 9.759 -3.5484 10 5.2844;-2.6267 -10 10 -10 6.531 10 -5.396 -10 10 7.5157;6.9674 -10 -10 0.90805 10 -3.3487 10 -10 4.6911 9.352;-10 2.8206 -10 10 -3.6129 -10 9.8959 -9.758 6.0248 9.0273;1.1281 -10 -10 10 10 -6.0168 -10 -0.74155 3.6649 9.2437;-1.1131 -9.998 -2.838 9.998 9.998 -3.6769 -9.998 -4.6679 9.998 -9.998;-6.1688 10 10 -1.3232 -10 2.9744 -0.11003 10 -7.4933 -8.7534;1.888 -10 -2.936 10 9.4156 -6.6528 -10 10 5.1035 5.8455;-10 -10 10 10 -1.5695 3.0273 -10 -6.0638 10 7.1489;-9.9999 -9.0523 9.9999 3.8392 9.9999 -2.9317 -9.1541 -5.715 9.9999 7.1093;-10 10 -10 10 -10 10 0.88436 -1.3587 -9.7748 10;10 -10 -6.9086 10 8.4546 -2.1119 -5.5691 1.5741 -10 10;-10 4.2429 -10 10 7.389 -7.6243 10 -2.0737 -10 -5.1654;-0.68807 -9.9974 -9.9974 9.9974 -3.3617 6.4242 4.3026 -2.3531 -9.6133 -5.1967;9.9968 -9.9968 -7.8273 9.9968 9.9968 -3.1684 -5.1653 3.0876 -9.9968 -5.4209;-9.9951 -2.0338 2.8462 9.9951 1.5957 1.0144 -9.9951 5.5848 -9.9951 -5.7174;-0.93855 -9.9975 -9.9975 9.9975 -3.3208 9.5978 1.1145 -9.9975 -3.3546 -6.2822;-4.0976 9.9982 9.9982 -5.2928 -8.5337 9.9982 0.55137 3.7431 3.8626 6.7998;9.9876 9.9876 -2.5154 -9.9876 4.9516 9.9876 -8.4819 8.6616 2.2156 -9.9876;2.3587 -9.9921 -9.9921 6.938 0.032798 7.3542 -9.9921 9.9921 2.687 -9.9921;-0.032646 9.9965 9.9965 -6.6392 -2.2842 -9.9965 9.9965 7.7353 0.76014 7.2956;-9.9997 9.9997 9.104 -9.9997 -9.9997 9.9997 -7.897 9.9997 2.7015 6.6011;-9.7498 10 10 -10 10 -10 4.7775 -10 -0.31805 -7.4473;10 6.8412 -10 -10 10 -7.4562 2.9883 10 -7.4146 -8.7863;8.3029 -4.5903 10 -10 -10 6.664 10 -10 -5.1111 -5.8413;-9.0148 10 -1.9077 10 -10 -10 5.8199 10 -10 -7.5129;-10 -9.5415 10 -2.955 10 -4.2003 10 -10 -4.8421 -5.8729;0.81233 9.998 2.6775 -9.998 -9.998 3.7831 9.998 4.619 -4.6463 -9.2325;10 2.7605 -10 10 -10 2.4678 -10 -0.80992 3.8343 9.0975;9.9994 9.9994 -1.686 -9.9994 9.9994 -2.7513 -9.9994 9.9994 3.3286 6.6844;-10 10 10 2.3165 -10 -4.7318 -2.8002 10 3.5708 6.2265;-9.9904 -0.40153 10 7.9792 -10 -10 10 -10 10 7.1343;6.8144 10 -10 -10 10 -1.5461 -10 0.17057 10 5.7958;-10 -2.9928 10 10 -9.2111 0.66497 -10 4.8551 -10 10;-0.58929 9.9997 5.7141 -9.9997 -9.9997 9.9997 -9.9997 9.9997 3.7232 6.2652;9.9996 -9.9996 -0.56418 9.9996 -2.6979 -9.9996 -1.4291 9.9996 3.4753 -9.9996;6.0975 -10 -10 10 10 -1.6965 -10 -5.6132 1.5027 -8.6445;-2.4375 10 -10 10 -6.7091 10 -10 -7.2611 10 7.2661;9.9999 9.9999 2.32 -9.9999 -1.5222 8.8201 -3.6348 -9.9999 9.9999 7.507;-10 2.1308 10 5.4053 -10 7.9015 -10 -6.4878 10 7.2006;-6.0924 10 10 -10 -9.9923 10 -2.9326 -10 10 7.5259;-6.4199 9.9969 9.9969 -0.20711 -9.9969 2.1592 -0.53076 -9.6302 9.9969 7.4609;10 -10 0.40149 -10 10 6.2961 2.2488 -5.831 -7.6883 10;-3.0881 10 10 -3.3283 -10 2.6315 10 -7.0016 -7.7587 10;6.5868 10 -10 6.3845 -10 4.1523 -10 4.4995 -10 10;10 10 -7.7673 -10 9.8841 8.2114 -10 1.6953 -10 -5.0003;-8.2785 9.9995 9.9995 -0.93951 -9.9995 9.9995 -7.6985 1.4964 -9.9995 9.9995;10 10 0.96452 -10 4.1892 -3.1355 10 -10 -4.1705 -6.1355;-10 10 10 2.2238 -10 -2.4288 10 -10 -3.5945 -6.3531;0.15849 -10 -10 10 -0.68003 10 -5.2537 -10 -0.76114 -7.1124;-10 -9.5911 10 10 -10 1.6109 10 -7.5691 -7.474 -5.2099;10 -5.1106 10 -10 10 3.7601 -10 10 -10 -6.931;-10 -10 2.7715 10 -10 10 2.6518 -10 -3.7141 1.5474;-2.2547 9.9999 9.9999 -4.4982 -9.9999 9.9999 -9.9999 5.8113 -9.9999 9.9999;10 10 -10 4.4217 -10 2.8327 10 -10 -4.8826 -5.8902;4.7522 9.9954 9.9954 -9.9954 -9.9954 9.5953 6.227 0.55032 4.9015 6.6748;-9.9998 -9.9998 4.4985 9.9998 6.6085 -2.3333 -9.9998 -3.4584 -2.6264 -7.0762;-10 -10 10 3.9955 10 -10 9.1172 -10 -3.257 -6.4192;9.8066 -9.9886 -0.46151 9.9886 1.2239 -8.3082 9.9886 3.686 2.9778 6.9883;-9.9999 5.6819 -9.9999 9.9999 9.9999 -3.3918 -4.9207 -5.637 -2.907 -6.8017;-8.166 9.9993 -7.5422 9.9993 1.9711 0.71992 -9.9993 1.5675 9.9993 5.3022;4.9197 -9.9751 2.1182 9.9751 0.64161 1.1153 -5.5762 -2.7384 9.9751 -9.9751;9.9998 -9.9998 2.7841 9.9998 -9.9998 9.9998 -7.9311 0.35344 9.9998 -9.9998;8.2325 -9.9905 0.39608 9.9905 0.98622 -6.7185 9.9905 2.1632 -6.7983 9.9905;-4.0011 9.9939 -9.7281 9.9939 2.3739 -8.6475 9.9939 3.7751 2.9289 7.0012;7.7582 9.9861 -9.9861 8.9827 -8.3072 -3.5939 -3.1461 9.9861 -9.9861 -7.027;8.7443 -9.9953 0.1035 9.9953 1.0935 -7.2638 9.9953 2.6751 3.656 -9.9953;10 10 -10 6.9301 -6.0017 -10 10 7.752 -7.0626 -8.7949];
% X = [];
% for i = 1:c_reg.optimizer.Num
%     ch = c_reg.optimizer.Set(i).chebyCenter();
%     X = [X; ch.x'];
% end
for i = 1:size(X, 1)
    x = X(i, :)';
%     u1 = c_reg.optimizer.feval(x, 'primal');
    u2 = c_rlenum.optimizer.feval(x, 'primal');
    u3 = c_enum.optimizer.feval(x, 'primal');
%     assert((all(isnan(u1)) && all(isnan(u3))) || norm(u1-u3)<1e-6);
%     assert((all(isnan(u1)) && all(isnan(u2))) || norm(u1-u2)<1e-6);
    assert((all(isnan(u2)) && all(isnan(u3))) || norm(u2-u3)<1e-6);
end

% patological case
x1 = [3.08811233769382;-9.99999654703456;-9.99999654703456;3.32832487514286;9.99999654703456;-2.63154776474646;-9.99999654703456;7.00162237174638;7.75872395167315;-9.99999654703456];
x2 = [6.24137650502338;9.99999869198917;-7.8021618441581;-4.76089023629172;-9.99999869198917;6.4233892863025;9.99999869198917;-7.40549212960808;-7.68918255142285;-5.19860330516716];
x3 = [8.86293048112875;-9.99996670540421;-9.99996670540421;4.22506809351295;9.99996670540421;-4.45017247872793;9.99996670540421;0.20765729371851;-9.99996670540422;-5.84351309692381];
x4 = [9.99996488651998;1.48256192986562;-9.99996488651998;9.99996488651998;-9.99996488651998;2.66847663156814;9.99996488651998;-0.0906999559799927;-9.99996488651998;-5.83106892335891];
X = [x1 x2 x3 x4];
for i = 1:size(X, 2)
    x = X(:, i);
    % u1 = c_reg.optimizer.feval(x, 'primal');
    u2 = c_rlenum.optimizer.feval(x, 'primal');
    u3 = c_enum.optimizer.feval(x, 'primal');
    % [u1 u2 u3]
    assert(isequal(u2, u3));
end
end
