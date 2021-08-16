local zip = require("rocks.zip")
local fs = require("rocks.fs")
local lfs = require("lfs")
local sysdetect = require("rocks.sysdetect")

describe("Luarocks zip test #unit", function()

   local file_exists = function (path)
      return lfs.attributes(path, "mode") ~= nil
   end

   local remove_files = function (path, pattern)
      local result_check = false
      if file_exists(path) then
         for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
               if file:find(pattern) then
                  if os.remove(path .. "/" .. file) then
                     result_check = true
                  end
               end
            end
         end
      end
      return result_check
   end

   local platform_sets = {
      freebsd = { unix = true, bsd = true, freebsd = true },
      openbsd = { unix = true, bsd = true, openbsd = true },
      solaris = { unix = true, solaris = true },
      windows = { windows = true, win32 = true },
      cygwin = { unix = true, cygwin = true },
      macosx = { unix = true, bsd = true, macosx = true, macos = true },
      netbsd = { unix = true, bsd = true, netbsd = true },
      haiku = { unix = true, haiku = true },
      linux = { unix = true, linux = true },
      mingw = { windows = true, win32 = true, mingw32 = true, mingw = true },
      msys = { unix = true, cygwin = true, msys = true },
      msys2_mingw_w64 = { windows = true, win32 = true, mingw32 = true, mingw = true, msys = true, msys2_mingw_w64 = true },
   }
   
   setup(function ()
      local plats = {}
      local sys, _ = sysdetect.detect()
      for key, _ in pairs(platform_sets) do
         if key == sys then
            for platforms, _ in pairs(platform_sets[key]) do
               plats[#plats+1] = platforms
            end
         end
      end
       
      fs.init(plats)
   end)

   describe("zip.zip", function()
      
      it("Creating zip archive without any input file", function()
         finally(function ()
            remove_files("spec", "empty_zip_archive.zip")
         end)
         assert.falsy(file_exists("spec/empty_zip_archive.zip"))
         local ok, err = zip.zip("spec/empty_zip_archive.zip")
         assert.truthy(ok)
         assert.falsy(err)
         assert.truthy(file_exists("spec/empty_zip_archive.zip"))
      end)

      it("Compress files in a .zip archive", function()
         finally(function ()
            remove_files("spec", "test_zip.zip")
         end)
         assert.falsy(file_exists("spec/test_zip.zip"))
         local ok, err = zip.zip("spec/test_zip.zip", "spec/test.txt")
         assert.truthy(ok)
         assert.falsy(err)
         assert.truthy(file_exists("spec/test_zip.zip"))
      end)

      it("unompress .zip file", function()
         assert.truthy(file_exists("spec/test_unzip.zip"))
         local ok, err = zip.unzip("spec/test_unzip.zip")
         assert.truthy(ok)
         assert.falsy(err)
      end)

      it("Compress files in a .gz archive", function()
         finally(function ()
            remove_files("spec", "test_gz.zip.gz")
         end)
         assert.truthy(file_exists("spec/test_gz.zip"))
         assert.falsy(file_exists("spec/test_gz.zip.gz"))
         local ok, err = zip.gzip("spec/test_gz.zip", "spec/test_gz.zip.gz")
         assert.falsy(err)
         assert.truthy(ok)
         assert.truthy(file_exists("spec/test_gz.zip.gz"))
      end)

      it("uncompress .gz file", function()
         finally(function ()
            remove_files("spec", "test_gunzip.zip$")
         end)
         assert.truthy(file_exists("spec/test_gunzip.zip.gz"))
         assert.falsy(file_exists("spec/test_gunzip.zip"))
         local ok, err = zip.gunzip("spec/test_gunzip.zip.gz", "spec/test_gunzip.zip")
         assert.falsy(err)
         assert.truthy(ok)
         assert.truthy(file_exists("spec/test_gunzip.zip"))
         --remove_files("spec", "test_gunzip.zip.gz")
      end)
    end)
end)