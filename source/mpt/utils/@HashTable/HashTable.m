classdef HashTable %< handle
%
% HashTable wrapper for java.util.LinkedHashMap
%
 
properties (SetAccess=private, GetAccess=private)
    Table % stored data
    Internal % reserved for internal data
end
properties
    Data; % arbitrary user data
end
methods
    function obj=HashTable(data)

        error(nargchk(0,1,nargin));
        if nargin==0
            data = [];
        else
            if ~isa(data,'struct')
                error('Any data stored with HashTable must be in a struct format.');
            end
        end
        
        % empty hash table by default
        obj.Table = java.util.LinkedHashMap;
        
        % put any user data inside Data
        obj.Data = data;
        
    end    
end
end

