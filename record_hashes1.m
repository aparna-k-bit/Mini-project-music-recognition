function hashes = record_hashes(H, hashes)


    
    for i = 1:size(H,1)
        
        id = H(i,1);
        ti = H(i,2);
        hash = H(i,3);
        new_value = uint32(id*2^16 + ti);
        
        if isKey(hashes, hash)
            hashes(hash) = [hashes(hash), new_value];

        else
            hashes(hash) = new_value;

        end
    end

end

