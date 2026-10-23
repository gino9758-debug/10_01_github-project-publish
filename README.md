# github-project-publish

GitHub 项目发布与版本迭代管理技能（Skill）：把本地项目从零发布到 GitHub，并通过 Tag + Release 管理版本迭代历史。

## 用途

本仓库为「github-project-publish」技能本体 + **技能仓库命名与发布规范**的标准储藏库，是账号内全部技能仓库发布、命名、可见性管理与版本迭代的统一依据。

## 技能覆盖能力

1. 检查 CLI 是否畅通（git / gh 安装、版本、登录状态）
2. 完善项目根目录 README.md
3. 添加 LICENSE
4. 检查项目安全隐患（凭据/隐私/路径/临时文件等）
5. 记录仓库名称/路径等信息
6. 完成提交上传
7. 版本迭代管理：语义化版本号、Tag 推送、GitHub Release 与版本迭代说明
8. **技能仓库命名规范**：分类编号（XX_YY_英文名）、中文描述格式、可见性规则、实例清单（见 `docs/skill-repository-naming-convention.md`）

## 目录结构

```
github-project-publish/
├── SKILL.md                        # 核心工作流（7阶段：环境检查→文档准备→安全检查→仓库记录→提交上传→版本迭代→路径反馈）
├── docs/
│   └── skill-repository-naming-convention.md   # 技能仓库命名与发布规范（分类编号/描述/可见性/实例/迭代/协同约定）
├── references/
│   ├── security-check.md           # 安全隐患检查清单
│   ├── readme-template.md          # README 五段式模板
│   └── license-template.md         # MIT 模板与协议选择
└── scripts/
    └── scan_secrets.sh             # 安全隐患扫描脚本（只读）
```

## 安装方法

将 `github-project-publish/` 目录放入助手的技能根目录（如 `.user_skills/`），重启会话后技能即可被发现和调用。

## 使用方法

- **发布项目**：对助手说「用 github-project-publish 发布 XX 项目」触发完整发布流水线。
- **迭代更新**：对助手说「更新 XX 并发布版本/版本迭代」——先提交推送变更，再按语义化版本打 Tag 并创建 GitHub Release（含版本说明）。
- **查看版本历史**：GitHub 仓库页 → Releases 标签，或访问 `https://github.com/<owner>/<repo>/releases`。
