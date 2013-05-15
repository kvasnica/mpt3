function y=validate_realmatrix(v)
%
% check if the argument is a real matrix, otherwise throw an error
%
% empty argument (v=[]) is considered as valid

if isreal(v) && ismatrix(v) && all(isfinite(v(:)))
    y=true;
else
    error('Input argument must be a real matrix.');
end
end
