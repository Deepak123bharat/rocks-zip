local record zip
    
    --- Compress files in a .zip archive.
    -- @param zipfile string: pathname of .zip archive to be created.
    -- @param ... Filenames to be stored in the archive are given as
    -- additional arguments.
    -- @return boolean or (boolean, string): true on success,
    -- false and an error message on failure.
    zip: function(zipfile: string, ...: string): boolean, string

    --- Uncompress files from a .zip archive.
    -- @param zipfile string: pathname of .zip archive to be created.
    -- @return boolean or (boolean, string): true on success,
    -- false and an error message on failure.
    unzip: function(zipfile: string): boolean, string

    gzip: function(input_filename: string, output_filename: string): boolean , string

    gunzip: function(input_filename: string, output_filename: string): boolean , string

end

return zip