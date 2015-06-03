function extracted_data = test_bla( compressed_data, quanitization_bits)


%TODO: Eliminate last, not-used 2 bits or so
size_compr_data = size(compressed_data,2)*quanitization_bits

extracted_data = ones(size_compr_data, 1);
extracted_data_index = 1;

for i=1:size(compressed_data,2)
    current_c = compressed_data(i);
    for bit_index=8:-1:1
        extracted_data(extracted_data_index) = bitget(current_c,bit_index);
        extracted_data_index = extracted_data_index + 1;
    end   
end

end

