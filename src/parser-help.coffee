help = {}

help.sendHelp = (res) ->
  res.reply '目前支持的命令如下:' + '\n' + HELP

help.sendUnknownCommand = (res, command) ->
  res.reply "对不起，暂时还不支持 '" + command + "'. 目前支持的命令如下:" + '\n' + HELP

HELP_BRANCH = "gitlab branches {projectId} - 指定项目id，显示所有分支"
HELP_PIPELINE = "gitlab pipeline trigger {projectId} {branchName} - 指定项目id和分支名，触发流水线"
HELP_MERGE_REQUEST = "gitlab merge request {projectId} filter - 过滤列出指定项目id的合并请求(过滤条件可选， 例如，仅显示打开的 state=opened)"
HELP_MERGE_REQUEST_ACCEPT = "gitlab merge request {projectId} accept {merge_iid} - 接受指定项目id和合并id的合并请求"
HELP_MERGE_REQUEST_ACCEPT_BRANCH = "gitlab merge request {projectId} accept from A to B - 为指定项目id的项目接受源分支A到目标分支B的合并请求"
HELP_VERSION = "gitlab version - 返回gitlab版本"
HELP_PROJECT = "gitlab projects searchName - 列出所有项目，支持搜索(可选，例如，gitlab projects foo, 列出所有包含foo的项目)"
HELP_DEFAULT = "gitlab help - 列出所有支持的命令"

HELP = [HELP_BRANCH,HELP_PROJECT,HELP_MERGE_REQUEST,HELP_MERGE_REQUEST_ACCEPT,HELP_MERGE_REQUEST_ACCEPT_BRANCH, HELP_PIPELINE,  HELP_VERSION, HELP_DEFAULT].join('\n')

module.exports = help
