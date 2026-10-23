---
name: github-project-publish
label: GitHub项目发布与版本迭代
description: GitHub 项目发布与版本迭代管理全流程技能。把本地项目（尤其含自定义 Skill、文档、代码的仓库）从零发布到 GitHub、更新已发布仓库，并通过 Tag + Release 管理版本迭代。触发场景：(1) 用户要求"把项目发布/上传到 GitHub"、"初始化 Git 仓库"、"提交推送"、"更新仓库"；(2) 用户要求"完善 README"、"添加 LICENSE"、"检查项目安全隐患"后执行发布；(3) 用户要求创建远程仓库（Public/Private）并推送 main 分支；(4) 用户要求"发版本/版本迭代/发布 Release/打 Tag"、"GitHub 上显示版本迭代"；(5) 用户反馈"GitHub 上看不到更新/仓库"时，先诊断远程状态再处理。技能固定覆盖：CLI 环境检查（git/gh 安装、版本、gh 登录状态）→ 项目文档准备（README/LICENSE）→ 安全隐患检查 → 仓库记录与分支判断（新建/已有）→ 提交上传 → 版本迭代（语义化版本 Tag + Release 与版本说明）→ 全路径反馈（含私有仓库查看方式）。提供双认证模式：gh CLI 浏览器授权（OAuth/gho_）与 Classic PAT（ghp_）环境变量认证，适配无 gh 登录态的 agent（如 Aily）通过 repo 权限 PAT 完成发布与迭代。执行中涉及安装软件、浏览器授权、创建公开仓库、改写历史/强制推送、打 Tag/创建 Release 等动作时，必须先向用户说明并等待确认；不得向用户索要密码或 Token。
---

# GitHub 项目发布与版本迭代

把本地项目完整发布到 GitHub，并在迭代更新时通过 Tag + Release 展示版本历史。以"检查→准备→检查安全→记录→提交→发版→反馈"为固定顺序，任何一步发现问题都要停下向用户报告，而不是跳过。

## 执行总览

| 阶段 | 动作 | 产出 |
|------|------|------|
| A 环境检查 | 检查 git/gh 安装与版本、gh 登录 | 环境结论 |
| B 项目准备 | 完善 README.md、添加 LICENSE | 文档文件 |
| C 安全检查 | 扫描敏感信息，报告结果 | 检查报告 |
| D 仓库记录 | 记录/创建远程仓库信息 | 仓库清单 |
| E 提交上传 | git add/commit/push | 提交与远程 |
| F 版本迭代 | 语义化版本 Tag + Release + 版本说明 | 版本记录 |
| G 路径反馈 | 汇总全部路径与状态 | 交付报告 |

## 认证模式（Authentication）

本技能支持两种认证模式，任务开始时先按"认证自检流程"自动选用，**不要默认要求用户提供 token**。

### 模式一：gh CLI 已登录（默认，浏览器授权）

环境已执行过 `gh auth login`（OAuth / `gho_` 令牌，存于 `~/.config/gh/hosts.yml`），直接使用，无需任何额外输入。用 `gh auth status` 判断。

### 模式二：Classic PAT（`ghp_`，供无 gh 登录态的 agent 使用）

适用于 Aily 等没有浏览器授权能力的 agent：用户提供一个 **Classic PAT（`ghp_` 开头）**，agent 用其完成全部发布/迭代操作（创建仓库、推送、改可见性、打 Tag、建 Release）。

**Token 要求**：作用域勾选 `repo`（整组，自动含 `public_repo`），即覆盖全部所需能力。

**用户授权入口**：https://github.com/settings/tokens/new → Note 随意填 → 勾选 `repo` → 有效期按需 → Generate token → 复制（仅显示一次）。

**agent 使用方式（三选一）**：

1. **环境变量（推荐，兼容所有 gh 版本）**：
   ```bash
   export GH_TOKEN="ghp_xxx"     # gh 自动识别；GITHUB_TOKEN 亦可
   gh auth status                 # 应显示 Logged in as <user>
   ```
2. **管道登入**（gh 较新版本支持 `--with-token`；旧版失败则改用方式 1）：
   ```bash
   echo "ghp_xxx" | gh auth login --with-token
   ```
3. **REST API 直调**（无 gh 环境/脚本场景，curl 或 urllib 均可）：
   ```bash
   curl -H "Authorization: Bearer ghp_xxx" https://api.github.com/user
   ```

**认证自检流程**（每轮任务开始时执行）：

