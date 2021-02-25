classdef FactorGraph < handle
    % FactorGraph    Summary
    % Class that maintains a factor graph for inference. Uses BaseNode and
    % BaseEdge classes.
    methods (Access = public)
        function obj = FactorGraph( varargin)
            %FACTORGRAPH
            
            % Initialize the graph
            obj.G = graph;
        end
        
        function obj = addVariableNode( obj, node, name)
            %ADDVARIABLENODE Adds a variable node to the graph. Additional
            %arguments may be specified. 
            %@param[in][required] node
            %   Custom node type.
            %@params[in][required] 'name' : 
            %   This is a node name. It's a required parameter but can be
            %   specified inside node. 
            
            % Validators
            %   A node is a valid node if it's an instance of a class derived
            %   from BaseNode
            isValidNode = @(node) any( strcmp( superclasses( node), "BaseNode"));
            % Now check for name arguments
            isValidName = @(name) isstring( name) || ischar( name);
            
            % Add node first, then we check for 'name'.
            p = inputParser;
            addRequired( p, 'node', isValidNode);
            addRequired( p, 'name', isValidName);
            % Parse
            parse( p, node, name);
            
            node = p.Results.node;
            
            if isstring( p.Results.node.name) 
                % Node has a name.
                % Check if node already exists in the graph
                if obj.G.numnodes > 0 && findnode( obj.G, p.Results.node.name)
                    error("The same node with name '%s' already exists in the graph", ...
                        p.Results.node.name);
                end
                if ~strcmp( p.Results.node.name, ...
                    p.Results.name)
                    warning(['Provided name does not match the name ',...
                        'in the node. The node name will be overwritten']);

                    % Update name in the provided node
                    node.setName( name);
                end
            end
            
            % Get the node table
            node_table = obj.constructNodeTable( name, node, 'variable');
            % Add node to the graph
            obj.G = addnode( obj.G, node_table);
        end
        
        function obj = addFactorNode()
        end
        
        function tab = constructNodeTable( obj, name, node, node_class)
            %CONSTRUCTNODETABLE Constructs a node table to pass it to the
            %graphs `addnode' function.
            %
            % @params[in] name : string
            %   Node generic name (e.g., "Pose", or "X") without a specific ID.
            % @params[in] node_type : string
            %   The node_type of the node (instance of a derived BaseNode
            %   class). Obtain this using `someNode.type'.
            % @params[in] node_class : string
            %   Specified whether the node is a 'variable' or 'factor'
            %
            % @params[out] tab : table
            %   Table of the nodes added. It'll contain the following columns:
            %       1. 'Name' : a unique node identifier in the ENTIRE factor
            %           graph. 
            %       2. 'id'   : a unique node identifier within nodes with the
            %           SAME NAME (not only same type, but also same name).
            %       3. 'Class' : string
            %           Classification of node type: either 'Variable', or
            %           'Factor'.
            %       4. 'CellNodeObject' : a cell that contains a the node
            %       object. The node object should have 'id' and 'name' that
            %       matches the graph's 'id' and 'Name'
                        
            % I need the node type to call the NodeClass.
            switch node_class                
                case 'variable'
                    % This is a variable node
                    node_id = obj.getVariableNodeNameIndex( name);

                    % Unique name with identifier
                    unique_name = strcat( name, "_", string( node_id));

                    tab = table( unique_name, ...
                        node_id, "Variable", { node}, 'VariableNames', {'Name', ...
                        'ID', 'Class', 'CellNodeObject'});
                
                case 'factor'
                    % This is a factor node            

                    node_id = obj.getFactorNodeNameIndex( name);

                    % Unique name with identifier
                    unique_name = strcat( name, "_", node_id);

                    tab = table( unique_name, ...
                        node_id, 'Factor', { node}, 'VariableNames', {'Name', ...
                        'ID', 'Class', 'CellNodeObject'});
                
                otherwise
                    error("Invalid node_class")
            end
                    
            
            % Set the node ID to be the same as the extracted node_id.
            node.setId( node_id);
            
            % Set the name to be the same as the extracted node_id.
            node.setName( unique_name);
        end
        
        function node_id = getFactorNodeNameIndex( obj, name)
            %GETFACTORNODETYPEINDEX Returns the id in the array of
            %factor node names. If the node name doesn't exist, it'll create
            %a new node name.
            %
            % @params[in] name : string
            %   Generic name of the node (e.g., "L" or "Landmark") without the
            %   unique identifier (such as _1).
            %
            % @params[out] node_id : int8
            %   Id for this node with such node name
            
            % Get the index of variable node type
            idx_factor_node_name = find( strcmp( obj.factor_node_names,...
                name));

            % It the node_type doesn't exist, it'll return an empty variable.
            if isempty( idx_factor_node_name)
                % If index is empty then it means that no such variable node
                % exists.

                % Create node type.
                obj.factor_node_names( length( obj.factor_node_names)...
                    + 1) = name;
                % Increment number of instances of this node type
                obj.num_factor_node_names( length( obj.num_factor_node_names)...
                    + 1) = int8( 1);
                
            else
                % Increment number of nodes with the same generic name
                obj.num_factor_node_names( idx_factor_node_name) = ...
                    obj.num_factor_node_names( idx_factor_node_name) + 1;
                return;
            end
            node_id = obj.num_factor_node_names( idx_factor_node_name);
        end
        
        function node_id = getVariableNodeNameIndex( obj, name)
            %GETVARIABLENODETYPEINDEX Returns the index in the array of
            %variable node names. If the node name doesn't exist, it'll create
            %a new node name.
            %
            % @params[in] name : string
            %   Generic name of the node (e.g., "X" or "Pose") without the
            %   unique identifier (e.g., _1).
            %
            % @params[out] node_id : int8
            %   Id for this node with such node name
            
