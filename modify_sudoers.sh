#!/bin/bash

# 修改 sudoers 文件以允许 sudo 组用户免密操作
# 作者: cursor
# 日期: 2025-10-04

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否以 root 权限运行
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "此脚本需要root权限运行"
        log_info "请使用: sudo $0"
        exit 1
    fi
}

# 备份sudoers文件
backup_sudoers() {
    local backup_file="/etc/sudoers.backup.$(date +%Y%m%d_%H%M%S)"
    log_info "备份sudoers文件到: $backup_file"
    cp /etc/sudoers "$backup_file"
    chmod 440 "$backup_file"
    echo "$backup_file"
}

# 修改sudoers文件权限
modify_permissions() {
    log_info "修改sudoers文件权限为可写..."
    chmod 640 /etc/sudoers
    if [ $? -eq 0 ]; then
        log_info "权限修改成功"
    else
        log_error "权限修改失败"
        exit 1
    fi
}

# 编辑sudoers文件
edit_sudoers() {
    log_info "编辑sudoers文件..."
    
    # 使用sed命令修改sudoers文件
    # 将 %sudo   ALL=(ALL:ALL) ALL 替换为 %sudo   ALL=(ALL:ALL) NOPASSWD:ALL
    sed -i 's/^%sudo[[:space:]]*ALL=(ALL:ALL)[[:space:]]*ALL/%sudo   ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers
    
    if [ $? -eq 0 ]; then
        log_info "sudoers文件编辑成功"
    else
        log_error "sudoers文件编辑失败"
        exit 1
    fi
}

# 验证sudoers文件语法
validate_sudoers() {
    log_info "验证sudoers文件语法..."
    visudo -c
    if [ $? -eq 0 ]; then
        log_info "sudoers文件语法验证通过"
    else
        log_error "sudoers文件语法验证失败，正在恢复备份..."
        restore_backup
        exit 1
    fi
}

# 恢复sudoers文件权限
restore_permissions() {
    log_info "恢复sudoers文件权限..."
    chmod 440 /etc/sudoers
    if [ $? -eq 0 ]; then
        log_info "权限恢复成功"
    else
        log_error "权限恢复失败"
        exit 1
    fi
}

# 恢复备份（如果出错）
restore_backup() {
    if [ -n "$BACKUP_FILE" ] && [ -f "$BACKUP_FILE" ]; then
        log_warn "正在从备份恢复sudoers文件..."
        cp "$BACKUP_FILE" /etc/sudoers
        chmod 440 /etc/sudoers
        log_info "已从备份恢复sudoers文件"
    fi
}

# 显示修改结果
show_result() {
    log_info "修改完成！"
    log_info "现在sudo组用户可以免密执行sudo命令"
    echo
    log_info "修改的内容："
    grep "^%sudo" /etc/sudoers || log_warn "未找到%sudo配置行"
}

# 主函数
main() {
    log_info "开始修改sudoers文件以允许sudo组用户免密操作..."
    
    # 检查root权限
    check_root
    
    # 备份原文件
    BACKUP_FILE=$(backup_sudoers)
    
    # 设置错误处理
    trap 'log_error "脚本执行出错，正在恢复备份..."; restore_backup; exit 1' ERR
    
    # 执行修改步骤
    modify_permissions
    edit_sudoers
    validate_sudoers
    restore_permissions
    
    # 显示结果
    show_result
    
    log_info "脚本执行完成！"
}

# 执行主函数
main "$@"
