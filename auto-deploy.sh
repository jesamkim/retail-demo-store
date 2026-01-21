#!/bin/bash

LOG_FILE="auto-deploy.log"

echo "=================================================================================" | tee -a $LOG_FILE
echo "자동 배포 프로세스 시작" | tee -a $LOG_FILE
echo "시작 시간: $(date)" | tee -a $LOG_FILE
echo "=================================================================================" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# 1단계: 스택 삭제 완료 대기
echo "1단계: 스택 삭제 완료 대기 중..." | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

MAX_WAIT_MINUTES=30
WAIT_COUNT=0

while [ $WAIT_COUNT -lt $MAX_WAIT_MINUTES ]; do
    STATUS=$(aws cloudformation describe-stacks \
        --stack-name retaildemostore-v2 \
        --profile profile2 \
        --region us-east-1 \
        --query 'Stacks[0].StackStatus' \
        --output text 2>&1)

    if [[ "$STATUS" == *"does not exist"* ]] || [[ "$STATUS" == *"does not exist"* ]]; then
        echo "$(date +%H:%M:%S) - ✅ 스택 삭제 완료!" | tee -a $LOG_FILE
        echo "" | tee -a $LOG_FILE
        break
    fi

    echo "$(date +%H:%M:%S) - 대기 중... (상태: $STATUS, 경과: ${WAIT_COUNT}분)" | tee -a $LOG_FILE

    if [ "$STATUS" = "DELETE_FAILED" ]; then
        echo "❌ 스택 삭제 실패!" | tee -a $LOG_FILE
        exit 1
    fi

    sleep 60
    WAIT_COUNT=$((WAIT_COUNT + 1))
done

if [ $WAIT_COUNT -ge $MAX_WAIT_MINUTES ]; then
    echo "❌ 타임아웃: ${MAX_WAIT_MINUTES}분 경과" | tee -a $LOG_FILE
    exit 1
fi

# 2단계: 재배포
echo "=================================================================================" | tee -a $LOG_FILE
echo "2단계: 수정된 설정으로 재배포 시작" | tee -a $LOG_FILE
echo "시작 시간: $(date)" | tee -a $LOG_FILE
echo "=================================================================================" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

./deploy-v2.sh 2>&1 | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE
echo "=================================================================================" | tee -a $LOG_FILE
echo "배포 프로세스 완료" | tee -a $LOG_FILE
echo "완료 시간: $(date)" | tee -a $LOG_FILE
echo "=================================================================================" | tee -a $LOG_FILE