1. `gh auth status` 成功 → 模式一，继续。
2. 失败 → 检查环境变量 `GH_TOKEN` / `GITHUB_TOKEN` 是否存在 → 存在 → 模式二（方式 1）。
3. 都没有 → 按模式二向用户说明：请用户到 https://github.com/settings/tokens/new 生成 `repo` 权限的 Classic PAT，**粘贴到 agent 自己的配置/环境变量中**（不要发到对话、截图或仓库），agent 读取后继续。

**安全红线（模式二同样适用）**：

- Token 只能由用户在 GitHub 官网自行生成；agent 不得索要明文 token 到对话/日志，不写入仓库或提交历史。
- 涉及创建公开仓库、强制推送、打 Tag/创建 Release 等动作，仍须先向用户说明并确认。
- 任务结束或用户要求时，提醒用户在 GitHub → Settings → Developer settings → Tokens (classic) → Delete 吊销。

## 阶段 A：环境检查

按序执行，任何一项不通过先修复再进入下一阶段。

1. **git**：`git --version`。未安装则识别操作系统（Linux 用系统包管理器 apt/yum/dnf，macOS 用 brew，Windows 用 winget/choco 或官网安装包）。**安装涉及管理员权限/系统修改时，先向用户说明并等待确认。**
2. **gh (GitHub CLI)**：`gh --version`。未安装同样先说明再装。
3. **gh 登录**：`gh auth status` 确认认证状态；未登录或环境无 gh 登录态时，按「认证模式」一节处理：
   - 环境支持浏览器授权 → `gh auth login --hostname github.com --web`（设备授权流程）。注意：gh 旧版本（如 2.4.x）不支持 `--git-protocol` 标志，用管道喂交互输入：`printf 'HTTPS\nY\n' | gh auth login --hostname github.com --web`；浏览器打不开时，把一次性验证码和 `https://github.com/login/device` 发给用户，请用户手动授权；登录后运行 `gh auth setup-git` 配置凭据助手（若 push 报 "could not read Username"，重新执行此命令）
   - 环境无浏览器授权能力（如 Aily 等第三方 agent）→ 走**模式二**：用户提供 Classic PAT（`ghp_`），放入环境变量 `GH_TOKEN` 后继续（详见「认证模式」一节）
   - **密码/验证码/二次验证一律由用户本人在浏览器完成；token 由用户在官网生成后放入 agent 配置/环境变量，绝不要求用户把凭据发到对话中**

## 阶段 B：项目文档准备

1. **先完整读取项目全部文件**（SKILL.md、references、已有 README 等），确保后续产出与项目真实功能一致，不编造。
2. **README.md**：若缺失或需完善，按 `references/readme-template.md` 的结构编写（项目解决什么问题/主要功能/安装方法/使用方法/输入输出示例），内容必须来自项目真实内容。
3. **LICENSE**：若缺失，默认提供 MIT（模板见 `references/license-template.md`）。版权人（姓名或 GitHub 账号）向用户确认后再写入，不擅自决定。

## 阶段 C：安全隐患检查

**只报告，不执行 Git 写入操作**。运行 `scripts/scan_secrets.sh <项目绝对路径>` 或按 `references/security-check.md` 的清单手动检查：

- 密码 / Token / API Key / Secret
- 个人隐私（手机号、邮箱、身份证、真实姓名）
- 本地绝对路径（/home/、/Users/、/tmp/ 等）
- 临时文件（.tmp- 目录、工具运行输出）
- 测试/调试垃圾文件
- 不应公开的内容（含**提交历史中的作者姓名与邮箱**——Public 仓库会公开展示）

发现敏感内容：列出问题清单和文件位置，给出处理选项（保留/更换提交身份/改写历史），**由用户决策后再继续**。提交历史作者邮箱若用户介意公开，可改用 GitHub noreply 邮箱或改写历史（改写+强制推送属不可逆操作，必须先行说明）。

## 阶段 D：仓库记录与分支判断

1. 检查 `git remote -v` 与 `git branch --show-current`，记录：远程名（默认 origin）、远程 URL、本地分支（默认 main）、当前提交哈希。
2. **分支判断**：
   - **已有远程（origin 已存在）** → 这是"更新已有仓库"场景，跳过创建，直接进入阶段 E 提交推送。先向用户说明当前远程与本地状态，确认要推送的改动内容。
   - **无远程** → 创建新仓库：`gh repo create <仓库名> --public|--private --source=. --remote=origin --push`
     - **创建前必须向用户确认**：仓库名称、可见性（Public/Private）、远程名、推送分支，以及"即将执行的操作"。
     - 仓库名默认取项目目录名或用户指定。
