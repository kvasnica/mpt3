classdef EMPCSTController < EMPCController
    % Class representing explicit MPC controllers with binary search tree
    %
    % Constructor:
	%   ctrl = EMPCSTController(EMPCController)

    properties(SetAccess=protected, Transient=true)
		STdata
	end
    
    methods

        function obj = EMPCSTController(varargin)
            % Constructor:
            %
            %   ctrlst = EMPCSTController(EMPCController)
            
             if nargin>1
                 error('The "EMPCSTController" constructor accepts only one argument that is an object of "EMPCController" class.');
             end
             
             ectrl = varargin{1};
             if ~isa(ectrl,'EMPCController')
                 error('The input object must be an object of "EMPCController" class.');
             end

             % copy data from EMPCController
             obj=obj@EMPCController(ectrl);
             
             % call private method
             obj.STdata = constructST(ectrl);
                                        
            
        end
        
        function out = getName(obj)
			out = 'Explicit MPC controller with binary search tree';
		end

        
	end
end
