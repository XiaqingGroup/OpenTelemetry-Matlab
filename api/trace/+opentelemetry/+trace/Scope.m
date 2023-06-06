classdef Scope < handle
% Controls the duration when a span is current. Deleting a scope object
% makes the associated span no longer current.

% Copyright 2023 The MathWorks, Inc.

    properties (Access=private)
        Proxy   % Proxy object to interface C++ code
    end

    methods (Access=?opentelemetry.trace.Span)
        function obj = Scope(proxy)
            obj.Proxy = proxy;
        end
    end

end
