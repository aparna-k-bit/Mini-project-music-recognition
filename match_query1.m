function [ ans1 ] = match_query( query, database )

    
    load(database);
    song_id = -1;

  
    [y,Fs] = audioread(query);
    
    [P,Q] = rat(8000/Fs);
    x = resample(y,P,Q);
  
    
    [L, S, maxes] = find_landmarks(x, 30);
    H = landmark2hash(L, song_id);
    show_landmarks(L,S,maxes);
    pause
    close

   
    R = get_hash_hits(H, hashes);
  
    [uoffset, ind_first] = unique(R(:,1), 'first');
    
   
    nr = size(R,1);
    utrkcounts = diff([ind_first', nr+1]).';
    
    R_data = [uoffset, ind_first, utrkcounts];
    R_data = sortrows(R_data, -3);
    
  
    if length(uoffset) > 20
        R_data = R_data(1:20, :);
    end
    
    
    nt = size(R_data, 1);
    Res = ones(nt, 3); 
    
    inis = R_data(:,2);
    ends = (R_data(:,2)+R_data(:,3)-1);
    
    for i = 1:nt
        r = sortrows(R(inis(i):ends(i), :), 2);
        [uoffset, ind_first] = unique(r(:,2), 'first');
        nr = size(r,1);
        utrkcounts = diff([ind_first', nr+1]).';

        r_data = [uoffset, ind_first, utrkcounts];
        [C, I] = max(utrkcounts);
        Res(i,:) = [r(1,1), r_data(I, 1), r_data(I,3)];
    end
    
    R = sortrows(Res, -3);
    ans1 = R(1:1,:)
end

