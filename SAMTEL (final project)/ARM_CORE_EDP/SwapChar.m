function str_out = SwapChar(str,sf,st)
% function str_out = SwapChar(str,sf,st)

%%
if nargin < 1
%%
    str = 'INV_X1_whoa_omg';
    sf = '_';
    st = '\_';
%%
end

%%
n = regexp(str,sf,'split');
str_out = n{1};
for k=2:length(n)
    str_out = [str_out,st,n{k}];
end 