%             % Get the index of variable node type
%             idx_variable_node_name = find( strcmp( obj.variable_node_names,...
%                 name));
%             
            idx_var_node_name = find( strcmp( [obj.variable_node_structs.name],...
                name));

            % It the node_type doesn't exist, it'll return an empty variable.
            if isempty( idx_var_node_name)
                % If index is empty then it means that no such variable node
                % exists.

                % Create node type.
                obj.variable_node_structs( length( obj.variable_node_structs) ...
                    + 1) = struct( 'name', name, 'num', int8( 1));

                node_id = int8( 1);
            else
                node_id = obj.variable_node_structs( ...
                    idx_var_node_name).num + int8( 1);
                obj.variable_node_structs( idx_var_node_name).num = ...
                    node_id;                
            end
        end
        
%         function idx = getVariableNodeTypeIndex( obj, node_type)
%             %GETVARIABLENODETYPEINDEX Returns the index in the array of
%             %variable node types. If the node type doesn't exist, it'll create
%             %a new node type.
%             %
%             % @params[in] node_type : string
%             %
%             % @params[out] idx : int8
%             %   Location in `obj.variable_node_types'.
%             
%             % Get the index of variable node type
%             idx_variable_node_type = find( strcmp( obj.variable_node_types,...
%                 node_type));
% 
%             % It the node_type doesn't exist, it'll return an empty variable.
%             if isempty( idx_variable_node_type)
%                 % If index is empty then it means that no such variable node
%                 % exists.
% 
%                 % Create node type.
%                 obj.variable_node_types( length( obj.variable_node_types)...
%                     + 1) = node_type;
%                 % Increment number of instances of this node type
%                 obj.num_variable_node_types( length( obj.num_variable_node_types)...
%                     + 1) = int8( 1);
%                 idx = length( obj.num_variable_node_types);
%             else
%                 idx = idx_variable_node_type;
%                 return;
%             end
%         end
    end
    
    properties (SetAccess = protected)
        % Graph object
        G;
        
        % Array of structs of the names (not types) of all the  VARIABLE nodes in the graph
        %   Each element contains two fields:
        %       1. 'name' : string
        %       2. 'num'  : number of variable nodes with the same generic name.
        variable_node_structs = struct( 'name', {}, 'num', []);
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explanation
%   Each node can either be a
%       1. variable node (the node to solve for), or
%       2. factor node (this contains the error function to be minimized).
%
%   I might need to do exception handling to manage the num_variable_node_names.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%