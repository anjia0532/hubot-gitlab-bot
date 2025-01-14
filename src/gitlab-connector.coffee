# Description
#   与 gitlab 交互的 hubot 脚本
#
# Configuration:
#   HUBOT_GITLAB_URL
#   HUBOT_GITLAB_TOKEN
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   AnJia <anjia0532@gmail.com>

GitlabClient = require("./gitlab-client")
createPipeline = require("./parser-pipeline")
getVersion = require("./parser-version")
getProjects = require("./parser-project")
getBranches = require("./parser-branch")
mergeRequests = require("./parser-merge-requests")
help = require("./parser-help")

module.exports = (robot) ->
  robot.respond /gitlab (.*)/, (res) ->
    url = process.env.HUBOT_GITLAB_URL
    token = process.env.HUBOT_GITLAB_TOKEN
    command = res.match[1].split " "

    gitlabClient = new GitlabClient(robot, url, token)
    switch command[0]
      when "pipeline" then createPipeline(gitlabClient, res, command)
      when "projects" then getProjects(gitlabClient, res, command)
      when "branches" then getBranches(gitlabClient, res, command)
      when "merge" then mergeRequests(gitlabClient, res, command)
      when "version" then getVersion(gitlabClient, res)
      when "help" then help.sendHelp(res)
      else
        help.sendUnknownCommand(res, res.match[1])


