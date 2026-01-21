#!/bin/bash

echo "=== 롤백 완료 대기 중 ==="
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
        echo "$(date +%H:%M:%S) - 스택이 삭제되었습니다."
        break
    fi

    echo "$(date +%H:%M:%S) - 현재 상태: $STATUS"

    if [ "$STATUS" = "ROLLBACK_COMPLETE" ]; then
        echo "$(date +%H:%M:%S) - 롤백이 완료되었습니다!"
        echo ""
        echo "다음 단계:"
        echo "1. 스택 삭제: aws cloudformation delete-stack --stack-name retaildemostore-v2 --profile profile2 --region us-east-1"
        echo "2. 재배포: ./deploy-v2.sh"
        break
    elif [ "$STATUS" = "ROLLBACK_FAILED" ]; then
        echo "$(date +%H:%M:%S) - 롤백 실패!"
        break
    fi

    sleep 30
done

echo ""
echo "완료 시간: $(date +%H:%M:%S)"
