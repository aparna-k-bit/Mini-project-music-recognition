 function add_tracks( directory_name)
[hashes, song_id] = create_database(directory_name);
dirlist = dir(directory_name);
debug = 0;


for i = 1:length(dirlist)
    [pathstr, name, ext] = fileparts(dirlist(i).name);
    if (strcmp(ext,'.mp3') || strcmp(ext,'.wav') || strcmp(ext,'.wave'))

        if debug == 0
            STR = sprintf('song_id: %d - Track: %s', song_id, dirlist(i).name);
            disp(STR);
       
  
        
        file_name = strcat(directory_name,'/',dirlist(i).name);
        [y,Fs] = audioread(file_name);
       
        
        [P,Q] = rat(8000/Fs);
        x = resample(y,P,Q);
        
        
        
       
        [L, S, maxes] = find_landmarks(x, 30);
        
      
        
        H = landmark2hash(L, song_id);
   
        
        hashes = record_hashes(H, hashes);
        
       
       
      
        
        song_id = song_id+1;
    end
end


    next_song_id = song_id;
    save(strcat(directory_name,'/','hashes'), 'hashes', 'next_song_id');

  
end

