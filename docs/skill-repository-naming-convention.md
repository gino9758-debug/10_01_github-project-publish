# 技能仓库命名与发布规范（Skill Repository Naming & Publishing Convention）

> 本规范用于 gino9758-debug 账号下所有技能（Skill）仓库的统一命名、可见性管理与版本迭代，是批量发布与未来协同开发的标准依据。创建新技能仓库前先读本文件。

## 一、仓库命名规则

**格式：`XX_YY_英文名`**

- `XX`：类别编号（两位数字，见下表）
- `YY`：该类别内的上传顺序（两位数字，从 01 递增）
- `英文名`：技能本身的英文标识（小写 + 连字符，如 `skill-commander-intent`）

完整示例：`10_01_github-project-publish` = 通用工具类 · 第 1 个上传 · github-project-publish 技能。

### 类别编号表

| 类别编号 | 类别 | 说明 |
|---|---|---|
| 02 | 家庭教育 | 育儿、亲子、儿童发展与学能 |
| 05 | 内容制作 | 视频/图文/下载器等创作工具 |
| 08 | 认知管理 | 思维框架、决策、知识管理 |
| 09 | 电商相关 | 供应链、品质、电商业务技能 |
| 10 | 通用工具 | 平台操作、效率类基础工具 |

### 编号分配规则

- 顺序号按**上传时间先后**递增，新仓库取该类别当前最大号 + 1。
- **预留号**：`02_01` 已预留（留给尚未上传的重要技能），后续任何仓库不得占用；如未来需预留其他号，在下方"预留号登记"中记录。
- 已占用号不因仓库改名、删除而回收（保持历史可追溯）。

### 预留号登记

| 预留号 | 预留原因 | 占用时间 |
|---|---|---|
| 02_01 | 未上传的重要技能 | 2026-10-21 起 |

## 二、GitHub 平台限制（重要）

- **GitHub 不支持中文仓库名**：任意来源的中文名都会被自动替换为连字符（已实测验证，API 创建/改名均如此）。因此**仓库名一律用英文**。
- 中文名通过**仓库描述**呈现，格式：

  ```
  「中文名 - XX_YY_英文名（一句话定位 Skill）」
  ```

  示例：`家庭PBL教育实践 - 02_02_family-pbl-education（家庭项目制学习与教育方法论 Skill）`

## 三、可见性规则

- **默认公开**：不涉及个人信息的技能仓库一律 `public`。
- **涉个人信息 → 私有或脱敏**：包含真实姓名、家庭成员信息（出生年份、兴趣特征）、手机号、邮箱、家庭地址等，先**脱敏**（删隐私段 / 姓名替换为"使用者"）再公开；无法脱敏的保持 `private`。
- 提交历史中的作者姓名与邮箱同样会公开，介意则改用 GitHub noreply 邮箱。

## 四、实例清单（截至 2026-10-23）

全部 14 个仓库均为 `public`，均带中文描述。

### 10 通用工具
| 编号 | 仓库名 | 中文名 |
|---|---|---|
| 10_01 | github-project-publish | GitHub项目发布 |
| 10_02 | skill-commander-intent | 命令意图识别 |
| 10_03 | dedao-getnote | 得到笔记 |

### 02 家庭教育
| 编号 | 仓库名 | 中文名 |
|---|---|---|
| 02_02 | family-pbl-education | 家庭PBL教育实践 |
| 02_03 | self-driven-parenting | 自驱型育儿顾问 |
| 02_03 | structured-thinking-decision | 结构化思维决策 |
| 02_04 | brain-health-advisor | 脑健康家庭顾问 |
| 02_05 | child-dev-learning | 儿童发育行为与学能发展 |

### 05 内容制作
| 编号 | 仓库名 | 中文名 |
|---|---|---|
| 05_01 | XHS-Downloader | 小红书下载器 |

### 08 认知管理
| 编号 | 仓库名 | 中文名 |
|---|---|---|
| 08_01 | decision-feedback-loop | 决策反馈循环 |
| 08_02 | human-scale | 人为尺度 |
| 08_03 | cognitive-recursion-scorecard | 认知递归与内在记分卡 |

### 09 电商相关
| 编号 | 仓库名 | 中文名 |
|---|---|---|
| 09_01 | textile-process-quality | 纺织服装工艺质量分析 |
| 09_02 | yks-qms-knitwear-iso9001 | 质量体系管理（有棵树版） |

> 注：`02_03_self-driven-parenting` 与 `02_03_structured-thinking-decision` 同号系用户原稿如此，保留不改。

## 五、发布与版本迭代操作速查

### 发布新仓库（简版流程）

1. 准备：仓库内含 `SKILL.md` + `README.md` + `LICENSE(MIT)` + `.gitignore`
2. 安全检查：扫描 Token/隐私/路径/临时文件（见 `references/security-check.md`）
3. 命名：按本文档规范取 `XX_YY_英文名`，设置中文描述
4. 创建并推送：`gh repo create gino9758-debug/XX_YY_英文名 --public --source=. --remote=origin --push`
5. 核验：`gh repo view gino9758-debug/<名>` 确认名称/可见性/描述

### 版本迭代（Tag + Release）

语义化版本 `vMAJOR.MINOR.PATCH`：

| 位 | 何时递增 | 示例 |
|---|---|---|
| MAJOR | 不兼容变更、重大重构 | v2.0.0 |
| MINOR | 新增功能（向后兼容） | v1.1.0 |
| PATCH | 修复、小改动 | v1.0.1 |

操作命令：

```bash
# 1. 提交变更
git add -A && git commit -m "变更说明"
git push origin main

# 2. 打标签并推送
git tag -a v1.1.0 -m "v1.1.0: 一句话摘要"
git push origin v1.1.0

# 3. 创建 Release（含版本说明）
gh release create v1.1.0 --title "v1.1.0" --notes "变更说明"
```

Release 页面：`https://github.com/gino9758-debug/<仓库名>/releases`

## 六、协同开发约定（初版）

- **分支模型**：`main` 为稳定主线；新功能/修复开 `feat/xx` 或 `fix/xx` 分支，合并用 Pull Request。
- **发版节奏**：每次向 `main` 合入实质变更后，按 SemVer 打 Tag + 建 Release；版本说明写清"新增/改进/修复"。
- **协作身份**：协作者用自己的 GitHub 身份提交；仓库作者信息公开前先确认。
- **安全底线**：任何协作者不得把 Token、密钥、个人信息写入仓库；发现即脱敏或回滚。
