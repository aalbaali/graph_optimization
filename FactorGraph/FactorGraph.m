classdef FactorGraph < handle
    % FactorGraph    Summary
    % Class that maintains a factor graph for inference. Uses BaseNode and
    % BaseEdge classes.
    methods (Access = public)
        function obj = FactorGraph( varargin)
            %FACTORGRAPH
            
            p = inputParser;
            
            % Valid verbosity            
            isValidVerb = @(verb) isscalar( verb) && isreal( verb) && verb >= 0;
            
            % Default verbosity
            defaultVerb = 0;
            
            addParameter( p, 'verb', defaultVerb, isValidVerb);
            
            parse( p, varargin{ :});
            
            obj.verbosity = p.Results.verb;
            
            % Initialize the graph
            obj.G = graph;
        end
        
        function obj = addVariableNode( obj, variable_node, varargin)
            %ADDVARIABLENODE Adds a variable node to the graph. Additional
            %arguments may be specified. 
            %@param[in][required] variable_node
            %   Instance  of a variable node class derived from BaseNode.
            %@params[in][required] 'name' : 
            %   This is a node name. It's a required parameter but can be
            %   specified inside node. 
            
            % Validators
            %   A node is a valid node if it's an instance of a class derived
            %   from BaseNode
            isValidNode = @(node) any( strcmp( superclasses( node), "BaseNode"));
            % Now check for name arguments
            isValidName = @(name) isstring( name) || ischar( name);
            
            defaultName = "X";            
            
            % Add node first, then we check for 'name'.
            p = inputParser;
            addRequired( p, 'node', isValidNode);
            addOptional( p, 'name', defaultName, isValidName);
            
            % Parse
            parse( p, variable_node, varargin{ :});
            
            variable_node = p.Results.node;
            name          = p.Results.name;
            
            if isstring( p.Results.node.name) 
                % Node has a name.
                % Check if node already exists in the graph
                if obj.findnodeUUID( p.Results.node.UUID)
                    warning("The same node with name '%s' already exists in the graph", ...
                        p.Results.node.name);
                    return;
                end
