%% Fuzzy Aggregation Operations

function [union_standard,union_algebraic,sum_bounded,sum_drastic,sum_himachor,union_yagerclass,sum_simple_disjoint,sum_disjunctive,sum_disjoint,union_dubois_prade,intersection_standard,product_algebraic,product_bounded,product_drastic,product_himachor,intersection_yagerclass,minimum_nilpotent,intersection_dubois_prade,and_fuzzy,or_fuzzy] = fuzzy_aggregate(A,B)
    % Union aggregation operations
    union_standard = standard_union(A,B);
    union_algebraic = algebraic_sum(A,B);
    sum_bounded = bounded_sum(A,B);
    sum_drastic = drastic_sum(A,B);
    h_gamma = 1;
    sum_himachor = himachor_sum(A,B,h_gamma);
    yc_w = 2;
    union_yagerclass = yagerclass_union(A,B,yc_w);
    sum_simple_disjoint = simple_disjoint_sum(A,B);
    sum_disjunctive = disjunctive_sum(A,B);
    sum_disjoint = disjoint_sum(A,B);
    dp_alpha = 1;
    union_dubois_prade = dubois_prade_union(A,B,dp_alpha);

    % Intersection aggregation operations
    intersection_standard = standard_intersection(A,B);
    product_algebraic = algebraic_product(A,B);
    product_bounded = bounded_product(A,B);
    product_drastic = drastic_product(A,B);
    h_gamma = 1;
    product_himachor = himachor_product(A,B,h_gamma);
    w = 2;
    intersection_yagerclass = yagerclass_intersection(A,B,w);
    minimum_nilpotent = nilpotent_minimum(A,B);
    dp_alpha = 1;
    intersection_dubois_prade = dubois_prade_intersection(A,B,dp_alpha);

    % Averaging aggregation operations
    gamma_and=1;
    gamma_or=1;
    and_fuzzy = fuzzy_and(A,B,gamma_and);
    or_fuzzy = fuzzy_or(A,B,gamma_or);

end

% Union Functions

function f=standard_union(a,b)
    f=max(a,b);
end

function f=algebraic_sum(a,b)
    f=a+b-a.*b;
end

function f=bounded_sum(a,b)
    f=min(1,a+b);
end

function f=drastic_sum(a,b)
    f=[];
    L=length(a);
    for i=1:L
        if a(i)==0
             x=b(i);
        elseif b(i)==0
            x=a(i);
        else
            x=1;
        end
        f=[f x];
    end
end

function f=himachor_sum(a,b,gamma)
    f=[];
    L=length(a);
    for i=1:L
        x=(a(i)+b(i)-(2-gamma)*a(i)*b(i))/(1-(1-gamma)*a(i)*b(i));
        f=[f x];
    end
end

function f=yagerclass_union(a,b,w)
    f=min(1,(a.^w + b.^w).^(1/w));
end

function f=simple_disjoint_sum(a,b)
    f=max(min(a,1-b),min(1-a,b));
end

function f=disjunctive_sum(a,b)
    f=min(max(a,1-b),max(1-a,b));
end

function f=disjoint_sum(a,b)
    f=abs(a-b);
end

function f=dubois_prade_union(a,b,alpha)
    f=[];
    L=length(a);
    for i=1:L
        x=(a(i)+b(i)-a(i)*b(i)-min(min(a(i),b(i)),1-alpha))/max(max(1-a(i),1-b(i)),alpha);
        f=[f x];
    end
end

% Intersection Functions

function f=standard_intersection(a,b)
    f=min(a,b);
end

function f=algebraic_product(a,b)
    f=a.*b;
end

function f=bounded_product(a,b)
    f=max(0,a+b-1);
end

function f=drastic_product(a,b)
    f=[];
    L=length(a);
    for i=1:L
        if a(i)==1
            x=b(i);
        elseif b(i)==1
            x=a(i);
        else
            x=0;
        end
        f=[f x];
    end
end

function f=himachor_product(a,b,gamma)
    f=[];
    L=length(a);
    for i=1:L
        x=(a(i)*b(i))/(gamma+(1-gamma)*(a(i)+b(i)-a(i)*b(i)));
        f=[f x];
    end
end

function f=yagerclass_intersection(a,b,w)
    f=1-min(1,((1-a).^w + (1-b).^w).^(1/w));
end

function f=nilpotent_minimum(a,b)
    f=[];
    L=length(a);
    for i=1:L
        if (a(i)+b(i))>=1
            x=min(a(i),b(i));
        else
            x=0;
        end
        f=[f x];
    end
end

function f=dubois_prade_intersection(a,b,alpha)
    f=[];
    L=length(a);
    for i=1:L
        x=(a(i)*b(i))/max(max(a(i),b(i)),alpha);
        f=[f x];
    end
end

% Averaging Operations

function f=fuzzy_and(a,b,gamma)
    f=[];
    L=length(a);
    for i=1:L
        x=gamma*min(a(i),b(i)) + (1-gamma)*((a(i)+b(i))/2);
        f=[f x];
    end
end

function f=fuzzy_or(a,b,gamma)
    f=[];
    L=length(a);
    for i=1:L
        x=gamma*max(a(i),b(i)) + (1-gamma)*((a(i)+b(i))/2);
        f=[f x];
    end
end
