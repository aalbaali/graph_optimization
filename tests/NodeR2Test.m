classdef NodeR2Test < matlab.unittest.TestCase & handle
    % Implementing a unit test suite from within a class
    
    % Try a constructor
    methods (Static = true)
        % Make this static as to be able to call it from within the test cases.
        function var = randVariable()
            % Generate a random variable that matches the node
            var = rand( 2, 1);
        end
        
        function var = randIncrement()
            % Generate a random increment that is supposed to work with oplus(
            % Variable, increment). In Lie groups, this could be the coordinates
            % of an element of Lie algebra.
            var = rand( 2, 1);
        end
        
        % Get class name
        function name = getClassName()
            name = "NodeR2";
        end
        % External functions can be passed in using a function handle. This
        % could be used to set measurements for example.
        function var = externalFunction( function_handle, varargin)
            var = function_handle( varargin{ :});
        end
        
    end
    
    methods (Test)
        % Test type
        function testTypeInternal( testCase)
            % Get class name
            className = eval( mfilename).getClassName();
            % Instantiate object
            node = eval( className);

            exp_output = eval( mfilename).getClassName();
            
            act_output = node.type;

            assertTrue( testCase, strcmp( exp_output, act_output));
        end
        
        % Initial value should be nans
        function testInitialValue( testCase)
            % Get class name
            className = eval( mfilename).getClassName();
            % Instantiate object
            node = eval( className);

            exp_output = nan;
            act_output = node.value;

            out = all( size( act_output) == size( exp_output)) && ...
                isnan( act_output);
            assertTrue( testCase, out);
        end
        
        function testSetValue( testCase)
            % Test if value is set properly
            
            % Get class name
            className = eval( mfilename).getClassName();
            
            % Generate a random variable
            variable = eval( mfilename).randVariable();
            
            % Instantiate object WITH the variable
            node = eval( className);
            
            node.setValue( variable);
            
            exp_output = variable;
            act_output = node.value;
            
            assertTrue( testCase, all( exp_output == act_output) ...
                && ~any(isnan( act_output)));
        end
        % oplus static
        function testOplusStatic( testCase)
            % Get class name
            className = eval( mfilename).getClassName();            
            % Get a random variable
            variable = eval( mfilename).randVariable();
            % Get a random increment (e.g., Lie algebra element)
            increment = eval( mfilename).randIncrement();
            

            exp_output = variable + increment;    
            act_output = eval( className).oplus( variable, increment);

            assertEqual( testCase, exp_output, act_output);    
        end
    end
end