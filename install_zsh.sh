#!/bin/bash

# 自动安装 zsh 脚本
# 功能: 自动检测并安装 zsh、oh-my-zsh 和相关插件

set -e  # 遇到错误时退出

echo "开始自动安装zsh..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. 检测并安装zsh
print_message "步骤1: 检测zsh安装状态..."
if command -v zsh &> /dev/null; then
    print_message "zsh已经安装: $(which zsh)"
else
    print_message "zsh未安装，正在安装..."
    sudo apt update
    sudo apt install -y zsh
    print_message "zsh安装完成"
fi

# 设置zsh为默认shell
print_message "设置zsh为默认shell..."
if [ "$SHELL" != "/bin/zsh" ]; then
    chsh -s /bin/zsh
    print_message "已将zsh设置为默认shell，重启后生效"
else
    print_message "zsh已经是默认shell"
fi

# 2. 检测并安装必要的工具
print_message "步骤2: 检测必要工具..."
TOOLS=("git" "curl" "wget")
MISSING_TOOLS=()

for tool in "${TOOLS[@]}"; do
    if ! command -v $tool &> /dev/null; then
        MISSING_TOOLS+=($tool)
    else
        print_message "$tool 已安装: $(which $tool)"
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    print_message "安装缺失的工具: ${MISSING_TOOLS[*]}"
    sudo apt update
    sudo apt install -y "${MISSING_TOOLS[@]}"
    print_message "工具安装完成"
fi

# 3. 安装oh-my-zsh
print_message "步骤3: 安装oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_message "开始安装oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_message "oh-my-zsh安装完成"
else
    print_message "oh-my-zsh已经安装"
fi

# 4. 安装插件
print_message "步骤4: 安装zsh插件..."

# 创建插件目录
PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
mkdir -p "$PLUGINS_DIR"

# 插件列表
PLUGINS=(
    "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-completions:https://github.com/zsh-users/zsh-completions"
)

for plugin in "${PLUGINS[@]}"; do
    IFS=':' read -r plugin_name plugin_url <<< "$plugin"
    plugin_path="$PLUGINS_DIR/$plugin_name"
    
    if [ ! -d "$plugin_path" ]; then
        print_message "安装插件: $plugin_name"
        git clone "$plugin_url" "$plugin_path"
        print_message "$plugin_name 安装完成"
    else
        print_message "插件 $plugin_name 已存在"
    fi
done

# 5. 配置.zshrc
print_message "步骤5: 配置.zshrc文件..."
ZSH_RC="$HOME/.zshrc"

# 备份原配置文件
if [ -f "$ZSH_RC" ]; then
    cp "$ZSH_RC" "$ZSH_RC.backup.$(date +%Y%m%d_%H%M%S)"
    print_message "已备份原.zshrc文件"
fi

# 更新插件配置
if [ -f "$ZSH_RC" ]; then
    # 替换plugins行
    sed -i 's/plugins=(git)/plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSH_RC"
    
    # 添加autoload行（如果不存在）
    if ! grep -q "autoload -U compinit && compinit" "$ZSH_RC"; then
        echo "" >> "$ZSH_RC"
        echo "# 自动补全配置" >> "$ZSH_RC"
        echo "autoload -U compinit && compinit" >> "$ZSH_RC"
    fi
    
    print_message ".zshrc配置更新完成"
else
    print_error ".zshrc文件不存在，请手动创建"
fi

# 完成提示
echo ""
print_message "zsh安装和配置完成！"
print_message "请重启终端或执行 'exec zsh' 来切换到zsh"
print_message "如果遇到问题，可以查看备份的.zshrc文件: $ZSH_RC.backup.*"
echo ""
print_message "已安装的插件:"
echo "  - zsh-syntax-highlighting (语法高亮)"
echo "  - zsh-autosuggestions (自动建议)"
echo "  - zsh-completions (自动补全)"
echo ""
