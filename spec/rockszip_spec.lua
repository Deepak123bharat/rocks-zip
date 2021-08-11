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

   setup(function ()
      local sys, processor = sysdetect.detect()
      fs.init({sys, "unix"})
   end)
    describe("zip.zip", function()
      
       it("Compress files in a .zip archive", function()
          assert.falsy(file_exists("spex/test.zip"))
          local ok, err = zip.zip("spec/test.zip", "spec/test.txt")
          assert.truthy(ok)
          assert.falsy(err)
          assert.truthy(file_exists("spec/test.zip"))
       end)

       it("Compress files in a .zip archive", function()
         assert.truthy(file_exists("spec/test.zip"))
         local ok, err = zip.unzip("spec/test.zip")
         assert.truthy(ok)
         assert.falsy(err)
      end)

      it("Compress files in a .zip archive", function()
         assert.truthy(file_exists("spec/test.zip"))
         local ok, err = zip.gzip("spec/test.zip", "spec/test.zip.gz")
         assert.falsy(err)
         assert.truthy(ok)
      end)
      it("Compress files in a .zip archive", function()
         assert.truthy(file_exists("spec/test.zip.gz"))
         local ok, err = zip.gunzip("spec/test.zip.gz", "spec/test.zip")
         assert.falsy(err)
         assert.truthy(ok)
         remove_files("spec", "%.zip$")
         remove_files("spec", "%.gz$")
      end)
    end)
end)