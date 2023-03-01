utils = {}

utils.buildListInfo = (data, callback) ->
  list = []
  list.push callback(branch) for branch in data
  return list


utils.parseResult = (res, err, response, successMethod, body, args...)->
  if err
    res.reply "遇到错误 :( #{err}"
    return
  if response.statusCode.toString().substr(0, 1)!="2"
    res.reply "发起 http 请求失败 HTTP状态码 #{response.statusCode} Body [#{body}]"
    return
  successMethod(res, body, args...)

module.exports = utils
