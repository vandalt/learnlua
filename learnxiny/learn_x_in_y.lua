-- File written while reading this tutorial: https://learnxinyminutes.com/docs/lua/

-- This is a one line comment

--[[
  This is a multi-line comment
--]]

----------------------------------------------------
-- 1. Variables and flow control
----------------------------------------------------

num = 42  -- Numbers are doubles.

s = 'walternate'  -- Immutable strings (like Python)
t = "double-quotes work too"
u = [[ Double brackets
       delimitate multi-line
       strings. ]]
t = nil  -- Undefines t; Lua has garbage colletion

-- Blocks denoted with keywords like do/end:
while num < 50 do
  num = num + 1  -- No ++ or += operators :(
end

-- Example if clause
if num > 40 then
  print('over 40')
elseif s ~= 'walternate' then  -- ~= is "not equals"
  -- Equality check is == like Python; ok for strs
  io.write('not over 40\n')  -- Defaults to stdout
else
  -- Variables are global by default.
  thisIsGlobal = 5  -- Camel case is common.

  -- Example local variable
  local line = io.read()  -- Reads next stdin line

  -- String concat uses .. operator:
  print('Winter is coming, ' .. line)
end

-- Undefined variables return nil
foo = anUnknownVariable

aBoolValue = false

-- Only nil and false are 'false' in if clauses
if not aBoolValue then print("is false") end

-- 'or' and 'and' are short-circuited
ans = aBoolValue and 'yes' or 'no'  --> 'no'
ansy = 0 and 'yes' or 'no'  --> 'yes'

aSum = 0
for i = 1, 100 do  -- Range includes both ends
  aSum = aSum + i
end

-- Use "100, 1, -1" as range to go down
-- General: begin, end[, step]
otherSum = 0
for j = 100, 1, -1 do otherSum = otherSum + j end

-- Another loop:
repeat
  print('other loop')
  num = num - 1
until num == 0

----------------------------------------------------
-- 2. Functions
----------------------------------------------------

function fib(n)
  if n < 2 then return 1 end
  return fib(n - 2) + fib(n - 1)
end

-- Closures and anonymous funtions are ok
function adder(x)
  -- This returns a function that adds x to the argument
  return function (y) return x + y end
end
a1 = adder(9)
a2 = adder(36)
print(a1(16))  --> 25
print(a2(64))  --> 100

-- Returns, func calls and assignments all work with lists
-- When sizes are mismatched:
-- Receivers are neil
-- Senders are discarded

x, y, z = 1, 2, 3, 4  -- 4 is thrown away

function bar(a, b, c)
  print(a, b, c)
  return 4, 8, 15, 16, 23, 42
end

x, y = bar('zaphod')  --> prints "zaphod nil nil";
-- x = 4, y = 8 and others are discarded

-- These two lines are the same
function f(x) return x * x end
f = function (x) return x * x end

-- Functions can also be local
local function g(x) return math.sin(x) end  -- trig in radians (of course)
g(1)
local g; g = function (x) return math.sin(x) end

-- Calls with one string don't need parentheses
print 'hello'  -- (I don't like this)

----------------------------------------------------
-- 3. Tables
----------------------------------------------------

-- Tables are Lua's only compound data structures;
-- they are associative arrays

-- Using as dict/map:

-- Dict literals have string keys by default
t = {key1 = 'val1', key2 = false}

-- String keys can use dot notation:
print(t.key1)
t.newKey = {}  -- Adds new key/value pair
t.key2 = nil  -- Remove key2 from table

-- Literal notation for any (non-nil) value as key:
u = {['@!#'] = 'qbert', [{}] = 1729, [6.28] = 'tau'}
print(u[6.28])


-- Key matching is basically by value for numbers and strings,
-- but identity for tables
a = u['@!#']  -- a = 'qbert'
b = u[{}]  -- b is nil because not same object
-- --> strs and numbers more portable keys

-- A one-table-param call does not need parentheses
function h(x) print(x.key1) end
h{key1 = 'something'}

for key, val in pairs(u) do  -- Table iteration
  print(key, val)
end

-- _G is special table of all globals
print(_G['_G'] == _G)

-- Using tables as lists/arrays:

-- List literals implicitely set up int keys:
v = {'value1', 'value2', 1.21, 'gigawatts'}
for i = 1, #v do  -- #v is size of v for lists
  print(v[i])  -- Indices start at 1...
end
-- NOTE: List is not a real type, just table with sorted int keys

----------------------------------------------------
-- 3.1 Metatables and metamethods
----------------------------------------------------

-- Can have metatable to overload some operators

-- Theses two are fractions a/b
f1 = {a = 1, b = 2}
f2 = {a = 2, b = 3}

metafraction = {}
function metafraction.__add(f1, f2)
  sum = {}
  sum.b = f1.b * f2.b
  sum.a = f1.a * f2.b + f2.a * f1.b
  return sum
end

setmetatable(f1, metafraction)
setmetatable(f2, metafraction)

s = f1 + f2

-- To get metatable, we use getmetatable(f1)
-- Next line would fail because s has no metatable
-- t = s + s

-- An __index on metatable overloads dot lookups
defaultFavs = {animal = 'gru', food = 'donuts'}
myFavs = {food = 'pizza'}
setmetatable(myFavs, {__index = defaultFavs})
eatenBy = myFavs.animal  -- Gets value from default

----------------------------------------------------
-- 3.2 Class-like tables and inheritance
----------------------------------------------------

-- Classes aren't built-in; there are different ways to make them
-- using tables and  metatables

Dog = {}

function Dog:new()  -- Adds function to table with 1st arg self
  newObj = {sound = 'woof'}  -- Instance of classe dog
  self.__index = self
  return setmetatable(newObj, self)  -- Returns instance with attributes
end

function Dog:makeSound()  -- This time we expect self to be instance
  print('I say ' .. self.sound)
end

mrDog = Dog:new()
mrDog:makeSound()  -- I say woof

-- inheritance:
LoudDog = Dog:new()

function LoudDog:makeSound()
  s = self.sound .. ' '
  print(s .. s .. s)
end

seymour = LoudDog:new()
seymour:makeSound()

----------------------------------------------------
-- 4. Modules.
----------------------------------------------------

-- In a separate file (egmodule.lua), we have a module
-- Here we can use its content with require:
local mod = require('egmodule')

--[[
require is the standard way to include modules.
It acts like:
local mod (function ()
  <contents of mod.lua>
end) ()
i.e. like mod.lua is function body so locals inside mod.lua are invisible
outside of it.
--]]

-- Works because mod is M in egmodule.lua
mod.sayHello()
-- But sayMyName would not work bc local to egmodule

-- require's return values are cached so file is run at most once
-- For e.g., here the module with only a print runs once
local a = require('mod2')
local b = require('mod2')

-- dofile is like require but without caching:
dofile('mod2.lua')
dofile('mod2.lua')

-- loadfile loads lua file but doesn't run it yet
f = loadfile('mod2.lua')  -- Call f() to run it

-- load (replaces loadstring) is loadfile for strings
-- g = loadstring('print(343)')  -- Replaced by 'load'
g = load('print(343)')  -- Returns a function
g()