3. 记录清单（交付时反馈）：仓库名、GitHub URL、远程名、分支、本地路径。
4. **用户反馈"看不到仓库/更新"时**，先诊断而非直接重建：`gh repo view <owner>/<repo> --json name,isPrivate,url,pushedAt` 确认仓库存在与最近推送时间；用 `gh api "repos/<owner>/<repo>/contents/" --jq '.[].name'` 列出远程文件。若仓库存在且推送时间符合预期，向用户解释可见性规则（见阶段 F），不要重复创建。

## 阶段 E：提交上传

1. `git add -A` → 检查 `git status` 确认暂存内容与预期一致（尤其确认临时目录已被 .gitignore 排除）。
2. `git commit -m "<描述性信息>"`。
3. `git push -u origin <分支>`；若远程已有历史需 `git push --force` 时，**必须先说明原因并等待确认**。
4. 验证：`git log --oneline`、`git status`、`gh repo view <owner>/<repo> --json name,isPrivate,url,defaultBranchRef,pushedAt`（gh 旧版不支持 visibility 字段，用 isPrivate），并用 `gh api "repos/<owner>/<repo>/contents/" --jq '.[].name'` 确认远程文件已更新。

## 阶段 F：版本迭代（Tag + Release）

**作用**：让 GitHub 仓库展示版本迭代历史（Releases 页面），用户可追踪每个版本的变化。

1. **判断是否发版**：用户明确要求"发版本/版本迭代/打 Tag/Release"，或本次为实质功能变更（新增/重构/修复）时执行；纯文档微调可不发版，只做阶段 E 提交推送。
2. **确定版本号**（语义化版本 SemVer，格式 `vMAJOR.MINOR.PATCH`）：
   - `MAJOR`：不兼容变更、重大重构
   - `MINOR`：新增功能（向后兼容）
   - `PATCH`：修复、小改动
   - 首次发版默认 `v1.0.0`；已有版本时按变更类型递增。**版本号与版本说明向用户确认后再执行。**
3. **打标签并推送**：
   - `git tag -a vX.Y.Z -m "vX.Y.Z: <一句话摘要>"`
   - `git push origin vX.Y.Z`
4. **创建 Release**（GitHub 版本迭代展示页）：
   - `gh release create vX.Y.Z --title "vX.Y.Z" --notes "<版本迭代说明>"`
   - 版本迭代说明格式（Markdown）：
     ```
     ## 变更内容
     - 新增：<本次新增的功能>
     - 改进：<本次优化/调整>
     - 修复：<本次修复的问题>
     ## 说明
     <一句话总结本次版本定位>
     ```
5. **验证**：`gh release list`、`gh release view vX.Y.Z`。
6. **打 Tag / 创建 Release 属对外发布动作，必须先向用户确认版本号与版本说明内容。**

## 阶段 G：路径反馈（交付报告）

最终回复必须**把所有路径和状态写清楚**，至少包含：

- 本地项目绝对路径
- 远程仓库完整 URL
- 远程名称与分支（如 origin / main）
- 提交历史（哈希 + 信息）
- 关键文件相对路径（README.md、LICENSE、skill 目录等）
- 工作区状态（干净/有未提交改动）
- 尚未完成的事项与原因（如有）

**可见性说明（用户困惑时主动解释）：**
- **私有仓库**：默认不显示在 GitHub 个人主页（"热门存储库/置顶"区只展示公开仓库），贡献仍计入个人贡献图。查看方式：登录 GitHub 后点个人页顶部 **存储库（Repositories）** 标签，即可看到包括私有仓库在内的全部仓库；也可直接访问 `https://github.com/<owner>/<repo>`。
- **公开仓库**：所有访客可见，主页可显示。
- 想要私有仓库出现在主页：在仓库 Settings → General → 勾选 "Pin this repository"（置顶）。

## 边界与安全

- 涉及**管理员权限、系统修改、安装软件、浏览器授权、创建公开仓库、改写历史/强制推送、打 Tag/创建 Release**：先说明，等确认。
- 用户明确要求检查时"不要执行 Git 操作"，则全程只读。
- 不在对话中展示、不要求用户提供密码/Token。
- Classic PAT（`ghp_`）认证模式下，token 由用户自行生成并放入 agent 配置/环境变量（`GH_TOKEN`），agent 不索要、不展示、不记录明文。
- LICENSE 版权人、提交身份（姓名/邮箱）、仓库可见性、版本号与版本说明等个人信息与对外发布内容，先问后写。
