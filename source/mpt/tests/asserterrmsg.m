function asserterrmsg(msg, string)

assert(~isempty(strfind(msg, string)));
