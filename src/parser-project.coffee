utils = require("./utils")

getProjects = (gitlabClient, res, command) ->
  if (gitlabClient? && res? && command?)
    if (command.length == 1)
      gitlabClient.getProjects() (err, response, body) ->
        readProjects(res, err, response, body)
    else if (command.length == 2)
      searchName = command[1]
      gitlabClient.getProjectsByName(searchName) (err, response, body) ->
        readProjects(res, err, response, body)
    else
      res.reply "正确用法为: **gitlab projects** 或者 **gitlab projects searchName**"
      return

readProjects = (res, err, response, body)->
  utils.parseResult(res, err, response, returnProject, body)


returnProject = (res, body)->
  data = JSON.parse body
  project_info = utils.buildListInfo(data, formatProject)
  res.reply "## 找到 #{data.length} 个项目  \n  "+ project_info.join('  \n\n\n  ')

formatProject = (project) ->
  "**id**: #{project.id}  \n  **项目**: [#{project.namespace.name}/#{project.name}](#{project.web_url}) #{project.description}  \n  **最后更新时间**: #{project.last_activity_at}"


module.exports = getProjects
