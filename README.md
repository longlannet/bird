# bird

面向 OpenClaw 的 X/Twitter 读取、搜索与发帖 skill，底层使用 `bird` CLI。

## 它能做什么

- 读取推文、线程、回复、时间线
- 搜索 X/Twitter 内容并查看账号信息
- 查看 mentions、bookmarks、likes、followers、following
- 在已认证前提下发帖或回复

## 安装

```bash
bash scripts/install.sh
```

## 校验

```bash
bash scripts/check.sh
```

## 常用命令

```bash
source config.env && bird read <tweet-id-or-url> --json
source config.env && bird search "openclaw" --json
source config.env && bird user-tweets <handle>
source config.env && bird mentions
```

## 说明

- `config.env` 是运行时配置，不应提交到仓库。
- 请在 skill 根目录执行命令，确保 `config.env` 能被正确加载。
- 如果 `bird` 缺失或环境损坏，重新运行 `scripts/install.sh`。
