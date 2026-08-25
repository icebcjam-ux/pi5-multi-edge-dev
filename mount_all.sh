#!/bin/bash

# 定義遠端裝置資訊
# 格式："地名|IP|遠端帳號|遠端路徑|本地掛載點"
MOUNTS=(
  "Lcd|192.168.1.121|lcd|/home/lcd/|/home/red/mount_all/lcd"
  "Zero 2w|192.168.1.104|zero2w|/home/zero2w/|/home/red/mount_all/zero2w"
  "White|192.168.1.116|white|/home/white|/home/red/mount_all/white"
)

for target in "${MOUNTS[@]}"; do
  IFS="|" read -r NAME IP USER REMOTE_PATH LOCAL_PATH <<< "$target"

  # 1. 確保本地資料夾存在
  mkdir -p "$LOCAL_PATH"

  # 2. 檢查是否已經掛載，若未掛載才進行 SSHFS 掛載
  if mountpoint -q "$LOCAL_PATH"; then
    echo "[$NAME] 已經掛載於 $LOCAL_PATH，跳過。"
  else
    echo "[$NAME] 正在掛載至 $LOCAL_PATH..."
    sshfs "${USER}@${IP}:${REMOTE_PATH}" "$LOCAL_PATH" -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
    
    if [ $? -eq 0 ]; then
      echo "[$NAME] 掛載成功！"
    else
      echo "[$NAME] 掛載失敗，請檢查 IP 或 SSH Key 連線。"
    fi
  fi
done
