local android = require "android"
local ffi = require "ffi"

-- Define the Bitmap class
ffi.cdef[[
    typedef struct {
        uint32_t    width;
        uint32_t    height;
        uint32_t    stride;
        uint32_t    format;
        uint8_t*    buffer;
    } AndroidBitmapInfo;

    enum {
        ANDROID_BITMAP_FORMAT_NONE    = 0,
        ANDROID_BITMAP_FORMAT_RGBA_8888   = 1,
        ANDROID_BITMAP_FORMAT_RGB_565 = 4,
        ANDROID_BITMAP_FORMAT_RGBA_4444   = 7,
        ANDROID_BITMAP_FORMAT_A_8  = 8,
    };

    int AndroidBitmap_getInfo(JNIEnv* env, jobject jbitmap, AndroidBitmapInfo* info);
    int AndroidBitmap_lockPixels(JNIEnv* env, jobject jbitmap, void** addrPtr);
    int AndroidBitmap_unlockPixels(JNIEnv* env, jobject jbitmap);
]]

-- Define the Bitmap class
android.graphics.Bitmap = {}
android.graphics.Bitmap.__index = android.graphics.Bitmap

-- Konstruktor
function android.graphics.Bitmap.new(env, jbitmap)
    local self = setmetatable({}, android.graphics.Bitmap)

    -- Dapatkan info bitmap
    local info = ffi.new("AndroidBitmapInfo")
    local result = ffi.C.AndroidBitmap_getInfo(env, jbitmap, info)
    end

    self.width = info.width
    self.height = info.height
    self.stride = info.stride
    self.format = info.format

    -- Kunci bitmap pixels
    local addr = ffi.new("void*[1]")
    result = ffi.C.AndroidBitmap_lockPixels(env, jbitmap, addr)

    self.pixels = ffi.cast("uint8_t*", addr[0])

    return self
end

-- Destruktor
function android.graphics.Bitmap:delete(env, jbitmap)
    -- Buka kunci bitmap pixels
    local result = ffi.C.AndroidBitmap_unlockPixels(env, jbitmap)
end

-- Dapatkan info bitmap
function android.graphics.Bitmap:getInfo(env, jbitmap)
    local info = ffi.new("AndroidBitmapInfo")
    local result = ffi.C.AndroidBitmap_getInfo(env, jbitmap, info)

    return info.width, info.height
end

-- Kunci bitmap pixels
function android.graphics.Bitmap:lockPixels(env, jbitmap)
    local addr = ffi.new("void*[1]")
    local result = ffi.C.AndroidBitmap_lockPixels(env, jbitmap, addr)

    return addr[0]
end

-- Buka kunci bitmap pixels
function android.graphics.Bitmap:unlockPixels(env, jbitmap)
    local result = ffi.C.AndroidBitmap_unlockPixels(env, jbitmap)
end

-- Fungsi pengolahan gambar

-- Fungsi pembantu untuk menyusupkan nilai antara nilai minimal dan nilai maximal
local function clamp(value, minVal, maxVal)
return math.max(minVal, math.min(maxVal, value))
end

--Fungsi pembantu untuk mengkonversi RGB warna ke HSV
local function rgbToHsv(r, g, b)
r = r / 255.0
g = g / 255.0
b = b / 255.0

local cmax = math.max(r, math.max(g, b))
local cmin = math.min(r, math.min(g, b))
local diff = cmax - cmin

local h = 0
if diff == 0 then
    h = 0
elseif cmax == r then
    h = 60 * ((g - b) / diff)
elseif cmax == g then
    h = 60 * (((b - r) / diff) + 2)
else
    h = 60 * (((r - g) / diff) + 4)
end

if h < 0 then
    h = h + 360
end

local s = 0
if cmax ~= 0 then
    s = diff / cmax
end

local v = cmax

return h, s, v
end

m
-- Fungsi pembantu untuk mengkonversi warna RGB ke HSV

local function rgbToHsv(r, g, b)
local h, s, v
local minVal = math.min(r, g, b)
local maxVal = math.max(r, g, b)
local delta = maxVal - minVal

v = maxVal

if delta ~= 0 then
    s = delta / maxVal

    if r == maxVal then
        h = (g - b) / delta
    elseif g == maxVal then
        h = 2 + (b - r) / delta
    else
        h = 4 + (r - g) / delta
    end

    h = h * 60

    if h < 0 then
        h = h + 360
    end
else
    s = 0
    h = 0
end

return h / 360, s, v
end

-- Fungsi pembantu untuk konversi HSV ke RGB

local function hsvToRgb(h, s, v)
local r, g, b
local i = math.floor(h * 6)
local f = h * 6 - i
local p = v * (1 - s)
local q = v * (1 - f * s)
local t = v * (1 - (1 - f) * s)

if i % 6 == 0 then
    r, g, b = v, t, p
elseif i % 6 == 1 then
    r, g, b = q, v, p
elseif i % 6 == 2 then
    r, g, b = p, v, t
elseif i % 6 == 3 then
    r, g, b = p, q, v
elseif i % 6 == 4 then
    r, g, b = t, p, v
else
    r, g, b = v, p, q
end

return r, g, b
end

-- Aplikasikan filter warna ke dalam bitmap
local function applyColorFilter(bitmap, cf)
local info = ffi.new("AndroidBitmapInfo[1]")
local result = android.bitmap_getInfo(bitmap, info)

if result ~= 0 then
    return nil
end

local pixels = ffi.new("uint8_t * [1]")

result = android.bitmap_lockPixels(bitmap, pixels)

end

local w, h, s = info[0].width, info[0].height, info[0].stride

for i = 0, h - 1 do
    for j = 0, w - 1 do
        local idx = i * s + j * 4
        local r, g, b = pixels[0][idx], pixels[0][idx + 1], pixels[0][idx + 2]
        local a = pixels[0][idx + 3] / 255

        -- Aplikasikan filter warna
        local r1 = cf.r * r + cf.g * g + cf.b * b + cf.a * a + cf.brightness
        local g1 = cf.r * r + cf.g * g + cf.b * b + cf.a * a + cf.brightness
        local b1 = cf.r * r + cf.g * g + cf.b * b + cf.a * a + cf.brightness

        -- Susupkan nilai warna dalam jarak [0, 255]
        r1 = clamp(r1, 0, 255)
        g1 = clamp(g1, 0, 255)
        b1 = clamp(b1, 0, 255)

        -- Aplikasikan kontras
        r1 = (r1 / 255.0 - 0.5) * cf.contrast + 0.5 * 255.0
        g1 = (g1 / 255.0 - 0.5) * cf.contrast + 0.5 * 255.0
        b1 = (b1 / 255.0 - 0.5) * cf.contrast + 0.5 * 255.0

        -- Susupkan nilai warna dalam jarak [0, 255] lagi
        r1 = clamp(r1, 0, 255)
        g1 = clamp(g1, 0, 255)
        b1 = clamp(b1, 0, 255)

        -- Konversikan RGB ke HSV
        local h, s, v = rgbToHsv(r1, g1, b1)

        -- Aplikasikan Saturasi
        s = s * cf.saturation

        -- Aplikasikan warna Hue
        h = h + cf.hue
        if h > 1.0 then h = h - 1.0 end
        if h < 0.0 then h = h + 1.0 end

        -- Konversikan kembali HSV ke RGB
        r1, g1, b1 = hsvToRgb(h, s, v)

        -- Setting manipulasi nilai warna baru
        pixels[i] = toColor(r1, g1, b1, a)
    end

    -- Buka kunci pixels dan kembali untuk modifikasi Bitmap
    obj:unlockPixels()
    return bmp
end




