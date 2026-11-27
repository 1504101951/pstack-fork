#!/usr/bin/env bash
# pstack-fork 安装脚本。
# 流程：1. 准备仓库（克隆或更新到 ~/pstack-fork）；2. 检测本机装了哪些 AI agent；
#       3. 让用户勾选要安装的 agent；4. 为选中的 agent 安装技能。
# 支持 macOS 和 Linux。只用 bash 3.2 也有的语法，因为 macOS 自带的是 bash 3.2。
# 用法：curl -fsSL https://raw.githubusercontent.com/1504101951/pstack-fork/main/install.sh | bash
#       重复运行即更新。
set -euo pipefail

REPO_URL="https://github.com/1504101951/pstack-fork.git"
REPO_DIR="$HOME/pstack-fork"

# 支持的 agent 统一登记在这张表里，每行一个，字段用 | 分隔：
#   命令名 | 显示名称 | 技能链接目录（为空表示用插件方式安装）| 安装后要运行的命令
# 新增或修改 agent 只改这张表。
AGENTS="claude|Claude Code|$HOME/.claude/skills|/setup-pstack
codex|Codex|$HOME/.agents/skills|\$setup-pstack
agy|Antigravity CLI (agy)||/setup-pstack"

# 函数作用：打印错误信息并结束脚本。
# 参数：$1 错误信息（字符串）。
# 返回：不返回，以退出码 1 结束。
die() {
  printf '错误：%s\n' "$1" >&2
  exit 1
}

# 函数作用：取出 AGENTS 表中某个 agent 的某个字段。
# 参数：$1 命令名（如 claude）；$2 字段序号（1 命令名，2 显示名称，3 技能链接目录，4 安装后命令）。
# 返回：把字段值打印到标准输出。
agent_field() {
  printf '%s\n' "$AGENTS" | awk -F'|' -v key="$1" -v col="$2" '$1 == key { print $col }'
}

# 函数作用：把仓库准备到 REPO_DIR。不存在就克隆；已是本仓库就更新；是别的东西就报错停下，不覆盖。
# 参数：无。
# 返回：无；失败时结束脚本。
prepare_repo() {
  if [ ! -e "$REPO_DIR" ]; then
    echo "克隆 pstack-fork 到 $REPO_DIR ..."
    git clone --quiet "$REPO_URL" "$REPO_DIR"
    return
  fi
  [ -d "$REPO_DIR/.git" ] || die "$REPO_DIR 已存在，但不是 pstack-fork 仓库。请先移走或删除它，再重新运行。"
  case "$(git -C "$REPO_DIR" remote get-url origin)" in
    *1504101951/pstack-fork*) ;;
    *) die "$REPO_DIR 是另一个 git 仓库，不是 pstack-fork。请先移走它，再重新运行。" ;;
  esac
  echo "更新 $REPO_DIR ..."
  git -C "$REPO_DIR" pull --quiet --ff-only
}

# 函数作用：列出本机装了、且在 AGENTS 表里的 agent。
# 参数：无。
# 返回：每行打印一个命令名；一个都没有时结束脚本。
detect_agents() {
  local found="" cmd
  for cmd in $(printf '%s\n' "$AGENTS" | cut -d'|' -f1); do
    command -v "$cmd" >/dev/null 2>&1 && found="$found $cmd"
  done
  [ -n "$found" ] || die "没有检测到 Claude Code（claude）、Codex（codex）或 Antigravity CLI（agy）命令。"
  printf '%s\n' $found
}

