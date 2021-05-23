function H = landmark2hash( L, id_song )


H = zeros(size(L,1), 3);

H(:, 1) = id_song;
H(:, 2) = uint32(L(:, 1)); % ti
H(:, 3) = uint32(L(:, 2)*2^12 + L(:, 3)*2^6 + L(:, 4)); %hash_value
end