%                 if ~strcmp( p.Results.node.name, ...
%                     p.Results.name)
%                     warning(['Convlict between "name" and',...
%                         '"node.name". The "node.name" will be overwritten by "name"']);
% 
%                     % Update name in the provided node
%                     variable_node.setName( name);
%                 end
            end
            
            % Get the node table
            node_table = obj.constructNodeTable( name, variable_node, 'variable');
            
            % Add variable node to the graph
            obj.G = addnode( obj.G, node_table);
            
            obj.printf("Added variable node '%s' to graph\n", ...
                variable_node.name);
            
        end
        
        function idx = findnode( obj, node_name)
            %NODEEXISTS checks if a node with name `node_name' exists in the
            %graph. Returns the index of the node if the node exists. Otherwise,
            %it returns 0.
            % 
            % @params[in] node_name : string
            %   node_name
            
            % If number of nodes equal zero, then the index doesn't exist.
            if obj.G.numnodes == 0 
                idx = 0;
                return;
            else
                idx = findnode( obj.G, node_name);
            end
        end
        
        function idx = findnodeUUID( obj, UUID)
            % Find index of a node using UUID
            
            idx = find( arrayfun( @(kk) obj.G.Nodes.UUID( kk) == UUID, 1 : ...
                obj.G.numnodes));
            if isempty( idx)
                idx = 0;
            end
        end
        
        function obj = addFactorNode( obj, factor_node, varargin)
            % Add a factor node to the graph. Since factor graphs should be
            % bipartite graphs, then there will be edges between factor nodes
            % and edge nodes. This method will add the necessary edges.
            %
            % @param[in][required] factor_node
            %   Instance of a factor node class derived from BaseFactor class.
            % @params[in][required] 'name' : 
            %   This is a factor_node name. It's a required parameter but can be
            %   specified inside node.
            % @params[in][parameter] 'end_nodes'
            %   Variable nodes linked/attached to the factor node. They'll be
            %   created if they don't exist already
            
            % Validators
            %   A node is a valid node if it's an instance of a class derived
            %   from BaseFactor
            isValidNode = @(node) any( strcmp( superclasses( node), "BaseFactor"));
            % Now check for name arguments
            isValidName = @(name) isstring( name) || ischar( name);
            % Optional parameter: end_node types match the factor node
            isValidEndNode = @(end_nodes) all( arrayfun(@(kk) strcmp( ...
                factor_node.endNodeTypes( kk), end_nodes{ kk}.type), ...
                1 : length( end_nodes)));
            % EndNodeNames
            isValidEndNodeNames = @(end_node_names) length( end_node_names) ...
                == factor_node.numEndNodes && all( isstring( end_node_names));
            
            % Default vaue is whatever is in factor_node.end_nodes (even if it's
            % empty).
            defaultEndNode = factor_node.end_nodes;
            defaultEndNodeNames = [];
            defaultName = "F";
            
            % Add node first, then we check for 'name'.
            p = inputParser;
            addRequired ( p, 'node', isValidNode);
            addParameter( p, 'name', defaultName, isValidName);
            addParameter( p, 'end_nodes', defaultEndNode, isValidEndNode);
            addParameter( p, 'node_names', defaultEndNodeNames, isValidEndNodeNames);
            % Parse            
            parse( p, factor_node, varargin{:});
            
            factor_node = p.Results.node;
            name        = p.Results.name;
            end_nodes_in   = p.Results.end_nodes;
            end_node_names = p.Results.node_names;
            
            % Compare end_nodes with the end_nodes from the factor_node. 
            if any( cellfun( @isempty, end_nodes_in))
                % Check the end_node names
                if ~isempty( end_node_names)
                    % Fill in the end_nodes using the end_node_names string
                    % array
                    for lv1 = 1 : factor_node.numEndNodes
                        % Find end node
                        idx = obj.findnode( end_node_names( lv1));
                        end_node_lv1 = obj.G.Nodes.CellNodeObject{ idx};
                        factor_node.setEndNode( lv1, end_node_lv1);
                    end
                end
            else
                % Check for every element of factor_node. Store `end_node_in'
                % only if `factor_node.end_node{kk}' is nan or they're both the
                % same (check the UUID).
                for kk = 1 : factor_node.numEndNodes
                    if isempty( factor_node.end_nodes{ kk})
                        factor_node.setEndNode( kk, end_nodes_in{ kk});
                    elseif factor_node.end_nodes{ kk}.UUID ...
                            ~= end_nodes_in{ kk}.UUID
                        % Output error if both UUIDs don't match
                        error("Conflict in end_nodes");
                    end
                    
                    % For each end_node, check if needs to be added to graph                    
                    if ~obj.findnodeUUID( end_nodes_in{ kk}.UUID)
                        obj.addVariableNode( end_nodes_in{ kk});
                        
%                         % warning('Adding node to graph');
%                         obj.printf("Added variable node '%s' to graph\n", ...
%                             end_nodes_in{ kk}.name);
                    end                    
                end
            end
            
            % Check if factor node already exists in the graph
            if isstring( factor_node.name) 
                % Check if the factor node has a string.
                
                % Node has a name.
                % Check if node already exists in the graph
                if obj.findnode( factor_node.name) ...
                        || obj.findnodeUUID( factor_node.UUID)
                    obj.warn( 0, "The same node with name '%s' already exists in the graph", ...
                        factor_node.name);
                    return;
                end
                
                % Compare input name with factor node name
                if ~strcmp( factor_node.name, ...
                    p.Results.name)
                    warning(['Provided name does not match the name ',...
                        'in the node. The node name will be overwritten']);

                    % Update name in the provided node
                    factor_node.setName( name);
                end
            end
            
            % Get the node table
            node_table = obj.constructNodeTable( name, factor_node, 'factor');
                        
            % Add node to the graph
            obj.G = addnode( obj.G, node_table);
            
            obj.printf( "Added factor node '%s' to graph\n", factor_node.name);
            
            % Add edges to the graph
            obj.addEdges( factor_node);
        end
        
        function obj = addEdges( obj, factor_node)
            %ADDEDGES Takes the end edges from a factor node and does the
            %following:
            %   1. adds the nodes from end_edges if not already in the graph;
            %   2. adds the edges between the variable_nodes and the factor
            %   nodes.
            
            % End nodes
            end_nodes = factor_node.end_nodes;
            % Go over each end_node and add an edge.
            for lv1 = 1 : factor_node.numEndNodes
                % Create table
                tab = table( { convertStringsToChars( factor_node.name), ...
                    convertStringsToChars( end_nodes{ lv1}.name )}, ...
                    factor_node.name, string( factor_node.UUID), 'VariableNames', ...
                    {'EndNodes', 'FactorName', 'FactorUUID'});
                % Add edge to table
                obj.G = addedge( obj.G, tab);
            end
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
            %       5. 'uuid' : Universally unique identifier
                        
            % I need the node type to call the NodeClass.
            switch node_class                
                case 'variable'
                    % This is a variable node
                    node_id = obj.getVariableNodeNameIndex( name);

                    % Unique name with identifier
                    unique_name = strcat( name, "_", string( node_id));

                    tab = table( unique_name, ...
                        node_id, "Variable", { node}, node.UUID, ...
                        'VariableNames', {'Name', 'ID', 'Class', ...
                        'CellNodeObject', 'UUID'});
                
                case 'factor'
                    % This is a factor node            

                    node_id = obj.getFactorNodeNameIndex( name);

                    % Unique name with identifier
                    unique_name = strcat( name, "_", string( node_id));

                    tab = table( unique_name, ...
                        node_id, "Factor", { node}, node.UUID, ...
                        'VariableNames', {'Name', 'ID', 'Class', ...
                        'CellNodeObject', 'UUID'});
                
                otherwise
                    error("Invalid node_class")
            end
                    
            
            % Set the node ID to be the same as the extracted node_id.
            node.setId( node_id);
            
            % Set the name to be the same as the extracted node_id.
            node.setName( unique_name);
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
        
        function node_id = getFactorNodeNameIndex( obj, name)
            %GETFACTORNODETYPEINDEX Returns the index in the array of
            %factor node names. If the node name doesn't exist, it'll create
            %a new node name.
            %
            % @params[in] name : string
            %   Generic name of the node (e.g., "F" or "Factor") without the
            %   unique identifier (e.g., _1).
            %
            % @params[out] node_id : int8
            %   Id for this node with such node name

            idx_fact_node_name = find( strcmp( [obj.factor_node_structs.name],...
                name));

            % It the node_type doesn't exist, it'll return an empty variable.
            if isempty( idx_fact_node_name)
                % If index is empty then it means that no such variable node
                % exists.

                % Create node type.
                obj.factor_node_structs( length( obj.factor_node_structs) ...
                    + 1) = struct( 'name', name, 'num', int8( 1));

                node_id = int8( 1);
            else
                node_id = obj.factor_node_structs( ...
                    idx_fact_node_name).num + int8( 1);
                obj.factor_node_structs( idx_fact_node_name).num = ...
                    node_id;                
            end
        end
        
    end
    
    methods
        function set.verbosity( obj, verb)
            obj.verbosity = verb;
        end
    end
    
    
    methods (Access = private)
        function printf( obj, varargin)
            % A function that prints to the console based on verbosity
            switch obj.verbosity
                case 0                    
                case 1
                    fprintf( varargin{ :});
            end
        end
        
        function warn( obj, level, message, varargin)
            % Internal wanring message system. 
            % @params[in] message   :   sprintf object
            %   The message to print to the console
            % @params[in] level     :   int8 >= 0
            %   Level of severity. Here are the levels.
            %       0   :   Message
            %       1   :   Warning
            %       2   :   Error
            switch level
                case 0
                    obj.printf( message, varargin{ :});
                case 1
                    warning( message, varargin{ :});
                case 2
                    error( message, varargin{ :});
            end
        end
    end
    properties 
        % Verbosity: 0, 1
        verbosity = 0;
    end
    properties (SetAccess = protected)
        % Graph object
        G;
        
        % Array of structs of the names (not types) of all the  VARIABLE nodes in the graph
        %   Each element contains two fields:
        %       1. 'name' : string
        %       2. 'num'  : number of variable nodes with the same generic name.
        variable_node_structs = struct( 'name', {}, 'num', []);
        % Same struct array but for factor nodes
        factor_node_structs = struct( 'name', {}, 'num', []);
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