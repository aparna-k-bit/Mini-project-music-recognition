function [L, S, maxes] = find_landmarks(D, dilate_size)


    N = 512; 
    overlap = N/2; 
    window = hamming(N);

    [S, F, T] = spectrogram(D(:,1), window, overlap);
    S = S(1:end-1,:); 


    S = abs(S);
    S = max(S, max(S(:))/1e3); 
    S = 20*log10(S);
    S = S - mean(S(:)); 
    
    B = [1, -1]; A = [1, -0.98]; 
    S = filter(B, A, S.'); 
    S = S.'; 

    SE = strel('square', dilate_size); 
    S_dil = imdilate(S, SE);
    
    [row, col] = find(S == S_dil); 
    maxes = [row, col];


    
    L = NaN;
    tmaxes = sortrows(maxes,2);
    for i = 1:size(tmaxes, 1)
        ti = tmaxes(i, 2);
        fi = tmaxes(i, 1);
        
        [row, col] = find( (tmaxes(:, 2)-ti) < 64, 1, 'last');
        
        fmaxes = tmaxes(i+1:row, :);
        fmaxes = sortrows(fmaxes, 1);       
        [rowi, col] = find( abs(fmaxes(:, 1)-fi) < 32, 1, 'first');
        [rowe, col] = find( abs(fmaxes(:, 1)-fi) < 32, 1, 'last');
        
        J = fmaxes(rowi:rowe, :);
        
        if(length(J) > 0)
            l = [ones(size(J,1),1), ones(size(J,1),1), J(:,1) - fi, J(:,2) - ti];
            l(:,1) = ti;
            l(:,2) = fi;
            
            if(size(l,1) > 3)
                l = l(1:3, :);
            end
            
            if(length(L) > 1)
                L = [L; l];
            else
                L = l;
            end
        end
    end
end

