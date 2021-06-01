function [z] = compute_ncc(x,y)
    v = sum(sum(x.*y));
    w = sum(sum(x.^2));
    z = v./w;
end