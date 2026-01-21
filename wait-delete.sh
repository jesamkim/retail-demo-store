#!/bin/bash

echo "=== 스택 삭제 완료 대기 중 ==="
echo "시작 시간: $(date +%H:%M:%S)"
echo ""

while true; do
    STATUS=$(aws cloudformation describe-stacks \
        --stack-name retaildemostore-v2 \
        --profile profile2 \
        --region us-east-1 \
        --query 'Stacks[0].StackStatus' \
        --output text 2>&1)

    if [[ "$STATUS" == *"does not exist"* ]]; then
        echo "$(date +%H:%M:%S) - ✅ 스택이 완전히 삭제되었습니다!"
        echo ""
        echo "==================================================="
        echo "다음 단계: 수정된 설정으로 재배포"
        echo "==================================================="
        echo ""
        echo "실행 명령: ./deploy-v2.sh"
        echo ""
        echo "수정된 내용:"
        echo "  - Lambda Timeout: 600초 → 900초"
        echo "  - max_retries: 15회 → 30회 (최대 15분 대기)"
        echo ""
        break
    fi

    echo "$(date +%H:%M:%S) - 현재 상태: $STATUS"

    if [ "$STATUS" = "DELETE_FAILED" ]; then
        echo "$(date +%H:%M:%S) - ❌ 삭제 실패!"
        break
    fi

    sleep 30
done

echo "완료 시간: $(date +%H:%M:%S)"