# 函数作用：用方向键菜单让用户勾选要安装的 agent。↑↓（或 k/j）移动，空格勾选或取消，回车确认，默认全选。
#           通过 /dev/tty 读键盘、画菜单，因为用 curl | bash 运行时标准输入是脚本本身。
#           选择期间隐藏光标；退出时（包括 Ctrl+C）由 trap 恢复光标。
# 参数：$@ 检测到的命令名列表。
# 返回：每行打印一个选中的命令名；一个都没选时结束脚本。
choose_agents() {
  local names=("$@") marks=() n=$# cur=0 drawn=0 i key rest box ptr picked=""
  for ((i = 0; i < n; i++)); do marks[i]=1; done
  trap 'printf "\033[?25h" >/dev/tty' EXIT
  trap 'exit 130' INT
  printf '\033[?25l' >/dev/tty
  echo "检测到以下 AI（↑↓ 移动，空格 勾选/取消，回车 确认）：" >/dev/tty
  while :; do
    # 第二次起先把光标移回菜单第一行，再逐行覆盖重画。
    [ "$drawn" = 1 ] && printf '\033[%dA' "$n" >/dev/tty
    for ((i = 0; i < n; i++)); do
      box="[ ]"; [ "${marks[i]}" = 1 ] && box="[x]"
      ptr="  "; [ "$i" = "$cur" ] && ptr="> "
      printf '\033[2K%s%s %s\n' "$ptr" "$box" "$(agent_field "${names[i]}" 2)" >/dev/tty
    done
    drawn=1
    IFS= read -rsn1 key </dev/tty
    # 方向键是 ESC [ A / ESC [ B 三个字节，读到 ESC 后再读两个字节。
    if [ "$key" = $'\e' ]; then
      IFS= read -rsn2 rest </dev/tty
      key="$rest"
    fi
    case "$key" in
      '[A'|k) cur=$(((cur + n - 1) % n)) ;;
      '[B'|j) cur=$(((cur + 1) % n)) ;;
      ' ') marks[cur]=$((1 - marks[cur])) ;;
      '') break ;;
    esac
  done
  for ((i = 0; i < n; i++)); do
    [ "${marks[i]}" = 1 ] && picked="$picked ${names[i]}"
  done
  [ -n "$picked" ] || die "未选择任何 AI。"
  printf '%s\n' $picked
}

# 函数作用：把仓库里的每个技能目录软链接到 agent 的技能目录。
#           先检查冲突再动手：目标位置已有同名的真实目录或文件时报错停下，不覆盖用户原有的技能。
#           同时删掉指向本仓库、但技能已不存在的旧链接，所以重复运行等于更新。
# 参数：$1 agent 的技能目录（绝对路径）。
# 返回：无；有冲突时结束脚本。
link_skills() {
  local target="$1" src name conflicts="" link
  mkdir -p "$target"
  for src in "$REPO_DIR"/skills/*/; do
    name=$(basename "$src")
    [ -e "$target/$name" ] && [ ! -L "$target/$name" ] && conflicts="$conflicts $name"
  done
  [ -z "$conflicts" ] || die "$target 里已有同名的目录或文件：${conflicts# }。请先移走它们，再重新运行。"
  # 清理指向本仓库但已失效的旧链接。
  for link in "$target"/*; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in
      "$REPO_DIR"/skills/*) [ -e "$link" ] || rm "$link" ;;
    esac
  done
  for src in "$REPO_DIR"/skills/*/; do
    ln -sfn "${src%/}" "$target/$(basename "$src")"
  done
}

# 函数作用：为一个 agent 安装 pstack-fork。有技能链接目录的用软链接，没有的（agy）用插件方式。
# 参数：$1 命令名。
# 返回：无；安装失败时结束脚本。
install_agent() {
  local cmd="$1" dir
  dir=$(agent_field "$cmd" 3)
  echo "安装到 $(agent_field "$cmd" 2) ..."
  if [ -n "$dir" ]; then
    link_skills "$dir"
    return
  fi
  agy plugin validate "$REPO_DIR"
  agy plugin install "$REPO_DIR"
}

# 主流程：准备仓库 → 检测 → 勾选 → 逐个安装 → 打印下一步。
# 检测结果先存进变量：赋值语句会把 detect_agents 的失败传给 set -e，直接写在参数里则不会。
prepare_repo
detected=$(detect_agents)
# shellcheck disable=SC2086  # 命令名不含空格，按词拆分是有意为之。
selected=$(choose_agents $detected)
for cmd in $selected; do
  install_agent "$cmd"
done
echo
echo "安装完成。接下来请在每个 AI 里运行一次 setup-pstack，创建 pstack 需要的子 agent："
for cmd in $selected; do
  printf '  %s：%s\n' "$(agent_field "$cmd" 2)" "$(agent_field "$cmd" 4)"
done
echo "以后重新运行这条安装命令即可更新。更新后请在每个 AI 里再运行一次 setup-pstack。"
