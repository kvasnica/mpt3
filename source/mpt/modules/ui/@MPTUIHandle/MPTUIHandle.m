classdef MPTUIHandle < dynamicprops & matlab.mixin.Copyable
    % Class representing a storage of components and filters
   
    properties(Hidden,SetAccess=protected)
        internal_properties
	end
	properties(Hidden,Constant)
		Version = 1;
	end

    methods
        function obj = MPTUIHandle()
		end
	end

	methods(Static)
		function new = loadobj(obj)
			% load method
			
			new = obj;
			if isfield(obj.internal_properties, 'save')
				if isfield(obj.internal_properties.save, 'filters')
					% restore filters
					new.loadSavedFilters();
				end
				if isfield(obj.internal_properties.save, 'components')
					% restore components
					new.loadSavedComponents();
				end
				if isfield(obj.internal_properties.save, 'value')
					% restore signals' values (for SystemSignal objects
					% only)
					%
					% TODO: what about sdpvars introduced in filters?
					new.loadSdpvarValue();
				end
				
				new.internal_properties = rmfield(obj.internal_properties, 'save');
			end
		end
	end
	
	methods(Access=protected)

		function out = wasModified(obj)
			% Returns boolean flag indicating whether properties of the
			% object were changed by the user
			
			if ~isfield(obj.internal_properties, 'modified')
				obj.internal_properties.modified = true;
			end
			out = obj.internal_properties.modified;
		end
		
		function obj = markAsUnmodified(obj, source, event)
			% Marks the object as unmodified
			
			obj.internal_properties.modified = false;
		end

		function obj = markAsModified(obj, source, event)
			% Marks the object as unmodified
			
			obj.internal_properties.modified = true;
		end
		
		function new = copyElement(obj)
			% Copy constructor
			
			new = copyElement@matlab.mixin.Copyable(obj);

			if isfield(obj.internal_properties, 'component')
				% clone-copy components
				new.copyComponentsFrom(obj);
			end
			
			if isfield(obj.internal_properties, 'filter_map')
				% clone-copy filters
				new.copyFiltersFrom(obj);
			end
		end

	end

end
