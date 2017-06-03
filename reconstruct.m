% Reconstruct the audio signal from Gammatone coefficients and sparse coeficients

function [out] = reconstruct(VAL, CH, T, FB, Leng)
out = zeros(1, Leng);
for i = 1: 1: size(VAL,2)
    out(T(i): 1: T(i)+3999) =  out(T(i): 1: T(i) + 3999) + VAL(i)*FB(CH(i), :);
end

