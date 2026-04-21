# bird

面向 OpenClaw 的 X/Twitter 读取、搜索与发帖 skill，底层使用 `bird` CLI。

## 它能做什么

- 读取推文、线程、回复、时间线
- 搜索 X/Twitter 内容并查看账号信息
- 查看 mentions、bookmarks、likes、followers、following
- 在已认证前提下发帖或回复

## 安装

Bird CLI 的核心安装以上游为准：
- 官方入口：`https://bird.fast/`
- 本 skill 当前通过 npm 包 `@steipete/bird` 做本地封装安装

推荐入口：

```bash
bash scripts/install.sh
```

### `bash scripts/install.sh` 会做什么？

会：
- 检查本机是否已经有可用的 `bird`
- 如果没有，则通过 npm 安装 `@steipete/bird`
- 优先安装到共享前缀：`/root/.openclaw/workspace/.npm-global`
- 读取现有 `config.env`
- 运行一次 `bird check` 做 smoke test

不会：
- 不会安装 Node.js / npm 本身
- 不会自动创建 `config.env`
- 不会帮你重新获取 `AUTH_TOKEN` / `CT0`

所以它属于：**bird 本体的本地包装安装 + 环境校验**，不是完整的一键账号初始化脚本。

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

## 迁移到另一台机器

如果你要把这套 skill 迁移到另一台**你自己控制**的机器：

1. 先拉代码

```bash
git clone https://github.com/longlannet/bird.git
cd bird
```

2. 安装 `bird` 运行环境
   - 优先参考上游：`https://bird.fast/`
   - 或直接运行本仓库包装脚本：

```bash
bash scripts/install.sh
```

3. 从旧机器迁移认证配置
   - 复制：`config.env`

4. 在新机器上验证

```bash
bash scripts/check.sh
source config.env && bird whoami
```

如果认证失效，需要重新获取：
- `AUTH_TOKEN`
- `CT0`

## 说明

- `config.env` 是运行时配置，包含敏感认证信息，不应提交到仓库。
- 迁移时真正要带走的是认证配置；`bird` 本体可在新机器重新安装。
- 请在 skill 根目录执行命令，确保 `config.env` 能被正确加载。
- 如果 `bird` 缺失或环境损坏，重新运行 `scripts/install.sh`。
- 如果上游安装方式变化，以 `https://bird.fast/` 为准。
