utils = require("./utils")

getBranches = (gitlabClient, res, command) ->
  if (gitlabClient? && res? && command?)
    if (command.length != 2)
      res.reply "正确用法为: **gitlab branches projectId**"
      return
    projectId = command[1]
    gitlabClient.getBranches(projectId) (err, response, body) ->
      utils.parseResult(res, err, response, returnBranches, body)

returnBranches = (res, body)->
  data = JSON.parse body
  branch_infos = utils.buildListInfo(data, formatBranch)
  res.reply "## 找到 #{data.length} 个分支" + '  \n  ' + branch_infos.join('  \n  ')


formatBranch = (branch) ->
  "  \n  **#{branch.name}**  \n  最后提交: #{branch.commit.short_id}, 标题: #{branch.commit.title} 创建者: #{branch.commit.author_name} 创建时间: #{branch.commit.created_at}"


module.exports = getBranches
