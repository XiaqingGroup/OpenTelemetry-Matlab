% Licensed to the Apache Software Foundation (ASF) under one
% or more contributor license agreements.  See the NOTICE file
% distributed with this work for additional information
% regarding copyright ownership.  The ASF licenses this file
% to you under the Apache License, Version 2.0 (the
% "License"); you may not use this file except in compliance
% with the License.  You may obtain a copy of the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing,
% software distributed under the License is distributed on an
% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
% KIND, either express or implied.  See the License for the
% specific language governing permissions and limitations
% under the License.

toolboxFolder = string(getenv("OTEL_MATLAB_TOOLBOX_FOLDER"));
outputFolder = string(getenv("OTEL_MATLAB_TOOLBOX_OUTPUT_FOLDER"));
toolboxVersionRaw = string(getenv("OTEL_MATLAB_TOOLBOX_VERSION"));

% Output folder must exist.
mkdir(outputFolder);

disp("Toolbox Folder: " + toolboxFolder);
disp("Output Folder: " + outputFolder);
disp("Toolbox Version Raw: " + toolboxVersionRaw);

% Note: This string processing heuristic may not be robust to future
% changes in the versioning scheme.
dotIdx = strfind(toolboxVersionRaw, ".");
numDots = numel(dotIdx);
if numDots >= 3
    toolboxVersion = extractBefore(toolboxVersionRaw, dotIdx(3));
else
    toolboxVersion = toolboxVersionRaw;
end

disp("Toolbox Version:" + toolboxVersion);

identifier = "ad1d0fe6-22d1-4969-9e6f-0ab5d0f12ce3";
opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder, identifier);
opts.ToolboxName = "MATLAB Interface to OpenTelemetry";
opts.ToolboxVersion = toolboxVersion;
opts.AuthorName = "";
opts.AuthorEmail = "";

% Set the SupportedPlatforms
opts.SupportedPlatforms.Win64 = true;
opts.SupportedPlatforms.Maci64 = true;
opts.SupportedPlatforms.Glnxa64 = true;
%opts.SupportedPlatforms.MatlabOnline = true;

% Interface is only qualified against R2023a at the moment
opts.MinimumMatlabRelease = "R2023a";
opts.MaximumMatlabRelease = "R2023a";

%opts.OutputFile = fullfile(outputFolder, compose("otel-matlab-%s.mltbx", toolboxVersionRaw));
opts.OutputFile = fullfile(outputFolder, "otel-matlab.mltbx");
disp("Output File: " + opts.OutputFile);
matlab.addons.toolbox.packageToolbox(opts);
