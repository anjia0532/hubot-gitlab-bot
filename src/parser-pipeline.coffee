utils = require("./utils")

createPipeline = (gitlabClient, res, command) ->
  if (gitlabClient? && res? && command?)
    if (command.length != 4 || command[1] != 'trigger')
      res.reply "Correct usage is gitlab pipeline trigger \<projectId\> \<branch\>"
      return
    projectId = command[2]
    branchName = command[3]
    gitlabClient.getProject(projectId) (err, response, body) ->
      utils.parseResult(res, err, response, findBranches, body, gitlabClient, branchName)


findBranches = (res, body, gitlabClient, branchName, projectId) ->
  project = JSON.parse body
  gitlabClient.getBranches(project.id) (err, response, body) ->
    utils.parseResult(res, err, response, findRightBranch, body, gitlabClient, branchName, project)

findRightBranch = (res, body, gitlabClient, branchName, project) ->
  data = JSON.parse body
  branch_names = []
  branch_names.push branch.name for branch in data

  filter_branch_names = (item for item in branch_names when item.indexOf(branchName) != -1)
  if filter_branch_names.length == 0
    branch_names_info = branch_names.join('\n')
    res.reply "对不起，未找到 #{branchName} 分支. 已有分支为:" + '\n' + "#{branch_names_info}"
  else if filter_branch_names.length > 1
    filter_branch_info = filter_branch_names.join('\n')
    res.reply "对不起，找到 #{filter_branch_names.length} 个包含 #{branchName} 的分支 . 请指定具体用哪个. 已有分支为：" + '\n' + "#{filter_branch_info}"
  else
    branch = filter_branch_names[0]
    gitlabClient.getTriggers(project.id) (err, response, body) ->
      utils.parseResult(res, err, response, readTrigger, body, gitlabClient, branch, project)

readTrigger = (res, body, gitlabClient, branch, project)->
  data = JSON.parse body
  if (data.length == 0)
    res.reply "未找到触发器，正在尝试通过 api 创建，请重试"
    gitlabClient.createTrigger(project.id) (err, response, body) ->
      utils.parseResult(res, err, response, parseTrigger, body, branch, project)
  else
    trigger = data[0].token
    params = JSON.stringify({
      ref: branch,
      token: trigger
    })
    gitlabClient.triggerPipeline(project.id, params) (err, response, body) ->
      utils.parseResult(res, err, response, parseTrigger, body, branch, project)

parseTrigger = (res, body, branch, project) ->
  data = JSON.parse body
  res.reply "已为 项目 #{project.name} 下的分支 #{branch} 创建流水线，id为: #{data.id} .\n 详见 #{project.web_url}/pipelines/#{data.id}"

module.exports = createPipeline
