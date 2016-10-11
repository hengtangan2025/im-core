# 颜色来源
# https://github.com/d3/d3/wiki/%E5%BA%8F%E6%95%B0%E6%AF%94%E4%BE%8B%E5%B0%BA#category20

arr = [
  '#393b79'
  '#5254a3'
  '#6b6ecf'
  '#9c9ede'
  '#637939'
  '#8ca252'
  '#b5cf6b'
  '#cedb9c'
  '#8c6d31'
  '#bd9e39'
  '#e7ba52'
  '#e7cb94'
  '#843c39'
  '#ad494a'
  '#d6616b'
  '#e7969c'
  '#7b4173'
  '#a55194'
  '#ce6dbd'
  '#de9ed6'
]

module.exports = color20 = (id)->
  m = parseInt(id[22..23], 16) % 20
  return arr[m]