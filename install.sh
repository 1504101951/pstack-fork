#!/usr/bin/env bash
# pstack-fork 安装脚本。
# 流程：1. 准备仓库（克隆或更新到 ~/pstack-fork）；2. 检测本机装了哪些 AI agent；
#       3. 让用户勾选要安装的 agent；4. 为选中的 agent 安装插件。
# 支持 macOS 和 Linux。只用 bash 3.2 也有的语法，因为 macOS 自带的是 bash 3.2。
# 用法：curl -fsSL https://raw.githubusercontent.com/1504101951/pstack-fork/main/install.sh | bash
#       重复运行即更新。
set -euo pipefail

REPO_URL="https://github.com/1504101951/pstack-fork.git"
REPO_DIR="$HOME/pstack-fork"
# 仓库同时是三家 agent 的插件和市场，名字都叫 pstack-fork。
NAME="pstack-fork"
# agy 安装插件后存放插件的目录，用来判断 agy 是否已安装 pstack-fork。
AGY_PLUGIN_DIR="$HOME/.gemini/config/plugins/$NAME"

# 支持的 agent 统一登记在这张表里，每行一个，字段用 | 分隔：
#   命令名 | 显示名称 | 菜单里"已装"的标注 | 安装后的下一步
# 新增 agent 时，在这张表加一行，并补上同名的 install_<命令名> 函数和 is_installed 里的判断。
AGENTS="claude|Claude Code|已安装|/pstack-fork:setup-pstack
codex|Codex|市场已添加|先在 Codex 里运行 /plugins，打开 pstack-fork 并选择 Install plugin；再开新会话，输入 @ 选择 setup-pstack
agy|Antigravity CLI (agy)|已安装|/setup-pstack"

# 函数作用：打印错误信息并结束脚本。
# 参数：$1 错误信息（字符串）。
# 返回：不返回，以退出码 1 结束。
die() {
  printf '错误：%s\n' "$1" >&2
  exit 1
}

# 函数作用：取出 AGENTS 表中某个 agent 的某个字段。
# 参数：$1 命令名（如 claude）；$2 字段序号（1 命令名，2 显示名称，3 已装标注，4 下一步）。
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

# 函数作用：判断某个 agent 是否已装过 pstack-fork。
#           Claude Code：插件列表里有 pstack-fork@pstack-fork；
#           Codex：已添加名为 pstack-fork 的市场（插件本身要在 Codex 的 /plugins 里手动安装）；
#           agy：插件目录存在。
# 参数：$1 命令名。
# 返回：已装过时退出码为 0，否则非 0。
is_installed() {
  case "$1" in
    claude) claude plugin list --json 2>/dev/null </dev/null | grep -qE "\"id\": *\"$NAME@$NAME\"" ;;
    codex) codex plugin marketplace list 2>/dev/null </dev/null | grep -qw "$NAME" ;;
    agy) [ -d "$AGY_PLUGIN_DIR" ] ;;
  esac
}

# 函数作用：用方向键菜单让用户勾选要安装的 agent。↑↓（或 k/j）移动，空格勾选或取消，回车确认，默认全选。
#           通过 /dev/tty 读键盘、画菜单，因为用 curl | bash 运行时标准输入是脚本本身。
#           已装过的项在右边标注：勾选时为"<标注>，将更新"，未勾选时为"<标注>"，标注文字取自 AGENTS 表。
#           选择期间隐藏光标；退出时（包括 Ctrl+C）由 trap 恢复光标。
# 参数：$@ 检测到的命令名列表。
# 返回：每行打印一个选中的命令名；一个都没选时结束脚本。
choose_agents() {
  local names=("$@") marks=() labels=() status=() n=$# cur=0 drawn=0 width=0 i key rest box ptr note picked=""
  # 预先算好名称、已装标注和名称列宽，重画时不再重复计算；status 为空表示没装过。
  for ((i = 0; i < n; i++)); do
    marks[i]=1
    labels[i]=$(agent_field "${names[i]}" 2)
    status[i]=""
    is_installed "${names[i]}" && status[i]=$(agent_field "${names[i]}" 3)
    [ "${#labels[i]}" -gt "$width" ] && width=${#labels[i]}
  done
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
      note=""
      [ -n "${status[i]}" ] && note="（${status[i]}）"
      [ -n "${status[i]}" ] && [ "${marks[i]}" = 1 ] && note="（${status[i]}，将更新）"
      printf '\033[2K%s%s %-*s  %s\n' "$ptr" "$box" "$width" "${labels[i]}" "$note" >/dev/tty
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

# 函数作用：为 Claude Code 安装 pstack-fork。把 REPO_DIR 添加为市场，再安装其中的同名插件。
#           两条命令重复运行都会成功。插件从 REPO_DIR 原地加载，所以仓库更新后插件随之更新。
#           安装类命令的标准输入接到终端：curl | bash 运行时标准输入是脚本本身，不能被子命令读走。
# 参数：无。
# 返回：无；命令失败时结束脚本。
install_claude() {
  claude plugin marketplace add "$REPO_DIR" </dev/tty
  claude plugin install "$NAME@$NAME" </dev/tty
}

# 函数作用：为 Codex 添加 pstack-fork 市场。Codex 的文档没有给出命令行安装插件的方式，
#           所以插件要在 Codex 的 /plugins 里手动安装，下一步会提示。已添加过市场就不重复添加。
# 参数：无。
# 返回：无；命令失败时结束脚本。
install_codex() {
  is_installed codex || codex plugin marketplace add "$REPO_DIR" </dev/tty
}

# 函数作用：为 agy 安装或更新 pstack-fork 插件。
#           已安装时先卸载再安装，因为 agy 的文档没说明重复安装的行为。
#           先校验再卸载，校验失败就停下，避免旧插件已卸掉、新插件又装不上。
# 参数：无。
# 返回：无；命令失败时结束脚本。
install_agy() {
  agy plugin validate "$REPO_DIR" </dev/tty
  is_installed agy && agy plugin uninstall "$NAME" </dev/tty
  agy plugin install "$REPO_DIR" </dev/tty
}

# 主流程：准备仓库 → 检测 → 勾选 → 逐个安装 → 打印下一步。
# 检测结果先存进变量：赋值语句会把 detect_agents 的失败传给 set -e，直接写在参数里则不会。
prepare_repo
detected=$(detect_agents)
# shellcheck disable=SC2086  # 命令名不含空格，按词拆分是有意为之。
selected=$(choose_agents $detected)
for cmd in $selected; do
  echo "安装到 $(agent_field "$cmd" 2) ..."
  "install_$cmd"
done
echo
echo "安装完成。接下来请在每个 AI 里运行一次 setup-pstack，创建 pstack 需要的子 agent："
for cmd in $selected; do
  printf '  %s：%s\n' "$(agent_field "$cmd" 2)" "$(agent_field "$cmd" 4)"
done
echo "以后重新运行这条安装命令即可更新。更新后请在每个 AI 里再运行一次 setup-pstack。"
