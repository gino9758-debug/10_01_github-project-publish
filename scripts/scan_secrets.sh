#!/usr/bin/env bash
# 项目安全隐患扫描脚本（只读，不修改任何文件）
# 用法: bash scan_secrets.sh <项目绝对路径>
set -u

PROJECT="${1:-}"
if [ -z "$PROJECT" ] || [ ! -d "$PROJECT" ]; then
  echo "用法: bash scan_secrets.sh <项目绝对路径>" >&2
  exit 1
fi
cd "$PROJECT" || exit 1

echo "=== 1. 文件清单（排除 .git） ==="
find . -not -path './.git/*' -not -name '.git' -type f | sort

echo ""
echo "=== 2. 密码/Token/凭据 ==="
grep -rniE "gh[pousr]_|github_pat|api[_-]?key|secret|password|passwd|authorization|bearer\s+\S+" . \
  --exclude-dir=.git --exclude-dir=.tmp-tool-results 2>/dev/null | grep -vE "read token from standard input" || echo "✅ 未发现"

echo ""
echo "=== 3. 本地绝对路径 ==="
grep -rniE "/home/|/Users/|/tmp/|/var/|/etc/|/root/|/opt/" . \
  --exclude-dir=.git --exclude-dir=.tmp-tool-results 2>/dev/null || echo "✅ 未发现"

echo ""
echo "=== 4. 个人隐私（手机号/身份证/邮箱） ==="
grep -rniE "1[3-9][0-9]{9}|[0-9]{17}[0-9Xx]|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" . \
  --exclude-dir=.git --exclude-dir=.tmp-tool-results 2>/dev/null || echo "✅ 未发现"

echo ""
echo "=== 5. 临时/垃圾文件（磁盘上存在但需关注） ==="
find . -not -path './.git/*' \( -name "*.tmp" -o -name "*.bak" -o -name "*.swp" -o -name "bash-live-*.txt" -o -path "*/.tmp-*" \) 2>/dev/null || echo "✅ 未发现"

echo ""
echo "=== 6. Git 跟踪文件是否含敏感项（将随仓库公开） ==="
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git ls-files -z | xargs -0 -I{} grep -l -iE "gh[pousr]_|github_pat|api[_-]?key|secret|password|passwd|authorization|bearer\s+\S+" "{}" 2>/dev/null || echo "✅ 已跟踪文件无凭据"
  echo ""
  echo "=== 7. 提交历史作者身份 ==="
  git log --format='%h %an <%ae>' 2>/dev/null || echo "（无提交历史）"
else
  echo "（非 Git 仓库，跳过 6/7）"
fi

echo ""
echo "=== 扫描完成 ==="
