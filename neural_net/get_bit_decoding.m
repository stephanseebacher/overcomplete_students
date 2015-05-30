function [ dec ] = get_bit_decoding(bits_read,quanitization_bits);

% compute decoding
possible_enc=-1:2/(2^quanitization_bits):1;

dec=possible_enc(bin2dec(bits_read)+1);

end
