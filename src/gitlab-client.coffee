class GitlabClient
  constructor: (@robot, @url, @token) ->

  http: (uri) ->
    @robot.http(@url + uri).header('Accept', 'application/json').header('PRIVATE-TOKEN', @token)

  getVersion: () ->
    this.http('/api/v4/version').get()

  getTriggers: (projectId) ->
    this.http('/api/v4/projects/' + projectId + '/triggers').get()

  getProject: (projectId) ->
    this.http('/api/v4/projects/' + projectId).get()

  getProjectsByName: (searchName) ->
    this.http('/api/v4/projects?search=' + searchName).get()

  getProjects: () ->
    this.http('/api/v4/projects').get()

  getBranches: (projectId) ->
    this.http('/api/v4/projects/' + projectId + '/repository/branches').get()

  getMergeRequests: (projectId, filter) ->
    filterPath = ""
    if (filter != "")
      filterPath = "?" + filter
    this.http('/api/v4/projects/' + projectId + '/merge_requests' + filterPath).get()

  acceptMergeRequest: (projectId, merge_iid) ->
    this.http('/api/v4/projects/' + projectId + '/merge_requests/' + merge_iid + '/merge').put()

  triggerPipeline: (projectId, params) ->
    this.http('/api/v4/projects/' + projectId + '/trigger/pipeline').header('Content-type', 'application/json')
      .post(params)

  createTrigger: (projectId) ->
    this.http('/api/v4/projects/' + projectId + '/triggers/').header('Content-type', 'application/json')
      .put({"description": "hubot trigger"})

module.exports = GitlabClient
