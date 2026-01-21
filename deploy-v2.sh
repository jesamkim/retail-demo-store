#!/bin/bash
export AWS_PROFILE=profile2

echo "=== Retail Demo Store v2 배포 시작 ==="
echo "시작 시간: $(date '+%H:%M:%S')"
echo ""

aws cloudformation deploy \
  --template-file ./aws/cloudformation-templates/template.yaml \
  --stack-name retaildemostore-v2 \
  --capabilities CAPABILITY_NAMED_IAM \
  --region us-east-1 \
  --parameter-overrides \
  ResourceBucket="retail-demo-store-658492570831" \
  SourceDeploymentType="S3" \
  ResourceBucketRelativePath="" \
  CreateOpenSearchServiceLinkedRole="No" \
  PreCreatePersonalizeResources="Yes" \
  PreIndexOpenSearch="No" \
  AlexaSkillId="" \
  AlexaDefaultSandboxEmail="" \
  mParticleSecretKey="" \
  AmazonPayPublicKeyId="" \
  mParticleApiKey="" \
  mParticleS2SSecretKey="" \
  mParticleS2SApiKey="" \
  mParticleOrgId="" \
  GoogleAnalyticsMeasurementId="" \
  PinpointSMSLongCode="" \
  PinpointEmailFromAddress="" \
  SegmentWriteKey="" \
  AmazonPayPrivateKey="" \
  AmazonPayStoreId="" \
  AmazonPayMerchantId="" \
  OptimizelySdkKey="" \
  GitHubToken="" \
  AmplitudeApiKey="" \
  ACMCertificateArn=""

echo ""
echo "배포 완료 시간: $(date '+%H:%M:%S')"
