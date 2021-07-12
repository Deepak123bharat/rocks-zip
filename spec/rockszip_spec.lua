local zipModule = require("rocks.zip")

describe("Luarocks zip test #unit", function()

    describe("zip.zip", function()
       it("Compress files in a .zip archive", function()
          local t, result = zipModule.zip("spec/test")
          assert.falsy(result)
          assert.truthy(t)
       end)
    end)
end)