module.exports = ClassName = (object)->
  arr = []
  for key, value of object
    arr.push key if value
  arr.join(' ')