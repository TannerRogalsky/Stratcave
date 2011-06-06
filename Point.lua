--[[
Copyright (c) 2010-2011 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local sqrt, cos, sin = math.sqrt, math.cos, math.sin

Point = class("Point")

function Point:initialize(x,y)
	self.x = x
	self.y = y
end

function isPoint(v)
	return getmetatable(v) == Point
end

function Point:clone()
	return Point(self.x, self.y)
end

function Point:unpack()
	return self.x, self.y
end

function Point:__tostring()
	return "("..tonumber(self.x)..","..tonumber(self.y)..")"
end

function Point.__unm(a)
	return Point(-a.x, -a.y)
end

function Point.__add(a,b)
	return Point(a.x+b.x, a.y+b.y)
end

function Point.__sub(a,b)
	return Point(a.x-b.x, a.y-b.y)
end

function Point.__mul(a,b)
	if type(a) == "number" then
		return Point(a*b.x, a*b.y)
	elseif type(b) == "number" then
		return Point(b*a.x, b*a.y)
	else
		return a.x*b.x + a.y*b.y
	end
end

function Point.__div(a,b)
	return Point(a.x / b, a.y / b)
end

function Point.__eq(a,b)
	return a.x == b.x and a.y == b.y
end

function Point.__lt(a,b)
	return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function Point.__le(a,b)
	return a.x <= b.x and a.y <= b.y
end

function Point.permul(a,b)
	return Point(a.x*b.x, a.y*b.y)
end

function Point:len2()
	return self * self
end

function Point:len()
	return sqrt(self*self)
end

function Point.dist(a, b)
	return (b-a):len()
end

function Point:normalize_inplace()
	local l = self:len()
	self.x, self.y = self.x / l, self.y / l
	return self
end

function Point:normalized()
	return self / self:len()
end

function Point:rotate_inplace(phi)
	local c, s = cos(phi), sin(phi)
	self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
	return self
end

function Point:rotated(phi)
	return self:clone():rotate_inplace(phi)
end

function Point:perpendicular()
	return Point(-self.y, self.x)
end

function Point:projectOn(v)
	return (self * v) * v / v:len2()
end

function Point:cross(other)
	return self.x * other.y - self.y * other.x
end
