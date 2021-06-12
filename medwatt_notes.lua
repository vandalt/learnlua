-- Written following this file: https://github.com/medwatt/Notes/blob/main/Lua/Lua_Quick_Guide.ipynb

----------------------------------------------------
-- Variable scope
----------------------------------------------------
-- Variables are global unless explicit
-- Scope limited to the chunk: usually each line in interactive mode
-- Can use do/end to make sure block is executed together
var = 10
print("Global var:", var)  --> 10

do
  local var = 20
  print("Local var:", var)  --> 20
end

print("Global var:", var)  --> 10

----------------------------------------------------
-- Variable assignment
----------------------------------------------------
-- Chained assignment is not supported (a = b = 0)
-- But parallel works
a, b, c = 0, 0, 0


----------------------------------------------------
-- Variable types
----------------------------------------------------
-- Operations converted
print(type(5))
print(type(5.5 * '5'))


----------------------------------------------------
-- Logical operators
----------------------------------------------------
-- and returns 1st if false, otherwise second
-- or returns first argument if not false, otherwise second
print(true and 10)  --> 10
print(10 and true)  --> true
print(false and 10)  --> false
print(false or 10)  --> 10
print(nil and 10)  --> nil
print(nil or 10)  --> 10
print(false and nil)  --> false
print(false and not(nil))  --> false


----------------------------------------------------
-- Common string methods
----------------------------------------------------
print(string.upper("The"))  -- All upper
print(string.lower("ALLO"))  -- All lower
print(string.len("A L L O"))  -- len of string
print(string.find("This is", "is"))  --> 3 4: ends of 'find' string
print(string.sub("abcd", 2, 3))  --> bc: get substring given by indices
print(string.gsub("pen", 'e', 'i'))  --> pin: replace e and i
print(string.rep("ab", 2))  --> abab: repeat string n times
print(string.reverse("abcd"))  --> dcba: reverse
print(string.char(98))  --> b: Get char from ascii code
print(string.byte("abc", 2))  --> 98: ascii code of character with index


----------------------------------------------------
-- String formatting
----------------------------------------------------
-- Following same pattern as in C except `* l L n p h`
-- Prototype: %[flags][width][.precision][length]specifier
-- Common specifiers are s, c, d, u f, e
do
  local a, b, c = "string", 1000, 2.718

  print(string.format("String: %s", a))
  print(string.format("Preceding with blanks: %10s", a))
  print(string.format("Singed int: %d", b))
  print(string.format("Preceding with zeros: %010d", b))
  print(string.format("Float: %.2f", c))
  print(string.format("Scientific Notation: %.0e", b))
end



----------------------------------------------------
-- Pattern matching
----------------------------------------------------
-- Lua does not support regex, but it supports pattern matching

-- Matching email address
str = 'email me at moon@lua.com for more info'
pat = '[%w%d%-_]+@[%w%d%-_]+%.[%w%d%-_]+'
print(string.match(str, pat))

-- Match and replace color hex
str = 'color: #@(fg)'

pat = '@%(([^()]+)%)'
repl = 'FF00FF'
newstr = string.gsub(str, pat, repl)

print(newstr) --> color: #FF00FF


----------------------------------------------------
-- Control structures
----------------------------------------------------
-- Most control structures are covered in learn x in y minutes tutorial
-- One extra: Lua does not have continue, but can work around this using goto
for i = 1, 10 do
  if (i % 2 == 0) then goto continue end
  io.write(i, " ")
  ::continue::
end


----------------------------------------------------
-- Functions
----------------------------------------------------
-- Three dots indicate variable number of arguments
function average(...)
  local sum = 0
  local arg = {...}  -- capture args as table

  for _, value in ipairs(arg) do
    sum = sum + value
  end

  return (sum / #arg)
end

print(string.format("The average is %.f.", average(10, 5, 3, 4, 5, 6)))
