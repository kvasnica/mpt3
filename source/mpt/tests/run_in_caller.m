function [worked, msg] = run_in_caller(statement)
% evaluates 'statement' in the caller's workspace and returns boolean flag
% 'worked' (true if no errors, false otherwise) and the error message in
% 'msg' (if any)

try
    if ischar(statement)
        evalin('caller', statement);
    else
        % statement is a function handle
        feval(statement);
    end
	worked = true;
	msg = '';
catch
	worked = false;
	LE = lasterror;
	msg = LE.message;
end
