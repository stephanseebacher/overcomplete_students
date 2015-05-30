function [ enc ] = get_bit_encoding(x,bit_number)
% compute encoding for x using bit_number bits in a string
% assume x between -1 and 1

possible_x=-1:2/(2^bit_number):1;

%compute mapping of x

%find closest val in possible x
[val idx]= min(abs(possible_x - x ));

% then mapping is simply binary of index-1 and need to compare to x
u=possible_x(idx);
idx=idx-1;

if (x<u)
    idx=idx-1;
end

%special case
if (x==1)
    idx=idx-1;
end

% now idx stores the decimal encoding of x
enc=dec2bin(idx);

% add zeros if size of enc smaller than bit_number
if (length(enc)<bit_number)
    for i=1:(bit_number-length(enc))
        enc=['0' enc];
    end
end
