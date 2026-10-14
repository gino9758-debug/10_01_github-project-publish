# 安全隐患检查清单

发布到 GitHub（尤其 Public 仓库）前，必须逐项检查。**本阶段只报告，不执行任何 Git 写入操作。**

## 1. 文件清单核对

```bash
# 列出全部文件（含隐藏），排除 .git 内部
find <项目路径> -not -path './.git/*' -not -name '.git' | sort

# 列出 Git 跟踪的文件（将随仓库公开）
git ls-files
```

## 2. 六类敏感项扫描

在项目路径下（排除 .git 目录）搜索：

| 检查项 | 搜索模式 | 说明 |
|--------|----------|------|
| 密码/Token | `gh[pousr]_`、`github_pat`、`api[_-]?key`、`secret`、`password`、`passwd`、`authorization`、`bearer` | 真实凭据格式 |
| 本地绝对路径 | `/home/`、`/Users/`、`/tmp/`、`/var/`、`/etc/`、`/root/`、`/opt/` | 泄露本机结构 |
| 手机号 | `1[3-9][0-9]{9}` | 中国大陆手机号 |
| 身份证号 | `[0-9]{17}[0-9Xx]` | 18位身份证 |
| 邮箱 | `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}` | 个人邮箱 |
| 临时文件 | `.tmp-` 前缀目录、`bash-live-*.txt` 等工具输出 | 不入库但需报告 |

```bash
# 参考命令（grep，排除 .git）
grep -rniE "gh[pousr]_|github_pat|api[_-]?key|secret|password|passwd|authorization|bearer" <项目路径> --exclude-dir=.git
grep -rniE "/home/|/Users/|/tmp/|/var/|/etc/|/root/" <项目路径> --exclude-dir=.git
grep -rniE "1[3-9][0-9]{9}|[0-9]{17}[0-9Xx]|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" <项目路径> --exclude-dir=.git
```

> 注意：`token` 出现在命令帮助文本（如 `--with-token`）中不算泄露，需人工甄别上下文。

## 3. 提交历史中的隐私

Public 仓库中，提交记录的作者姓名与邮箱对所有人可见：

```bash
git log --format='%h %an <%ae>'
```

- 若作者使用真实姓名 + 个人邮箱且用户介意公开：改用 GitHub noreply 邮箱（`<ID>+<用户名>@users.noreply.github.com`）作为提交身份。
- 若需抹掉历史中的旧身份：改写历史（`git filter-branch` 或 `git filter-repo`）+ `git push --force`。**属不可逆操作，必须先向用户说明再执行。**

## 4. 本地 Git 配置

```bash
cat .git/config
```

检查 `[user]` 与 `[remote]` 段。凭据应存放在系统凭据管理器或 gh 的 `~/.config/gh/hosts.yml`，**不应出现在项目文件或 .git/config 中**（URL 中不得内嵌用户名密码）。

## 5. 不应公开的内容

- 业务内部信息、客户数据、未公开文档
- 个人真实姓名/手机号/家庭地址
- 任何用户未明确同意公开的内容

## 6. 报告格式

检查完毕输出表格：

| 检查项 | 结果（✅/⚠️/❌） | 说明 |
|--------|------|------|
| 密码/Token | | |
| 个人隐私 | | |
| 本地绝对路径 | | |
| 临时文件 | | |
| 测试垃圾文件 | | |
| 不应公开的内容 | | |

⚠️ 或 ❌ 项必须列明**文件位置 + 具体内容概述**，给出处理选项，由用户决策后再继续后续步骤。
