function [ enc ] = get_bit_encoding(x,qunanitization_bits)
% compute encoding for x using qunanitization_bits bits in a string
% assume x between -1 and 1

%find possible mapping
possible_x=-1:2/(2^qunanitization_bits):1;

%compute mapping of x
%find closest val in possible x
[~,idx]= min(abs(possible_x - x ));

% then mapping is simply binary of index-1 and need to compare to x
u=possible_x(idx);
idx=idx-1;

%special case
if (idx == 2^qunanitization_bits)
    idx=idx-1;
end

% now idx stores the decimal encoding of x
enc=dec2bin(idx);

% add zeros if size of enc smaller than qunanitization_bits
if (length(enc)<qunanitization_bits)
    tmp_enc=char(zeros(1,qunanitization_bits-length(enc)));
    for i=1:(qunanitization_bits-length(enc))
        tmp_enc(i)='0';
    end
    enc=[tmp_enc enc];
end
