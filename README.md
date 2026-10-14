# github-project-publish

GitHub 项目发布全流程技能（Skill）：把本地项目从零发布到 GitHub 并完成首轮提交。

## 用途

本仓库为**私有储藏**用途，用于备份和版本管理「github-project-publish」技能本体。

## 技能覆盖能力

1. 检查 CLI 是否畅通（git / gh 安装、版本、登录状态）
2. 完善项目根目录 README.md
3. 添加 LICENSE
4. 检查项目安全隐患（凭据/隐私/路径/临时文件等）
5. 记录仓库名称/路径等信息
6. 完成提交上传

## 目录结构

```
github-project-publish/
├── SKILL.md                        # 核心工作流（6阶段：环境检查→文档准备→安全检查→仓库记录→提交上传→路径反馈）
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

对助手说「用 github-project-publish 发布 XX 项目」即可触发完整发布流水线。
