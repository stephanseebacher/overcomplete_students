function orig = rle_decode(rle_code)

    actual_bit = rle_code(1);
    
    output_length = sum(rle_code)-actual_bit;
    orig = ones(1, output_length);
    
    orig_index = 1;
    for i=2:length(rle_code)
        for k=1:rle_code(i)
            orig(orig_index) = actual_bit;
            orig_index = orig_index + 1;
        end
        actual_bit = 1 - actual_bit;
    end

end

