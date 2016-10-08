module.exports = randstr = (len = 6)->
  s = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  re = ''
  for i in [0...len]
    re = re + s[~~(Math.random() * 52)]

  return re