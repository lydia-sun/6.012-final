function [val,pargs] = getarg(pargs,prop,defval)
% function [val,pargs] = getarg(pargs,prop,defval)

%%
if nargin < 3
    defval = [];
end
%%
idx = strcmpi(pargs,prop);
pos = find(idx,1);
if isempty(pos)
    val = defval;
else
    val = pargs{pos+1};
    if nargout > 1
        idx(pos+1) = true;
        pargs = pargs(~idx);
    end
end