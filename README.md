# hubot-gitlab-bot

[![npm (scoped)](https://img.shields.io/npm/v/hubot-gitlab-connector.svg)](https://www.npmjs.com/package/hubot-gitlab-bot)

与 gitlab 交互的 hubot 脚本

文档详见 [`src/gitlab-connector.coffee`](src/gitlab-connector.coffee)

## 特性
- 列出所有项目
- 通过名称查询项目
- 列出指定项目下的所有分支
- 触发指定项目的流水线及指定步骤
- 显示或者合并请求
- 显示 gitlab 版本号

## 安装

在 hubot 项目种安装，执行以下命令:

`yarn install hubot-gitlab-bot --save`

成功后添加 **hubot-gitlab-bot** 到 `external-scripts.json` 文件中:

```json
[
  "hubot-gitlab-bot"
]
```

配置两个环境变量
```
HUBOT_GITLAB_URL: gitlab 服务器 url
HUBOT_GITLAB_TOKEN: gitlab 个人访问令牌
```
如何获取个人访问令牌详见 <https://docs.gitlab.com/ce/user/profile/personal_access_tokens.html>

## 样例

```
user1>> hubot gitlab version
hubot>> @user1 gitlab version is 8.13.0-pre, revision 4e963fe
```

查看锁支持特性，执行以下命令:

```
hubot gitlab help
```

## 贡献

目前脚本还不完善，欢迎大家提 issue 和 pr

:)

## NPM 模块

https://www.npmjs.com/package/hubot-gitlab-bot


## 鸣谢

感谢 https://github.com/oltruong/hubot-gitlab-connector
