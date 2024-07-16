(security find-certificate -a -p ls /System/Library/Keychains/SystemRootCertificates.keychain &&        security find-certificate -a -p ls /Library/Keychains/System.keychain) > $HOME/.mac-ca-roots
export AWS_CA_BUNDLE="$HOME/.mac-ca-roots"

aws s3api create-bucket \
    --bucket rshi017-kubernetes-aws-io\
    --create-bucket-configuration LocationConstraint=us-east-2

aws s3api put-bucket-versioning \
    --bucket rshi017-kubernetes-aws-io 
    --versioning-configuration Status=Enabled

export KOPS_STATE_STORE=s3://rshi0175-kubernetes-aws-io


aws s3api create-bucket \
    --bucket rshi017-com-oidc-store \
    --create-bucket-configuration LocationConstraint=us-east-2 \
    --object-ownership BucketOwnerPreferred
aws s3api put-public-access-block \
    --bucket rshi017-com-oidc-store \
    --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
aws s3api put-bucket-acl \
    --bucket rshi017-com-oidc-store \
    --acl public-read

export NAME=rshicluster.k8s.local

kops create cluster \
    --name=${NAME} \
    --cloud=aws \
    --zones=us-east-2a \
    --discovery-store=s3://rshi017-com-oidc-store/${NAME}/discovery


