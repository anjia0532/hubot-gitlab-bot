utils = require("./utils")

getMergeRequests = (gitlabClient, res, command) ->
  if (gitlabClient? && res? && command?)
    if (command.length == 3)
      projectId = command[2]
      gitlabClient.getMergeRequests(projectId, "") (err, response, body) ->
        utils.parseResult(res, err, response, returnMergeRequests, body)
    else if (command.length == 4)
      projectId = command[2]
      gitlabClient.getMergeRequests(projectId, command[3]) (err, response, body) ->
        utils.parseResult(res, err, response, returnMergeRequests, body)
    else if (command.length == 5 && command[3] == "accept")
      projectId = command[2]
      gitlabClient.acceptMergeRequest(projectId, command[4]) (err, response, body) ->
        utils.parseResult(res, err, response, confirmMergeRequest, body)
    else if (command.length == 8 && command[3] == "accept" && command[4] == "from" && command[6] == "to")
      projectId = command[2]
      source_branch = command[5]
      target_branch = command[7]
      gitlabClient.getMergeRequests(projectId, "state=opened") (err, response, body) ->
        utils.parseResult(res, err, response, acceptOneMergeRequest, body, gitlabClient, projectId, source_branch, target_branch)
    else
      res.reply "正确用法如下，列出合并请求: gitlab merge requests \<projectId\> \<filter>\ (可选, e.g. state=opened) 或者指定项目id和合并id进行合并: gitlab merge requests \<projectId\> accept \<merge iid\> 或者指定项目id，合并原分支A到目标B分支: gitlab merge requests <projectId> accept accept from \<sourceBranch\> to \<targetBranch\>"
    return

returnMergeRequests = (res, body)->
  data = JSON.parse body
  merge_infos = utils.buildListInfo(data, formatMerge)
  res.reply "找到 #{data.length} 个合并请求" + '\n' + merge_infos.join('\n\n')

acceptOneMergeRequest = (res, body, gitlabClient, projectId, source_branch, target_branch)->
  data = JSON.parse body
  filter_merge_requests_iid = (item.iid for item in data when mergeRequestIsValid(item, source_branch, target_branch))
  if filter_merge_requests_iid.length == 0
    res.reply "对不起, 未找到从 #{source_branch} 到 #{target_branch} 的开启状态的合并请求"
  else if filter_merge_requests_iid.length > 1
    filter_merge_requests_names = (formatMerge(item) for item in data when mergeRequestIsValid(item, source_branch, target_branch))
    res.reply "对不起, 发现 #{filter_merge_requests_iid.length} 个 从 #{source_branch} 到 #{target_branch} 的开启状态的合并请求. 请指定要合并哪个, 下面是开启状态的合并请求" + '\n' + "#{filter_merge_requests_names}"
  else
    merge_request_iid = filter_merge_requests_iid[0]
    gitlabClient.acceptMergeRequest(projectId, merge_request_iid) (err, response, body) ->
      utils.parseResult(res, err, response, confirmMergeRequest, body)

formatMerge = (mergeRequest) ->
  "- id: #{mergeRequest.iid}, #{mergeRequest.title}, 从 #{mergeRequest.source_branch} 到 #{mergeRequest.target_branch}" + '\n' + "  状态: #{mergeRequest.state.toUpperCase()}, 更新时间 \"#{mergeRequest.updated_at}\", 提交人: #{mergeRequest.author.name}" + '\n' + "  同意票数: #{mergeRequest.upvotes}, 拒绝票数: #{mergeRequest.downvotes}" + '\n' + "  #{mergeRequest.web_url}"

confirmMergeRequest = (res, body)->
  data = JSON.parse body
  res.reply " #{data.iid} 已合并，状态为 #{data.state}.\n详见 #{data.web_url}"

mergeRequestIsValid = (item, source_branch, target_branch) ->
  item.source_branch.indexOf(source_branch) != -1 && item.target_branch.indexOf(target_branch) != -1

module.exports = getMergeRequests
