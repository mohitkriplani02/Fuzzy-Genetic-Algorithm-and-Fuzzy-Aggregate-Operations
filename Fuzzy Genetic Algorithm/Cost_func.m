function Cost = Cost_func(Pop)

Cost = zeros(size(Pop,1),1);

for ii = 1:size(Pop,1)
    p = Pop(ii,:);
    C = sum(p.^2);
    Cost(ii,1) = C;
end

end