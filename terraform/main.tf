terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type = string
}

variable "application_name" {
  type = string
}

variable "github_oauth_token" {
  type = string
}

variable "github_user" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "github_branch" {
  type = string
}

# resource "aws_codepipeline" "codepipeline" {
#   name     = var.application_name
#   role_arn = aws_iam_role.codepipeline_role.arn
# }

resource "aws_iam_role" "codepipeline_role" {
  name = format("codepipeline-role-%s", var.application_name)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = format("codepipeline-policy-%s", var.application_name)
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [ "s3:GetBucketVersioning" ],
      "Resource": [ "arn:aws:s3:::${aws_s3_bucket.artifact_s3_bucket.arn}" ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject"
      ],
      "Resource": [ "arn:aws:s3:::${aws_s3_bucket.artifact_s3_bucket.arn}/*" ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "codedeploy:CreateDeployment",
            "codedeploy:GetApplicationRevision",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:RegisterApplicationRevision"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "cloudformation:CreateStack",
            "cloudformation:DeleteStack",
            "cloudformation:DescribeStacks",
            "cloudformation:UpdateStack",
            "cloudformation:CreateChangeSet",
            "cloudformation:DeleteChangeSet",
            "cloudformation:DescribeChangeSet",
            "cloudformation:ExecuteChangeSet",
            "cloudformation:SetStackPolicy",
            "cloudformation:ValidateTemplate",
            "iam:PassRole"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "artifact_s3_bucket" {
  bucket = format("artifact-s3-bucket-%s", var.application_name)
  acl    = "private"
}
