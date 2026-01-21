#!/bin/bash
# Retail Demo Store 배포 상태 확인 스크립트

export AWS_PROFILE=profile2
REGION="us-east-1"
STACK_NAME="retaildemostore"

echo "=========================================="
echo "Retail Demo Store 배포 상태 확인"
echo "=========================================="
echo ""

# 스택 상태 확인
echo "📊 스택 상태:"
STATUS=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --region $REGION \
  --query 'Stacks[0].StackStatus' \
  --output text 2>&1)

if [ $? -eq 0 ]; then
  echo "  Status: $STATUS"
  echo ""

  # 완료된 경우 CloudFront URL 확인
  if [[ "$STATUS" == "CREATE_COMPLETE" ]]; then
    echo "✅ 배포가 완료되었습니다!"
    echo ""
    echo "🌐 CloudFront URL:"
    CLOUDFRONT_URL=$(aws cloudformation describe-stacks \
      --stack-name $STACK_NAME \
      --region $REGION \
      --query 'Stacks[0].Outputs[?OutputKey==`WebUICDN`].OutputValue' \
      --output text)

    if [ ! -z "$CLOUDFRONT_URL" ]; then
      echo "  https://$CLOUDFRONT_URL"
      echo ""
      echo "위 URL로 접속하여 Retail Demo Store를 확인하실 수 있습니다."
    fi

    echo ""
    echo "📝 모든 출력값:"
    aws cloudformation describe-stacks \
      --stack-name $STACK_NAME \
      --region $REGION \
      --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue]' \
      --output table

  elif [[ "$STATUS" == "CREATE_IN_PROGRESS" ]]; then
    echo "⏳ 배포가 진행 중입니다..."
    echo ""
    echo "최근 이벤트:"
    aws cloudformation describe-stack-events \
      --stack-name $STACK_NAME \
      --region $REGION \
      --max-items 10 \
      --query 'StackEvents[*].{Time:Timestamp,Resource:LogicalResourceId,Status:ResourceStatus}' \
      --output table

  elif [[ "$STATUS" == *"FAILED"* ]] || [[ "$STATUS" == *"ROLLBACK"* ]]; then
    echo "❌ 배포가 실패했습니다."
    echo ""
    echo "에러 확인:"
    aws cloudformation describe-stack-events \
      --stack-name $STACK_NAME \
      --region $REGION \
      --max-items 20 \
      --query 'StackEvents[?ResourceStatus==`CREATE_FAILED`].[LogicalResourceId,ResourceStatusReason]' \
      --output table
  fi
else
  echo "❌ 스택을 찾을 수 없습니다."
  echo "Error: $STATUS"
fi

echo ""
echo "=========================================="
