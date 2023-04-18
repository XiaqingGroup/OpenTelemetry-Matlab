classdef OtlpGrpcSpanExporter < opentelemetry.sdk.trace.SpanExporter
% OtlpGrpcSpanExporter exports spans in OpenTelemetry Protocol format via 
% gRPC. By default, it exports to the default address of the OpenTelemetry
% Collector.

% Copyright 2023 The MathWorks, Inc.

    properties (SetAccess=immutable)
        Endpoint (1,1) string
        UseCredentials  (1,1) logical
        CertificatePath (1,1) string
        CertificateString (1,1) string
        Timeout (1,1) duration
        HttpHeaders (1,1) dictionary
    end

    methods
        function obj = OtlpGrpcSpanExporter(optionnames, optionvalues)
            arguments (Repeating)
                optionnames (1,:) {mustBeTextScalar}
                optionvalues
            end

            validnames = ["Endpoint", "UseCredentials ", "CertificatePath", ...
                "CertificateString", "Timeout", "HttpHeaders"];
            % set default values to empty or negative
            endpoint = "";
            usessl = false;
            certificatepath = "";
            certificatestring = "";
            timeout_millis = -1;
            headerkeys = string.empty();
            headervalues = string.empty();
            for i = 1:length(optionnames)
                namei = validatestring(optionnames{i}, validnames);
                valuei = optionvalues{i};
                if strcmp(namei, "Endpoint")
                    if ~(isStringScalar(valuei) || (ischar(valuei) && isrow(valuei)))
                        error("Endpoint must be a scalar string.");
                    end
                    endpoint = string(valuei);
                elseif strcmp(namei, "UseCredentials ")
                    if ~((islogical(valuei) || isnumeric(valuei)) && isscalar(valuei))
                        error("UseCredentials  must be a scalar logical.")
                    end
                    usessl = logical(valuei);
                elseif strcmp(namei, "CertificatePath")
                    if ~(isStringScalar(valuei) || (ischar(valuei) && isrow(valuei)))
                        error("CertificatePath must be a scalar string.");
                    end
                    certificatepath = string(valuei);
                elseif strcmp(namei, "CertificateString")
                    if ~(isStringScalar(valuei) || (ischar(valuei) && isrow(valuei)))
                        error("CertificateString must be a scalar string.");
                    end
                    certificatestring = string(valuei);
                elseif  strcmp(namei, "Timeout") 
                    if ~(isduration(valuei) && isscalar(valuei)) 
                        error("Timeout must be a scalar duration.");
                    end
                    timeout = valuei;
                    timeout_millis = milliseconds(timeout);
                else  % HttpHeaders
                    if ~isa(valuei, "dictionary")
                        error("HttpHeaders input must be a dictionary.");
                    end
                    httpheaders = valuei;
                    headerkeys = keys(valuei);
                    headervalues = values(valuei);
                    if ~isstring(headervalues)
                        error("HttpHeaders dictionary values must be strings.")
                    end
                end
            end
            
            obj = obj@opentelemetry.sdk.trace.SpanExporter(...
                "libmexclass.opentelemetry.exporters.OtlpGrpcSpanExporterProxy", ...
                endpoint, usessl, certificatepath, certificatestring, ...
                timeout_millis, headerkeys, headervalues);

            % populate immutable properties
            [defaultendpoint, defaultcertpath, defaultcertstring, defaultmillis] = ...
                getDefaultOptionValues(obj);
            if endpoint == ""  % not specified, use default value
                obj.Endpoint = defaultendpoint;
            else
                obj.Endpoint = endpoint;
            end            
            obj.UseCredentials  = usessl;
            if certificatepath == ""  % not specified, use default value
                obj.CertificatePath = defaultcertpath;
            else
                obj.CertificatePath = certificatepath;
            end
            if certificatestring == ""  % not specified, use default value
                obj.CertificateString = defaultcertstring;
            else
                obj.CertificateString = certificatestring;
            end
            if timeout_millis < 0  % not specified, use default value
                obj.Timeout = milliseconds(defaultmillis);
            else
                obj.Timeout = timeout;
            end
            if isempty(headerkeys)  % not specified, return empty dictionary
                obj.HttpHeaders = dictionary(headerkeys, headervalues);
            else
                obj.HttpHeaders = httpheaders;
            end
            
        end
    end
end